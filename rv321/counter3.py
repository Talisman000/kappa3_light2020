from inst import Inst, asm, print_asm, print_ihex

program = [
# Store 7seg led patterns
Inst.LUI(5, 0x10001000), # memory = 0x10001000
Inst.ADDI(6, 0, 0b11111100), # 7seg: 0
Inst.SB(5, 6, 0x0),
Inst.ADDI(6, 0, 0b01100000), # 1
Inst.SB(5, 6, 0x1),
Inst.ADDI(6, 0, 0b11011010), # 2
Inst.SB(5, 6, 0x2),
Inst.ADDI(6, 0, 0b11110010), # 3
Inst.SB(5, 6, 0x3),
Inst.ADDI(6, 0, 0b01100110), # 4
Inst.SB(5, 6, 0x4),
Inst.ADDI(6, 0, 0b10110110), # 5
Inst.SB(5, 6, 0x5),
Inst.ADDI(6, 0, 0b10111110), # 6
Inst.SB(5, 6, 0x6),
Inst.ADDI(6, 0, 0b11100000), # 7
Inst.SB(5, 6, 0x7),
Inst.ADDI(6, 0, 0b11111110), # 8
Inst.SB(5, 6, 0x8),
Inst.ADDI(6, 0, 0b11110110), # 9
Inst.SB(5, 6, 0x9),
# Main
Inst.LUI(6, 0x04000000),
Inst.ADD(7, 0, 0), # x7 = 0 (counter)
’loop’,
Inst.ADD(8, 7, 5), # address of memory[x7]
Inst.LBU(9, 8, 0), # x9 = memory[x7]
Inst.SB(6, 9, 0),
Inst.ADDI(7, 7, 1), # x7++
Inst.LJAL(0, ’loop’) # goto loop
]

r = asm(program)
print_asm(r)
print()
print_ihex(r)