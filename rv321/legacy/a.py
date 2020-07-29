from inst import Inst, asm, print_asm, print_ihex

program = [
Inst.LUI(5, 0x10000000), # memory = 0x10000000
Inst.ADD(6, 0, 0), # x6 = 0 (counter)
'loop',
Inst.SW(5, 6, 0x100), # memory[x5+0x100] = x6
Inst.ADDI(6, 6, 1), # x6++
Inst.LJAL(0, 'loop') # goto loop
]

r = asm(program)
print_asm(r)
print()
print_ihex(r)