from inst import Inst, asm, print_asm, print_ihex

rd = []
for i in range(50):
    rd.append(i)

rs = []
for i in range(50):
    rs.append(i)

seg_pattern = [0xFC,0x60,0xDA,0xF2,0x66,0xB6,0xBE,0xE0,0xFE,0xF6]

program = [
    Inst.LUI(5,0x10001000),
]

for i in range(10):
    program.append(Inst.ADDI(rd[6],rs[0],seg_pattern[i]))
    program.append(Inst.SB(rd[5],rs[6],i))

program_main = [    
    Inst.LUI(rd[6], 0x04000000),
    Inst.ADD(rd[7],rs[0],rs[0]), 
    Inst.LW(rd[10], rs[6], 0x48),
    'mainloop',
    Inst.ADD(rd[8],rs[7],rs[5]),
    Inst.ANDI(rd[11],rs[10],0x01),
    Inst.LBEQ(rd[11],0,'dontpush'),

    'push',
    Inst.LBU(rd[9],rs[8],0),
    Inst.SB(rd[6],rs[9],0x000),
    Inst.ADDI(rd[7],rs[7],1),
    Inst.LJAL(0,'mainloop'),
    'dontpush',
    Inst.SB(rd[6],rs[9],0x000),
    Inst.LJAL(0,'mainloop')
]

program.extend(program_main)

r = asm(program)
print_asm(r)
print()
print_ihex(r)