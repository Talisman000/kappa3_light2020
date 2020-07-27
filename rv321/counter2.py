from inst import Inst, asm, print_asm, print_ihex

seg_pattern = [0xFC,0x60,0xDA,0xF2,0x66,0xB6,0xBE,0xE0,0xFE,0xF6]

x_0 = 0
pattern_mem = 5
pattern_tmp = 6


program = [
    Inst.LUI(pattern_mem,0x10001000)
]

for i in range(10):
    print(seg_pattern[i])
    program.append(Inst.ADDI(pattern_tmp,0,seg_pattern[i]))
    program.append(Inst.SB(pattern_mem,pattern_tmp,i))

seg = 6
counter = 7
pattern_mem_addr = 8
pattern = 9
max = 15

program_main = [    
    'main',
    Inst.LUI(seg, 0x04000000),
    Inst.ADDI(counter,x_0,0),
    Inst.ADDI(max,x_0,9),
    'loop',
    Inst.ADD(pattern_mem_addr,counter,pattern_mem),
    Inst.LBU(pattern,pattern_mem_addr,0),
    Inst.SB(seg,pattern,0),
    Inst.ADDI(counter,counter,1),
    Inst.LBEQ(counter,max,'reset'),
    Inst.LJAL(x_0,'loop'),
    'reset',
    Inst.ADDI(20,x_0,0xFC),
    Inst.SB(seg,20,0),
    Inst.LJAL(x_0,'main')
]

program.extend(program_main)

r = asm(program)
print_asm(r)
print()
print_ihex(r)