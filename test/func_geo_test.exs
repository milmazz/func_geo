defmodule FuncGeoTest do
  use ExUnit.Case, async: true
  doctest FuncGeo

  import FuncGeo,
    only: [
      rot: 1,
      grid: 3,
      polygon: 1,
      beside: 2,
      above: 2,
      flip: 1,
      blank: 0,
      over: 2,
      plot: 1,
      plot: 2
    ]

  defp man do
    grid(
      14,
      20,
      polygon([
        {6, 10},
        {0, 10},
        {0, 12},
        {6, 12},
        {6, 14},
        {4, 16},
        {4, 18},
        {6, 20},
        {8, 20},
        {10, 18},
        {10, 16},
        {8, 14},
        {8, 12},
        {10, 12},
        {10, 14},
        {12, 14},
        {12, 10},
        {8, 10},
        {8, 8},
        {10, 0},
        {8, 0},
        {7, 4},
        {6, 0},
        {4, 0},
        {6, 8}
      ])
    )
  end

  test "p is equal after four continuos rotations" do
    man = man()

    man_rotated = man |> rot() |> rot() |> rot() |> rot()

    assert man_rotated.({0, 0}, {1, 0}, {0, 1}) == man.({0, 0}, {1, 0}, {0, 1})
  end

  test "rot(above(p, q)) must be equal to beside(rot(p), rot(q))" do
    man = man()

    man_rotated = rot(above(man, man))
    man_beside = beside(rot(man), rot(man))

    assert man_rotated.({0, 0}, {1, 0}, {0, 1}) == man_beside.({0, 0}, {1, 0}, {0, 1})
  end

  test "rot(beside(p, q)) must be equal to above(rot(q), rot(p))" do
    man = man()

    man_rotated = rot(beside(man, man))
    man_above = above(rot(man), rot(man))

    assert man_rotated.({0, 0}, {1, 0}, {0, 1}) == man_above.({0, 0}, {1, 0}, {0, 1})
  end

  test "flip(beside(p, q)) must be equal to beside(flip(q), flip(p))" do
    man = man()

    flipped = flip(beside(man, man))
    man_beside = beside(flip(man), flip(man))

    assert flipped.({0, 0}, {1, 0}, {0, 1}) == man_beside.({0, 0}, {1, 0}, {0, 1})
  end

  test "blank()" do
    assert blank().(1, 2, 3) == []
  end

  test "over(man, man) must be equal to over(man, blank())" do
    man = man()

    o = over(man, man)
    b = over(man, blank())

    assert o.({0, 0}, {1, 0}, {0, 1}) == b.({0, 0}, {1, 0}, {0, 1})
  end

  test "plot produce a PostScript file by default" do
    man = man()
    plot(man)

    content = File.read!("output.ps")

    assert content =~ ~r{500 500 scale(\r)?\n.1 .1 translate}
    assert content =~ ~r{stroke(\r)?\nshowpage}
  end

  test "plot produce a SVG file if specified" do
    man = man()
    plot(man, format: "svg")

    content = File.read!("output.svg")

    assert content =~ ~r{viewBox="0 0 500 500"}
    assert content =~ ~r{M 0 0 L 1 0 L 1 1 L 0 1 z}
  end

  # TODO: Non-covered tests:
  #
  # * above(m, n, p, q)
  # * beside(m, n, p, q)
  # * rot45(p)
  # * quartet(p, q, r, s)
  # * cycle(p)
  # * nonet(p, q, r, s, t, u, v, w, x)
  # * over(p, q)
end
