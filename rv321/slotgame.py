# 0~slot1_memoryをループするカウンタ
## わかっているクソ仕様
## SBを一回使用した後にADDIを実行すると機能しない。
## これを回避するためにはダミーのSBが必要。

from inst import Inst, asm, print_asm, print_ihex

# seg led pattern

list_seg_patterns = [0xFC, 0x60, 0xDA, 0xF2, 0x66, 0xB6, 0xBE, 0xE0, 0xFE, 0xF6]
seg_patterns_mem = 5
seg_pattern = 6

program = [
    # Store 7seg led patterns
    Inst.LUI(seg_patterns_mem, 0x10001000),  # memory = 0x10001000
]


for i in range(10):
    program.append(Inst.ADDI(seg_pattern, 0, list_seg_patterns[i]))
    program.append(Inst.SB(seg_patterns_mem, seg_pattern, i))
    program.append(Inst.SB(seg_patterns_mem, seg_pattern, i + 1))  # dummySB

# slot main

seg_led = 6
counter_max = 7

slot1_init = 0x0
slot1_counter = 41
slot1_memory_addr = 42
slot1_memory = 43

slot2_init = 0x2
slot2_counter = 21
slot2_memory_addr = 22
slot2_memory = 23

slot3_init = 0x5
slot3_counter = 31
slot3_memory_addr = 32
slot3_memory = 33

program_main = [
    # Main
    Inst.LUI(seg_led, 0x04000000),
    Inst.ADDI(slot1_counter, 0, slot1_init),  # x7 = 0 (counter)
    Inst.ADDI(slot2_counter, 0, slot2_init),  # x7 = 0 (counter)
    Inst.ADDI(slot3_counter, 0, slot3_init),  # x7 = 0 (counter)
    Inst.ADDI(counter_max, 0, 9),
    "loop",
    Inst.ADD(slot1_memory_addr, slot1_counter, seg_patterns_mem),
    Inst.LBU(slot1_memory, slot1_memory_addr, 0),
    Inst.SB(seg_led, slot1_memory, 0),  # dummySB
    Inst.SB(seg_led, slot1_memory, 0),
    Inst.ADD(slot2_memory_addr, slot2_counter, seg_patterns_mem),
    Inst.LBU(slot2_memory, slot2_memory_addr, 0),
    Inst.SB(seg_led, slot2_memory, 1),  # dummySB
    Inst.SB(seg_led, slot2_memory, 1),
    Inst.ADD(slot3_memory_addr, slot3_counter, seg_patterns_mem),
    Inst.LBU(slot3_memory, slot3_memory_addr, 0),
    Inst.SB(seg_led, slot3_memory, 2),  # dummySB
    Inst.SB(seg_led, slot3_memory, 2),
    "slot1_add_1",
    Inst.LBEQ(slot1_counter, counter_max, "slot1_reset"),
    Inst.ADDI(slot1_counter, slot1_counter, 1),
    Inst.LJAL(0, "slot2_add_1"),  # goto slot2_add_1
    "slot1_reset",
    Inst.ADDI(slot1_counter, 0, 0),
    Inst.LJAL(0, "slot2_add_1"),  # goto slot2_add_1
    "slot2_add_1",
    Inst.LBEQ(slot2_counter, counter_max, "slot2_reset"),
    Inst.ADDI(slot2_counter, slot2_counter, 1),
    Inst.LJAL(0, "slot3_add_1"),  # goto slot3_add_1
    "slot2_reset",
    Inst.ADDI(slot2_counter, 0, 0),
    Inst.LJAL(0, "slot3_add_1"),  # goto slot3_add_1
    "slot3_add_1",
    Inst.LBEQ(slot3_counter, counter_max, "slot3_reset"),
    Inst.ADDI(slot3_counter, slot3_counter, 1),
    Inst.LJAL(0, "loop"),  # goto loop
    "slot3_reset",
    Inst.ADDI(slot3_counter, 0, 0),
    Inst.LJAL(0, "slot3_add_1"),  # goto loop
]

program.extend(program_main)

r = asm(program)
print_asm(r)
print()
print_ihex(r)
