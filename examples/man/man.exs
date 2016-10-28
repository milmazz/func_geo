Code.require_file("vector.ex", Path.join(__DIR__, "../lib"))
Code.require_file("func_geo.ex", Path.join(__DIR__, "../lib"))

alias FuncGeo, as: F

man = F.grid(
        14, 20,
        F.polygon([{6, 10}, {0, 10}, {0, 12}, {6, 12}, {6, 14},
                 {4, 16}, {4, 18}, {6, 20}, {8, 20}, {10, 18},
                 {10, 16}, {8, 14}, {8, 12}, {10, 12}, {10, 14},
                 {12, 14}, {12, 10}, {8, 10}, {8, 8}, {10, 0},
                 {8, 0}, {7, 4}, {6, 0}, {4, 0}, {6, 8}]))

man_beside_man = F.beside(man, man)
man_above_man = F.above(man, man)
man_rotated = F.rot(man)
man_quartet = F.quartet(man, man, man, man)
man_cycle = F.cycle(man)

# Draw every picture
F.plot(man, "man.ps")
F.plot(man_beside_man, "man_beside_man.ps")
F.plot(man_above_man, "man_above_man.ps")
F.plot(man_rotated, "man_rotated.ps")
F.plot(man_quartet, "man_quartet.ps")
F.plot(man_cycle, "man_cycle.ps")
