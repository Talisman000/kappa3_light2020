from inst import Inst, asm, print_asm, print_ihex

program = [
    Inst.ADDI(branch_result, step, 0b111),
    Inst.LBNE(branch_result, 0, 'slot1,2,3'),
    Inst.ADDI(branch_result, step, 0b011),
    Inst.LBNE(branch_result, 0, 'slot2,3'),
    Inst.ADDI(branch_result, step, 0b101),
    Inst.LBNE(branch_result, 0, 'slot1,3'),
    Inst.ADDI(branch_result, step, 0b110),
    Inst.LBNE(branch_result, 0, 'slot1,2'),
    'return',

    'slot2,3',
    Inst.LBEQ(slot2_counter, slot3_counter, 'reach'),
    Inst.LJAL(0, 'return'),
    'slot1,3',
    Inst.LBEQ(slot1_counter, slot3_counter, 'reach'),
    Inst.LJAL(0, 'return'),
    'slot1,2',
    Inst.LBEQ(slot1_counter, slot2_counter, 'reach'),
    Inst.LJAL(0, 'return'),
    'reach',
    Inst.LUI(20, 0x04000000),
    Inst.ADDI(21, 0, 0x01),
    Inst.ADDI(22, 0, 0b00000001),
    Inst.ADDI(25, 0, 0b10000000),
    'loop'
    Inst.SB(20, 22, 0x40),
    Inst.SB(20, 22, 0x42),
    Inst.SB(20, 22, 0x44),
    Inst.SB(20, 22, 0x46),
    Inst.SB(20, 25, 0x41),
    Inst.SB(20, 25, 0x43),
    Inst.SB(20, 25, 0x45),
    Inst.SB(20, 25, 0x47),
    Inst.SLL(22, 22, 21),
    Inst.SRL(25, 25, 21),
    Inst.LBNE(22, 0, 'loop'),
    Inst.LJAL(0, 'return')
    #reach end
    'slot1,2,3',
    Inst.BEQ(slot1_counter, slot2_counter, 0x08),
    Inst.LJAL(0, 'return'),
    Inst.LBEQ(slot2_counter, slot3_counter, 'bingo'),
    Inst.LJAL(0, 'return'),
    'bingo',
    Inst.LUI(20, 0x04000000),
    Inst.ADDI(23,20,0x40),
    'mode 0',
    Inst.ADDI(24,0,0b01010101),
    Inst.SB(23,24,0x00),
    Inst.SB(23,24,0x01),
    Inst.SB(23,24,0x04),
    Inst.SB(23,24,0x05),
    Inst.ADDI(24,0,0b10101010),
    Inst.SB(23,24,0x02),
    Inst.SB(23,24,0x03),
    Inst.SB(23,24,0x06),
    Inst.SB(23,24,0x07),
    Inst.LJAL(0,'mode 1'),
    'mode 1',
    Inst.ADDI(24,0,0b10101010),
    Inst.SB(23,24,0x00),
    Inst.SB(23,24,0x01),
    Inst.SB(23,24,0x04),
    Inst.SB(23,24,0x05),
    Inst.ADDI(24,0,0b01010101),
    Inst.SB(23,24,0x02),
    Inst.SB(23,24,0x03),
    Inst.SB(23,24,0x06),
    Inst.SB(23,24,0x07),
    Inst.LJAL(0,'mode 0'),
]

r = asm(program)
print_asm(r)
print()
print_ihex(r)