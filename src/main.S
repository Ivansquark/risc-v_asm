#include "riscv_encoding.h"
##include "gd32vf103.h"
##include "usart.h"

#RCU base address: 0x4002 1000
# APB2 enable register (RCU_APB2EN) Address offset: 0x18 => 0x4002 1018
.equ RCU_APB2EN, 0x40021018
.equ RCU_APB2EN_PCEN, (1<<4) #Port_C eanble
.equ GPIOC_CTL0, 0x40011000
.equ GPIOC_CTL1, 0x40011004 
.equ GPIO_MASK, 0b1111
.equ GPIO_HIZ,		0b0100
.equ GPIO_APP50,	0b1011
.equ GPIO_PP_50MHz, 0b0011
.equ GPIOC_BOP,  0x40011010 # atomic set/reset pin

#_____________ USART0 ______________________________
.equ ECLIC_ADDR_BASE, 0xd2000000
.equ ECLIC_INT_IP_OFFSET, 0x1000
.equ ECLIC_INT_IE_OFFSET, 0x1001
.equ ECLIC_INT_ATTR_OFFSET, 0x1002
.equ USART0_IRQn, 56

.equ RCU_APB2EN_AFEN, (1<<0)
.equ RCU_APB2EN_PAEN, (1<<2)
.equ RCU_APB2EN_USART0EN, (1<<14)
.equ GPIOA_BASE, 0x40010800
.equ GPIOA_CTL0, (GPIOA_BASE + 0x00)
.equ GPIOA_CTL1, (GPIOA_BASE + 0x04)

.equ USART0_BASE, 0x40013800
.equ USART_BAUD_OFFSET, 0x08
.equ USART_CTL0_OFFSET, 0x0C
.equ USART_DATA_OFFSET, 0x04
.equ USART_STAT_OFFSET, 0x00

.equ USART_CTL0_REN, (1<<2)
.equ USART_CTL0_TEN, (1<<3)
.equ USART_CTL0_UEN, (1<<13)
.equ USART_CTL0_TBEIE, (1<<7)
.equ USART_CTL0_RBNEIE, (1<<5) 
.equ USART_STAT_TBE, (1<<7)
.equ USART_STAT_RBNE,(1<<5)

#GPIOA
.equ UART0_TX, 9
.equ UART0_RX, 10

.macro push val
  addi sp, sp, -4
  sw \val, 0(sp)
.endm
.macro pop val
  lw \val, 0(sp)
  addi sp, sp, 4
.endm

.text
.global main
main:  
#RCU_APB2EN |= RCU_APB2EN_PBEN
  la a5, RCU_APB2EN
    lw    a4, 0(a5)
    ori a4, a4, RCU_APB2EN_PCEN
  sw    a4, 0(a5)

  la t0, RCU_APB2EN
  lw	t1, 0(t0)
    la t2, RCU_APB2EN_AFEN | RCU_APB2EN_PAEN | RCU_APB2EN_USART0EN
    or	t1, t1, t2
  sw	t1, 0(t0)

  # P_C13 - RED GPIOC base address : 0x4001 1000
  # CTL:00-MD:11 in << 20 (CTL13:MD13)
  la a5, GPIOC_CTL1
  lw  a4, 0(a5)                         # load from reg
    la  a6, ~(GPIO_MASK << (20))        # set mask in pC13  0b1111 1111 0000 1111 ...
    and a3, a4, a6                      # clear bits in reg      
    la  a4, (GPIO_PP_50MHz << (20))     # set PC13 push pull in clear reg 0b0000 0000 0011 0000 ...
    or    a4, a4, a3                    # set PC13 push pull
  sw  a4, 0(a5)                         # write in reg

  la t0, GPIOA_CTL1
  lw	t1, 0(t0)
    la  t2, ~(GPIO_MASK << ((UART0_RX-8)*4) | GPIO_MASK << ((UART0_TX-8)*4))
    and t3, t1, t2
    la  t1, (GPIO_HIZ << ((UART0_RX-8)*4) | GPIO_APP50 << ((UART0_TX-8)*4))
    or    t1, t1, t3
  sw	t1, 0(t0)
  


  la t0, USART0_BASE
  li t1, (8000000 - 4800) / 9600
  sw t1, USART_BAUD_OFFSET(t0)
  li t1, USART_CTL0_UEN | USART_CTL0_REN | USART_CTL0_TEN | USART_CTL0_RBNEIE
  sw t1, USART_CTL0_OFFSET(t0)

  # Локальное разрешение прерывания USART0 (eclic_int_ie[i] = 1)
  la t0, (ECLIC_ADDR_BASE + ECLIC_INT_IE_OFFSET + USART0_IRQn*4)
    la t1, 1
  sb t1, 0(t0)
  # Использование векторизованного режима обработки (eclic_int_attr[i] = 1)
  la t0, (ECLIC_ADDR_BASE+ECLIC_INT_ATTR_OFFSET+USART0_IRQn*4)
    la t1, 1
  sw t1, 0(t0)

  #глобальное разрешение прерываний
  csrrs zero, CSR_MSTATUS, MSTATUS_MIE

MAIN_LOOP:

  la t0, USART0_BASE
  li t1, 'S'
  sb t1, USART_DATA_OFFSET(t0)

  la a5, GPIOC_BOP
  lw a4, 0(a5)
    li a3, 1
    slli a3, a3, 29
    or a4, a4, a3
  sw a4, 0(a5)
  
  la a0, 500000
  call sleep

  la a5, GPIOC_BOP
  lw a4, 0(a5)
    li a3, 1
    slli a3, a3, 13
    or a4, a4, a3
  sw a4, 0(a5)

  la a0, 500000
  call sleep

j MAIN_LOOP

sleep:
  push ra
  push s0   #must save value in that register on stack cause ('ll use it, but at end register must be the same)

  mv s0, a0
loop:  
  addi a0, a0, -1  
  bnez a0, loop # if t0 != t1 then target
  pop s0
  pop ra
ret

.global USART0_IRQn_handler
USART0_IRQn_handler:
  push t0
  push a0
  la t0, USART0_BASE
  la a0, USART_CTL0_UEN | USART_CTL0_REN | USART_CTL0_TEN
  sw a0, USART_CTL0_OFFSET(t0)
  la a0, 'U'
  sw a0, USART_DATA_OFFSET(t0)
  while_loop:
  la a6, while_loop
  jalr 0(a6) 
  pop a0
  pop t0
mret