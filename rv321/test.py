# 0~9をループするカウンタ
## わかっているクソ仕様
## SBを一回使用した後にADDIを実行すると機能しない。
## これを回避するためにはダミーのSBが必要。 


from inst import Inst, asm, print_asm, print_ihex

program = [
# Store 7seg led patterns
Inst.LUI(5, 0x10001000), # memory = 0x10001000
Inst.ADDI(6, 0, 0b11111100), # 7seg: 0
Inst.SB(5, 6, 0x0),

Inst.SB(5, 6, 0x1),#dummySB
Inst.ADDI(6, 0, 0b01100000), # 1
Inst.SB(5, 6, 0x1),

Inst.SB(5, 6, 0x2),#dummySB
Inst.ADDI(6, 0, 0b11011010), # 2
Inst.SB(5, 6, 0x2),

Inst.SB(5, 6, 0x3),#dummySB
Inst.ADDI(6, 0, 0b11110010), # 3
Inst.SB(5, 6, 0x3),

Inst.SB(5, 6, 0x4),#dummySB
Inst.ADDI(6, 0, 0b01100110), # 4
Inst.SB(5, 6, 0x4),

Inst.SB(5, 6, 0x5),#dummySB
Inst.ADDI(6, 0, 0b10110110), # 5
Inst.SB(5, 6, 0x5),

Inst.SB(5, 6, 0x6),#dummySB
Inst.ADDI(6, 0, 0b10111110), # 6
Inst.SB(5, 6, 0x6),

Inst.SB(5, 6, 0x7),#dummySB
Inst.ADDI(6, 0, 0b11100000), # 7
Inst.SB(5, 6, 0x7),

Inst.SB(5, 6, 0x8),#dummySB
Inst.ADDI(6, 0, 0b11111110), # 8
Inst.SB(5, 6, 0x8),

Inst.SB(5, 6, 0x9),#dummySB
Inst.ADDI(6, 0, 0b11110110), # 9
Inst.SB(5, 6, 0x9),

Inst.SB(5, 6, 0xa),#dummySB
# Main
Inst.LUI(6, 0x04000000),
Inst.ADDI(1,1,1),
Inst.LBU(8,5,0),
Inst.SB(6,8,0),
Inst.SB(6,8,0),
Inst.SB(6,8,0x10),
Inst.SB(6,8,0x10),
Inst.SB(6,8,0x20),
Inst.SB(6,8,0x20),
Inst.SB(6,8,4),
Inst.SB(6,8,4),
Inst.SB(6,8,0x14),
Inst.SB(6,8,0x14),
Inst.SB(6,8,0x24),
Inst.SB(6,8,0x24),
Inst.SB(6,8,8),
Inst.SB(6,8,8),
Inst.SB(6,8,0x18),
Inst.SB(6,8,0x18),
Inst.SB(6,8,0x28),
Inst.SB(6,8,0x28),
]

r = asm(program)
print_asm(r)
print()
print_ihex(r)
