# 0~slot1_memoryをループするカウンタ
## わかっているクソ仕様
## ・SBを一回使用した後にADDIを実行すると機能しない。
## 　これを回避するためにはダミーのSBが必要。
## ・レジスタは30以上を指定したらうまく動かなかった

from inst import Inst, asm, print_asm, print_ihex

# 7segのパターン代入

list_seg_patterns = [0xFC, 0x60, 0xDA, 0xF2, 0x66, 0xB6, 0xBE, 0xE0, 0xFE, 0xF6]
seg_patterns_mem = 1
seg_pattern = 2

program = [
    # Store 7seg led patterns
    Inst.LUI(seg_patterns_mem, 0x10001000),  # memory = 0x10001000
]


for i in range(10):
    program.append(Inst.ADDI(seg_pattern, 0, list_seg_patterns[i]))
    program.append(Inst.SB(seg_patterns_mem, seg_pattern, i))
    program.append(Inst.SB(seg_patterns_mem, seg_pattern, i + 1))  # dummySB

# スロット部分

seg_led = 3
counter_max = 4
push_switch = 5
branch_result = 6
step = 7

slot1_init = 0x0
slot1_counter = 11
slot1_memory = 12

slot2_init = 0x2
slot2_counter = 13
slot2_memory = 14

slot3_init = 0x5
slot3_counter = 15
slot3_memory = 16

tmp_memory_addr = 17

program_main = [
    # 初期化
    Inst.LUI(seg_led, 0x04000000),
    Inst.ADDI(slot1_counter, 0, slot1_init),
    Inst.ADDI(slot2_counter, 0, slot2_init),
    Inst.ADDI(slot3_counter, 0, slot3_init),
    Inst.ADDI(counter_max, 0, 9),
    Inst.ADDI(step,0,0),
    # ループ部分
    "input1",    
    Inst.ANDI(branch_result,step,0x001),
    Inst.LBNE(branch_result,0,"input2"),
    Inst.LW(push_switch,seg_led,0x48),
    Inst.ANDI(branch_result,push_switch,0x01),
    Inst.LBEQ(branch_result,0,"slot1"),
    Inst.ADDI(step,step,0b001),
    "slot1",
    Inst.ADD(tmp_memory_addr, slot1_counter, seg_patterns_mem),
    Inst.LBU(slot1_memory, tmp_memory_addr, 0),
    Inst.SB(seg_led, slot1_memory, 0),  # dummySB
    Inst.SB(seg_led, slot1_memory, 0),
    Inst.LBEQ(slot1_counter, counter_max, "slot1_reset"),
    "slot1_add_1",
    Inst.ADDI(slot1_counter, slot1_counter, 1),
    Inst.LJAL(0, "input2"),  # goto input22
    "slot1_reset",
    Inst.ADDI(slot1_counter, 0, 0),
    "input2",
    Inst.ANDI(branch_result,step,0x010),
    Inst.LBNE(branch_result,0,"input3"),
    Inst.LW(push_switch,seg_led,0x49),
    Inst.ANDI(branch_result,push_switch,0x01),
    Inst.LBEQ(branch_result,0,"slot2"),
    Inst.ADDI(step,step,0b010),
    "slot2",
    Inst.ADD(tmp_memory_addr, slot2_counter, seg_patterns_mem),
    Inst.LBU(slot2_memory, tmp_memory_addr, 0),
    Inst.SB(seg_led, slot2_memory, 1),  # dummySB
    Inst.SB(seg_led, slot2_memory, 1),
    Inst.LBEQ(slot2_counter, counter_max, "slot2_reset"),
    "slot2_add_1",
    Inst.ADDI(slot2_counter, slot2_counter, 1),
    Inst.LJAL(0, "input3"),  # goto input3
    "slot2_reset",
    Inst.ADDI(slot2_counter, 0, 0),
    "input3",
    Inst.ANDI(branch_result,step,0x100),
    Inst.LBNE(branch_result,0,"input1"),
    Inst.LW(push_switch,seg_led,0x4a),
    Inst.ANDI(branch_result,push_switch,0x01),
    Inst.LBEQ(branch_result,0,"slot3"),
    Inst.ADDI(step,step,0b100),
    "slot3",
    Inst.ADD(tmp_memory_addr, slot3_counter, seg_patterns_mem),
    Inst.LBU(slot3_memory, tmp_memory_addr, 0),
    Inst.SB(seg_led, slot3_memory, 2),  # dummySB
    Inst.SB(seg_led, slot3_memory, 2),
    Inst.LBEQ(slot3_counter, counter_max, "slot3_reset"),
    "slot3_add_1",
    Inst.ADDI(slot3_counter, slot3_counter, 1),
    Inst.LJAL(0, "input1"),  # goto input1
    "slot3_reset",
    Inst.ADDI(slot3_counter, 0, 0),
    Inst.LJAL(0, "input1"),  # goto input1
]

program.extend(program_main)

r = asm(program)
print_asm(r)
print()
print_ihex(r)
