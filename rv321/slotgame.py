# 0~9をループするカウンタ
## わかっているクソ仕様
## SBを一回使用した後にADDIを実行すると機能しない。
## これを回避するためにはダミーのSBが必要。 


from inst import Inst, asm, print_asm, print_ihex

seg_pattern = [0xFC,0x60,0xDA,0xF2,0x66,0xB6,0xBE,0xE0,0xFE,0xF6]

seg_led_patterns_mem = 5
seg_led_patterns = 6

program = [
# Store 7seg led patterns
Inst.LUI(seg_led_patterns_mem, 0x10001000), # memory = 0x10001000

]

for i in range(10):
    program.add(Inst.ADDI(seg_led_patterns, 0, seg_pattern[i]))
    program.add(Inst.SB(seg_led_patterns_mem, seg_led_patterns, i))
    program.add(Inst.SB(seg_led_patterns_mem, seg_led_patterns, i+1))#dummySB


program_main[
# Main
Inst.LUI(6, 0x04000000),
Inst.ADDI(7, 0, 0), # x7 = 0 (counter)
'loop',
Inst.ADD(8, 7, 5), # address of memory[x7]
Inst.LBU(9, 8, 0), # x9 = memory[x7]
Inst.SB(6, 9, 0),#dummySB
Inst.SB(6, 9, 0),
Inst.LBEQ(7,9,'reset'),
'add_1',
Inst.ADDI(7, 7, 1), # x7++
Inst.LJAL(0, 'loop'), # goto loop
'reset',
Inst.ADDI(7, 0, 0), 
Inst.LJAL(0, 'loop') # goto loop
]

program.extend(program_main)

r = asm(program)
print_asm(r)
print()
print_ihex(r)
