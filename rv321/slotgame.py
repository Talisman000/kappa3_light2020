# 0~slot1_memoryをループするカウンタ
## わかっているクソ仕様
## ・SBを一回使用した後にADDIを実行すると機能しない。
## 　これを回避するためにはダミーのSBが必要。
## ・レジスタは30以上を指定したらうまく動かなかった

from inst import Inst, asm, print_asm, print_ihex

# 7segのパターン代入

# list_seg_patterns = [0xFC, 0x60, 0xDA, 0xF2, 0x66, 0xB6, 0xBE, 0xE0, 0xFE, 0xF6]
# seg_patterns_mem = 1
# seg_pattern = 2

# program = [
#     # Store 7seg led patterns
#     Inst.LUI(seg_patterns_mem, 0x10001000),  # memory = 0x10001000
# ]


# for i in range(10):
#     program.append(Inst.ADDI(seg_pattern, 0, list_seg_patterns[i]))
#     program.append(Inst.SB(seg_patterns_mem, seg_pattern, i))
#     program.append(Inst.SB(seg_patterns_mem, seg_pattern, i + 1))  # dummySB

#from num2mem

program = [
  Inst.LUI(8,0x10001000),
  Inst.LUI(9,0xE0808000),#0
  Inst.ADDI(9,9,0x08C),
  Inst.SW(8,9,0x0),
  Inst.SW(8,9,0x0),
  Inst.LUI(9,0x60000000),
  Inst.ADDI(9,9,0x00C),
  Inst.SW(8,9,0x04),
  Inst.SW(8,9,0x04),
  Inst.LUI(9,0x70101000),
  Inst.ADDI(9,9,0x01C),
  Inst.SW(8,9,0x08),
  Inst.SW(8,9,0x08),
  Inst.LUI(9, 0x0000e000),#1
  Inst.ADDI(9,9,0x000),
  Inst.SW(8,9,0x0C),
  Inst.SW(8,9,0x0C),
  Inst.LUI(9,0x00006000),
  Inst.ADDI(9,9,0x000),
  Inst.SW(8,9,0x10),
  Inst.SW(8,9,0x10),
  Inst.LUI(9,0x00107000),
  Inst.ADDI(9,9,0x001),
  Inst.SW(8,9,0x14),
  Inst.SW(8,9,0x14),
  Inst.LUI(9, 0xE0808000),#2
  Inst.ADDI(9, 9, 0x080),
  Inst.SW(8, 9, 0x18),
  Inst.SW(8, 9, 0x18),
  Inst.LUI(9, 0x42020000),
  Inst.ADDI(9, 9, 0x20A),
  Inst.SW(8, 9, 0x1C),
  Inst.SW(8, 9, 0x1C),
  Inst.LUI(9, 0x10101000),
  Inst.ADDI(9, 9, 0x01C),
  Inst.SW(8, 9, 0x20),
  Inst.SW(8, 9, 0x20),
  Inst.LUI(9,0xE0808000),#3
  Inst.ADDI(9,9,0x080),
  Inst.SW(8,9,0x24),
  Inst.SW(8,9,0x0),
  Inst.LUI(9,0x62020000),
  Inst.ADDI(9,9,0x202),
  Inst.SW(8,9,0x28),
  Inst.SW(8,9,0x28),
  Inst.LUI(9,0x70101000),
  Inst.ADDI(9,9,0x010),
  Inst.SW(8,9,0x2C),
  Inst.SW(8,9,0x2C),
  Inst.LUI(9,0x60000000),#4
  Inst.ADDI(9,9,0x00C),
  Inst.SW(8,9,0x30),
  Inst.SW(8,9,0x30),
  Inst.LUI(9,0x62020000),
  Inst.ADDI(9,9,0x206),
  Inst.SW(8,9,0x34),
  Inst.SW(8,9,0x34),
  Inst.LUI(9,0x60000000),
  Inst.SW(8,9,0x38),
  Inst.SW(8,9,0x38),
  Inst.LUI(9,0x80808000),#5
  Inst.ADDI(9,9,0x08C),
  Inst.SW(8,9,0x3C),
  Inst.SW(8,9,0x3C),
  Inst.LUI(9,0x22020000),
  Inst.ADDI(9,9,0x206),
  Inst.SW(8,9,0x40),
  Inst.SW(8,9,0x40),
  Inst.LUI(9,0x70101000),
  Inst.ADDI(9,9,0x010),
  Inst.SW(8,9,0x44),
  Inst.SW(8,9,0x44),
  Inst.LUI(9,0x80808000),#6
  Inst.ADDI(9,9,0x20E),
  Inst.SW(8,9,0x48),
  Inst.SW(8,9,0x48),
  Inst.LUI(9,0x22020000),
  Inst.ADDI(9,9,0x20E),
  Inst.SW(8,9,0x4C),
  Inst.SW(8,9,0x4C),
  Inst.LUI(9,0x70101000),
  Inst.ADDI(9,9,0x02C),
  Inst.SW(8,9,0x50),
  Inst.SW(8,9,0x50),
  Inst.LUI(9,0xE0808000),#7
  Inst.ADDI(9,9,0x080),
  Inst.SW(8,9,0x54),
  Inst.SW(8,9,0x54),
  Inst.LUI(9,0x60000000),
  Inst.SW(8,9,0x58),
  Inst.SW(8,9,0x58),
  Inst.SW(8,9,0x5C),
  Inst.SW(8,9,0x5C),
  Inst.LUI(9,0xE0808000),#8
  Inst.ADDI(9,9,0x08C),
  Inst.SW(8,9,0x060),
  Inst.SW(8,9,0x060),
  Inst.LUI(9,0x62020000),
  Inst.ADDI(9,9,0x20E),
  Inst.SW(8,9,0x64),
  Inst.SW(8,9,0x64),
  Inst.LUI(9,0x70101000),
  Inst.ADDI(9,9,0x01C),
  Inst.SW(8,9,0x68),
  Inst.SW(8,9,0x68),
  Inst.LUI(9,0xE0808000),#9
  Inst.ADDI(9,9,0x08C),
  Inst.SW(8,9,0x6C),
  Inst.SW(8,9,0x6C),
  Inst.LUI(9,0x62020000),
  Inst.ADDI(9,9,0x206),
  Inst.SW(8,9,0x70),
  Inst.SW(8,9,0x70),
  Inst.LUI(9,0x70101000),
  Inst.ADDI(9,9,0x010),
  Inst.SW(8,9,0x74),
  Inst.SW(8,9,0x74)
]

seg_patterns_mem = 8

# スロット部分

seg_led = 3
counter_max = 4
push_switch = 5
branch_result = 6
step = 7

slot1_init = 0x0
slot1_counter = 11
slot1_memory = 12

slot2_init = 0x18
slot2_counter = 13
slot2_memory = 14

slot3_init = 0x54
slot3_counter = 15
slot3_memory = 16

tmp_memory_addr = 17

program_main = [
    # 初期化
        Inst.ADDI(slot1_counter, 0, slot1_init),
        Inst.ADDI(slot2_counter, 0, slot2_init),
        Inst.ADDI(slot3_counter, 0, slot3_init),
        Inst.ADDI(counter_max, 0, 0x6c),
        Inst.ADDI(step,0,0),
    # ループ部分
    "input1", 
        #すでにslot1のスイッチが押されていたならばslot1の処理をスキップ
        #slot1は001、slot2は010、slot3は100をAND演算
        Inst.ANDI(branch_result,step,0b001),
        Inst.LBNE(branch_result,0,"input2"),
        #slot1のスイッチの処理：押されていれば001を加算
        Inst.LUI(seg_led, 0x04000000),#seg_led初期化
        Inst.LW(push_switch,seg_led,0x48),
        Inst.ANDI(branch_result,push_switch,0b00001),
        Inst.LBEQ(branch_result,0,"slot1"),
        Inst.ADDI(step,step,0b001),
    "slot1",
        #対応する7segにcounterの値を表示する
        Inst.ADD(tmp_memory_addr, slot1_counter, seg_patterns_mem),
        Inst.LW(slot1_memory, tmp_memory_addr, 0),
        Inst.LUI(seg_led, 0x04000000),#seg_led初期化
        Inst.SW(seg_led,slot1_memory,0),# dummySW
        Inst.SW(seg_led,slot1_memory,0),
        Inst.ADDI(seg_led,seg_led,0x10),
        Inst.LW(slot1_memory, tmp_memory_addr, 0x4),
        Inst.SW(seg_led,slot1_memory,0),# dummySW
        Inst.SW(seg_led,slot1_memory,0),
        Inst.ADDI(seg_led,seg_led,0x10),
        Inst.LW(slot1_memory, tmp_memory_addr, 0x8),
        Inst.SW(seg_led,slot1_memory,0),# dummySW
        Inst.SW(seg_led,slot1_memory,0),
        # Inst.SB(seg_led, slot1_memory, 0),  # dummySB
        # Inst.SB(seg_led, slot1_memory, 0),

        #counterが1~8のとき->counter++　counterが9のとき->counter = 0
        #counterをループさせるための処理です
        Inst.LBEQ(slot1_counter, counter_max, "slot1_reset"),
    "slot1_add",
        #segパターンの先頭アドレスを参照するため、counterは12ずつ加算
        Inst.ADDI(slot1_counter, slot1_counter, 0xc),
        Inst.LJAL(0, "input2"),  # goto input22
    "slot1_reset",
        Inst.ADDI(slot1_counter, 0, 0),
    "input2",
        #すでにslot2のスイッチが押されていたならばslot2の処理をスキップ   
        Inst.ANDI(branch_result,step,0b010),
        Inst.LBNE(branch_result,0,"input3"),
        #slot2のスイッチの処理：押されていれば010を加算
        Inst.LUI(seg_led, 0x04000000),#seg_led初期化
        Inst.LW(push_switch,seg_led,0x48),
        Inst.ANDI(branch_result,push_switch,0b00010),
        Inst.LBEQ(branch_result,0,"slot2"),
        Inst.ADDI(step,step,0b010),
    "slot2",
        #対応する7segにcounterの値を表示する
        Inst.ADD(tmp_memory_addr, slot2_counter, seg_patterns_mem),
        Inst.LW(slot2_memory, tmp_memory_addr, 0),        
        Inst.LUI(seg_led, 0x04000004),#seg_led初期化
        Inst.SW(seg_led,slot2_memory,0),# dummySW
        Inst.SW(seg_led,slot2_memory,0),
        Inst.ADDI(seg_led,seg_led,0x10),
        Inst.LW(slot2_memory, tmp_memory_addr, 0x4),
        Inst.SW(seg_led,slot2_memory,0x4),# dummySW
        Inst.SW(seg_led,slot2_memory,0x4),
        Inst.ADDI(seg_led,seg_led,0x10),
        Inst.LW(slot2_memory, tmp_memory_addr, 0x8),
        Inst.SW(seg_led,slot2_memory,0x8),# dummySW
        Inst.SW(seg_led,slot2_memory,0x8),
        # Inst.SB(seg_led, slot2_memory, 1),  # dummySB
        # Inst.SB(seg_led, slot2_memory, 1),
        #counterが1~8のとき->counter++　counterが9のとき->counter = 0
        Inst.LBEQ(slot2_counter, counter_max, "slot2_reset"),
    "slot2_add",
        Inst.ADDI(slot2_counter, slot2_counter, 0xc),
        Inst.LJAL(0, "input3"),  # goto input3
    "slot2_reset",
        Inst.ADDI(slot2_counter, 0, 0),
    "input3",
        #すでにslot3のスイッチが押されていたならばslot3の処理をスキップ   
        Inst.ANDI(branch_result,step,0b100),
        Inst.LBNE(branch_result,0,"input1"),
        #slot3のスイッチの処理：押されていれば100を加算
        Inst.LUI(seg_led, 0x04000000),#seg_led初期化
        Inst.LW(push_switch,seg_led,0x48),
        Inst.ANDI(branch_result,push_switch,0b00100),
        Inst.LBEQ(branch_result,0,"slot3"),
        Inst.ADDI(step,step,0b100),
    "slot3",
        #対応する7segにcounterの値を表示する
        Inst.ADD(tmp_memory_addr, slot3_counter, seg_patterns_mem),
        Inst.LW(slot3_memory, tmp_memory_addr, 0),
        Inst.LUI(seg_led, 0x04000008),#seg_led初期化
        Inst.SW(seg_led,slot2_memory,0),# dummySW
        Inst.SW(seg_led,slot2_memory,0),
        Inst.ADDI(seg_led,seg_led,0x10),
        Inst.LW(slot3_memory, tmp_memory_addr, 0x4),
        Inst.SW(seg_led,slot2_memory,0x4),# dummySW
        Inst.SW(seg_led,slot2_memory,0x4),
        Inst.ADDI(seg_led,seg_led,0x10),
        Inst.LW(slot3_memory, tmp_memory_addr, 0x4),
        Inst.SW(seg_led,slot2_memory,0x8),# dummySW
        Inst.SW(seg_led,slot2_memory,0x8),
        # Inst.SB(seg_led, slot3_memory, 2),  # dummySB
        # Inst.SB(seg_led, slot3_memory, 2),
        #counterが1~8のとき->counter++　counterが9のとき->counter = 0
        Inst.LBEQ(slot3_counter, counter_max, "slot3_reset"),
    "slot3_add",
        Inst.ADDI(slot3_counter, slot3_counter, 0xc),
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
