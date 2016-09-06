defmodule FuncGeoTest do
  use ExUnit.Case
  doctest FuncGeo

  import FuncGeo, only: [rot: 1, grid: 3]

  test "p is equal after four rot()" do
    #assert p |> rot() |> rot() |> rot() |> rot() == p
  end
end
