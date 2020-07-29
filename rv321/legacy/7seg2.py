from inst import Inst, asm, print_asm, print_ihex

program = [  
    Inst.LUI(5, 0x04000000),
    Inst.ADDI(6, 0, 0xFF),   
    Inst.LW(10, 5, 0x48),     
    Inst.ANDI(11,10,0x01),
    Inst.BEQ(11,0,0x08),
    Inst.SB(5,6,0x000),
    Inst.JAL(0,4),
    Inst.SB(5,0,0x000),
    Inst.JAL(0,-28)
]

r = asm(program)
print_asm(r)
print()
print_ihex(r)