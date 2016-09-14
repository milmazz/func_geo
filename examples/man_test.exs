Code.require_file("func_geo.ex", Path.join(__DIR__, "../lib"))

alias FuncGeo, as: F

man = F.grid(
        14, 20,
        F.polygon([{6, 10}, {0, 10}, {0, 12}, {6, 12}, {6, 14},
                 {4, 16}, {4, 18}, {6, 20}, {8, 20}, {10, 18},
                 {10, 16}, {8, 14}, {8, 12}, {10, 12}, {10, 14},
                 {12, 14}, {12, 10}, {8, 10}, {8, 8}, {10, 0},
                 {8, 0}, {7, 4}, {6, 0}, {4, 0}, {6, 8}]))

content = F.ps_template(man.({0, 0}, {1, 0}, {0, 1}))
File.write!("man.ps", content)

man_beside_man = F.beside(man, man)
content = F.ps_template(man_beside_man.({0, 0}, {1, 0}, {0, 1}))
File.write!("man_beside_man.ps", content)

man_above_man = F.above(man, man)
content = F.ps_template(man_above_man.({0, 0}, {1, 0}, {0, 1}))
File.write!("man_above_man.ps", content)

man_rotated = F.rot(man)
content = F.ps_template(man_rotated.({0, 0}, {1, 0}, {0, 1}))
File.write!("man_rotated.ps", content)

man_quartet = F.quartet(man, man, man, man)
content = F.ps_template(man_quartet.({0, 0}, {1, 0}, {0, 1}))
File.write!("man_quartet.ps", content)

man_cycle = F.cycle(man)
content = F.ps_template(man_cycle.({0, 0}, {1, 0}, {0, 1}))
File.write!("man_cycle.ps", content)
