Code.require_file("vector.ex", Path.join(__DIR__, "../../lib"))
Code.require_file("func_geo.ex", Path.join(__DIR__, "../../lib"))

alias FuncGeo, as: F

f =
  F.grid(
    7,
    7,
    F.polygon([{2, 1}, {2, 6}, {5, 6}, {5, 5}, {3, 5}, {3, 4}, {4, 4}, {4, 3}, {3, 3}, {3, 1}])
  )

# Basic Operations
pictures = [
  f: f,
  rot_f: F.rot(f),
  flip_f: F.flip(f),
  rot_flip_f: f |> F.flip() |> F.rot(),
  above_f: F.above(f, f),
  beside_f: F.beside(f, f),
  above_beside_f: f |> F.beside(f) |> F.above(f),
  rot45: F.rot45(f),
  over: F.over(f, F.flip(f))
]

# Draw every picture as Postscript and SVG
for {file_name, picture} <- pictures do
  F.plot(picture, format: "ps", file_name: Atom.to_string(file_name))
  F.plot(picture, format: "svg", file_name: Atom.to_string(file_name))
end
