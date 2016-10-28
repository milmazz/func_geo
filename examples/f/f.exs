Code.require_file("vector.ex", Path.join(__DIR__, "../../lib"))
Code.require_file("func_geo.ex", Path.join(__DIR__, "../../lib"))

alias FuncGeo, as: F

f = F.grid(
        7, 7,
        F.polygon([{2, 1}, {2, 6}, {5, 6}, {5, 5}, {3, 5},
                   {3, 4}, {4, 4}, {4, 3}, {3, 3}, {3, 1}]))


# Basic Operations
rot_f = F.rot(f)
flip_f = F.flip(f)
rot_flip_f = F.rot(F.flip(f))
above_f = F.above(f, f)
beside_f = F.beside(f, f)
above_beside_f = F.above(F.beside(f, f), f)
rot45 = F.rot45(f)
over = F.over(f, F.flip(f))

# Draw every picture
F.plot(f, "f.ps")
F.plot(rot_f, "rot_f.ps")
F.plot(flip_f, "flip_f.ps")
F.plot(rot_flip_f, "rot_flip_f.ps")
F.plot(above_f, "above_f.ps")
F.plot(beside_f, "beside_f.ps")
F.plot(above_beside_f, "above_beside_f.ps")
F.plot(rot45, "rot45.ps")
F.plot(over, "over.ps")