pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
#include levelgen2.lua
#include players.lua
#include main.lua
__gfx__
000000000000aa00bbbbbbbb44444444677777764cccccccccccccccccccccc48888888888888888888888840000000000000000000000000000000000000000
00000000000a00a0bbbbbbbb44444444766666674cccccccccccccccccccccc48888888888888888888888840000000000000000000000000044000000000000
00700700000a00a04444444444444444766666674ccccccccccccccccccccc444888888888888888888888840000000000000000000000000444400000033000
000770000000aa0044444444444444447666666744ccccccccccccccccccc4444488888888888888888884440000000000000000004400000044440000333300
0007700000aa000044444444444444447666666744ccccccccccccccccc444444488888888888888888844440000000000000000004440000044440000333300
00700700000aa0004444444444444444766666674444cccccccccccccc4444444448888888888888888444440000000000000000004444000043444000033000
00000000000a0000444444444444444476666667444444ccccccccccc44444444444448884844488884444440000000000000000044444000043444400044000
0000000000a0a0004444444444444444677777764444444444444444444444444444444444444444444444440000000044444444444444444444444444444444
00000000343333353433343333444440044444403333335300000000333333533333333335300000000000000000000000060600000606000000000000000000
00033000333333b33344434333344440044444333333033300000000333333334333333333330000000000000000000000060600000606000000000000000000
00033300533434333430044334334440044444300333033300000033333533433344530033333000000000000000000000060600000666000000000000033000
0033b300033333333340043434433440044444400333333300003333033333443333330033333000000666666666660000060600000666000000000000333300
0035333043333333344443443444344004444340033333b300033333033333343333330033333000000606000006060000060600000060000000000000333300
03333330b3434333344334433344343333443340033b3443000333330003334333b3330034333300000606000006060000060600000080000000000000033000
03b35330333333333434444333343430034434400333334400333344000033333333030033333300000666000006660000060600000000000000000000044000
3333b333333334333334444334444330b3b4344b0033333400333334000000333300000043333330000606000006060000060600000000000000000044444444
002bb2000008e0000011110001cccc000bbb66b0000000000000aa008000000800000000000dd000000000000008000000888000000000000000660066666666
00bbbb00008eee00011cccc1001cccc004444440004470000000aa0008000080000cc000000dd00000aaaaa0008aaaa000890880066666600666666060000006
00bbbb00008eeee0011c7c7100aaaaaa44744744004750000000a9900088880000c66c000dddddd00aaaaa0008aaaa800449990006c66c600606606060700706
b03bb30b08eeeee0001c7c71000ffff044044044007770000aaaaa00088888800cccccc00d6dd6d00aaaa0000aaaa00008c9c880060660600606606060700706
0bbbbbb008e1e1e00011ccc1000f0f00444444440009000000aaaa00088008800c6cc6c00dddddd00aaaa0000aaaa00008c8c890066666600666666060000006
003bb30000eeee0e001cc110000ffff0444004440009970000aaaa0008888880cccccccc00d00d000aaaaa000aaaaa8000ccc000067a77600600006060777706
00bbbb000eee0e00001c110000f1111f04444440000100000009000008000080c6c66c6c0d0dd0d000aaaaa000aaaaa000c0c000066666600666666060000006
0bb33bb00e0e0ee00111000000010010004444000010100000099000008008000c0000c0d000000d000000000000000004404400000000000066660066666666
0000330000000000000000000000000000770000880088000000000000000000000000000004300000000000000000000aaaaaa00000000055515555767d6777
033bbb30004000400009990007777770007700008800880000046600006600000044700000044400000c00000000000000aaaa00000466605451555577404777
3bbbbbb3044000400009990007c00c7009970000008800880005460006666660044750000004000000cd00000000000000aaaa000005466055d66d5477424777
bbbbbbb304477400000999000700007000777770008800880004440000066000047770000004400000cd0000000ccc00000aa00000044460056666557740e777
bb0bbb0300444400000090000777777000777700880088000000200000066000040b0000000444000dccc0000cccccc00005500000002266015ddd1577d0d777
3bbbbbb300400400008888800007700000777700880088000042200000066660040bb700004444000ccccc0008cccca000055000004222000416615477d5d777
0bbbbbb000400400000080000070070000009000008800880000100006600000040b0000040400000ccccc000c0cc0c000055000000022005545544577d5d777
033333300000000000cc0cc0000000000009900000880088000101000000000040b0b0000004400000ccc000444444440005500000022222124ef42176667777
000000000004300000000000000000000aaaaaa0000000000000aa008000000800000000000dd000000000000008000000888000000000000000000000000000
0060006000044400000c00000000000000aaaa00004470000000aa0008000080000cc000000dd00000aaaaa0008aaaa000890880000666600666600006666000
066000600004000000cd00000000000000aaaa00044750000000a9900088880000c66c000dddddd00aaaaa0008aaaa8004499900006666600600660006666600
066666000004400000cd0000000ccc00000aa000047770000aaaaa00088888800cccccc00d6dd6d00aaaa0000aaaa00008c9c880066666600600066006666660
00666600000444000dccc0000cccccc000055000040b000000aaaa00088008800c6cc6c00dddddd00aaaa0000aaaa00008c8c890066666600600066006666660
00600600004444000ccccc0008cccca000055000040bb70000aaaa0008888880cccccccc00d00d000aaaaa000aaaaa8000ccc000006666600600660006666600
00600600040400000ccccc000c0cc0c000055000040b00000009000008000080c6c66c6c0d0dd0d000aaaaa000aaaaa000c0c000000666600666600006666000
000000000004400000ccc000444444440005500040b0b00000099000008008000c0000c0d000000d000000000000000004404400000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000123012377777777777777777777777777777777000000000000000000000000
00066000000660000666666006666660000666600006666006666000066660000501456777777777777777777777777777777777000000000000000000000000
0066660000666600066666600600006000660060006666600600660006666600000123ab77777777777777777777777777777777000000000000000000000000
0666666006600660066666600600006006600060066666600600066006666660044567ef77777777777777777777777777777777000000000000000000000000
06666660060000600666666006600660066000600666666006000660066666600089ab2377777777777777777777777777777777000000000000000000000000
066666600600006000666600006666000066006000666660060066000666660004bdef6777777777777777777777777777777777000000000000000000000000
0666666006666660000660000006600000066660000666600666600006666000089a89ab77777777777777777777777777777777000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000cdecdef77777777777777777777777777777777000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000040000000000000000000000000
00000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
004000000000000000000000000000d0d0d0f0000000000000004000000000400000000000000000000000000000000000000040000000004000000000000000
000000000000d0000000000000004000000000400000000000000000000000000020202020200000004000000000400000000000000000000000000020202020
2020202020209090b0b0b0b0a090900000000020202020202020202020202020202020209090b0b0b0b0a09020202020202020202020202020202020209090b0
b0b0b0a090900020202020202020202020202020202020209090b0b0b0b0a090903030303030202020202020202020202020209090b0b0b0b0a0909030303030
30303030303000000000000000000000000000303030303030303030303030303030303000000000000000003030303030303030303030303030303030000000
00000000000000303030303030303030303030303000000000000000000000000000003000003030303030303030303000000000000000000000000000003000
00000030000000000000003000000000000000000000000000000000000000003000000000000000300000000000000000000000000000300000000000000030
00000000000000000000000000000000003000000000000000000000000000000000003000000030000000003000000000000000000000000000000000003000
00000030000000000000003000000000000000000000000000000000000000003000000000000000300000000000000000000000000000300000000000000030
00000000000000000000000000000000003000000000000000000000000000000000003000000030000000003000000000000000000000000000000000003000
00000030000000000000003000000000000000000000000000000000000000003000000000000000300000000000000000000000000000300000000000000030
00000000000000000000000000000000003000000000000000000000000000000000003000000030000000003000000000000000000000000000000000003000
00000030000000000000003000000000000000000000000000000000000000003000000000000000300000000000000000000000000000300000000000000030
00000000000000000000000000000000003000000000000000000000000000000000003000000030000000003000000000000000000000000000000000003000
00000030000000000000003000000000000000000000000000000000000000003000000000000000300000000000000000000000000000300000000000000030
00000000000000000000000000000000003000000000000000000000000000000000003000000030000000003000000000000000000000000000000000003000
00000030000000000000003000000000000000000000000000000000000000003000000000000000300000000000000000000000000000300000000000000030
00000000000000000000000000000000003000000000000000000000000000000000000000000030000000003000000000000000000000000000000000000000
00000000000000200000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000002000
00000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000200000000000000000000000
00000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000040000000000000000000000000
00000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
004000000000000000000000000000d0d0d0f0000000000000004000000000400000000000000000000000000000000000000040000000004000000000000000
000000000000d0000000000000004000000000400000000000000000000000000020202020200000004000000000400000000000000000000000000020202020
2020202020209090b0b0b0b0a090900000000020202020202020202020202020202020209090b0b0b0b0a09020202020202020202020202020202020209090b0
b0b0b0a090900020202020202020202020202020202020209090b0b0b0b0a090903030303030202020202020202020202020209090b0b0b0b0a0909030303030
30303030303000000000000000000000000000303030303030303030303030303030303000000000000000003030303030303030303030303030303030000000
00000000000000303030303030303030303030303000000000000000000000000000003000003030303030303030303000000000000000000000000000003000
00000030000000000000003000000000000000000000000000000000000000003000000000000000300000000000000000000000000000300000000000000030
00000000000000000000000000000000003000000000000000000000000000000000003000000030000000003000000000000000000000000000000000003000
00000030000000000000003000000000000000000000000000000000000000003000000000000000300000000000000000000000000000300000000000000030
00000000000000000000000000000000003000000000000000000000000000000000003000000030000000003000000000000000000000000000000000003000
00000030000000000000003000000000000000000000000000000000000000003000000000000000300000000000000000000000000000300000000000000030
00000000000000000000000000000000003000000000000000000000000000000000003000000030000000003000000000000000000000000000000000003000
00000030000000000000003000000000000000000000000000000000000000003000000000000000300000000000000000000000000000300000000000000030
00000000000000000000000000000000003000000000000000000000000000000000003000000030000000003000000000000000000000000000000000003000
00000030000000000000003000000000000000000000000000000000000000003000000000000000300000000000000000000000000000300000000000000030
00000000000000000000000000000000003000000000000000000000000000000000003000000030000000003000000000000000000000000000000000003000
00000030000000000000003000000000000000000000000000000000000000003000000000000000300000000000000000000000000000300000000000000030
00000000000000000000000000000000003000000000000000000000000000000000000000000030000000003000000000000000000000000000000000000000
00000000000000000000003030000000000000000000000000000000000000000000000000000000300000000000000000000000000000000000000000000030
30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000020
00000000200000000000000030000000000000000000000000000000000000000020000000000000000000000000000000000000000000002000000000000000
30000000000000000000000000000000000020000000000000000000000000000000000000000000200000000020000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000200000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000002000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000200000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000002000000000
00000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000400000000000000000
00000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000040000000000000000000000000000000
00000000000000000000400000000000000000000000000000000000400000000040000000000000000000000000000000000000000000400000000040000000
004000000000000000000000000000d0d0d000000000000000400000000040000000000000000000000000000000000040000000004000000000000000000000
00000000000000000000400000000040000000000020202020202020202020202020202020200000000000000000000020202020202020202020202020202020
2020202020209090b0b0b0b0a0909000000020202020202020202020202020202020209090b0b0b0b020202020202020202020202020202020209090b0b0b0b0
a0909020202020202020202020202020202020209030303030303030303030303030303030302020202090202020209030303030303030303030303030303030
__map__
00001c00001c00001c0000001c0000001c000000000000000000000000000000001c000000000000001c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001c00001c00001c0000001c0000001c000000000000000000000000000000001c000000000000001c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001d00001c00001c0000001c0000001c000000000000000000000000000000001c000000000000001c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001d00001c0000001c0000001d000000000000000000000000000000001c000000000000001c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000001c0000001d00000000000000000000000000000000000000001c000000000000001c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000001d0000000000000000000000000000000000000000000000001d000000000000001d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000016111111190000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000001511131118000000000000001a1b0000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000001717121800000000000000001c1c0000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000001100000000000f0000001c1c0000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000001400000d0202020202001c1c0000000000000004000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02020202020200000202020202020202020000020202020202020202020202020202020209090b0b0b0b0a09020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030202020000000000000000000003030303030303030303030303030303030000000000000000030303030303030303030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000300000000000000030000000000000000000000000000000000000000030000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000300000000000000030000000000000000000000000000000000000000030000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000300000000000000030000000000000000000000000000000000000000030000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000300000000000000030000000000000000000000000000000000000000030000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000300000000000000030000000000000000000000000000000000000000030000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000300000000000000030000000000000000000000000000000000000000030000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000300000000000000030000000000000000000000000000000000000000000300000000000000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000300000000000000030000000000000000000000000000000000000000000300000000000000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000300000000000000030000000000000000000000000000000000000000000300000000000000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000300000000000000030000000000000000000000000000000000000000000300000000000000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000300000000000000030000000000000000000000000000000000000000000300000000000000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000030300000000000000000000000000000000000000000000000000000000030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000300000000000000000000000000000000000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
