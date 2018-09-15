defmodule Escher.Scene.SquareLimit do
  @moduledoc """
  Square Limit
  """

  use Scenic.Scene

  import Scenic.Primitives

  alias Scenic.Graph
  alias Escher.Component.{Nav, Notes}
  alias Escher.Utils
  alias FuncGeo, as: F

  @notes """
  \"Functional Geometry\" is a paper by Peter Henderson, which deconstructs
  the M.C.Escher woodcut \"Square Limit\".
  """

  @body_offset 80

  # Basic pictures: p, q, r, s
  @p Utils.grid(:p)

  @q Utils.grid(:q)

  @r Utils.grid(:r)

  @s Utils.grid(:s)

  # Build the drawing of the fish out of the parts defined above
  @t F.quartet(@p, @q, @r, @s)

  @side1 F.quartet(F.blank(), F.blank(), F.rot(@t), @t)
  @side2 F.quartet(@side1, @side1, F.rot(@t), @t)

  @u @q |> F.rot() |> F.cycle()
  @corner1 F.quartet(F.blank(), F.blank(), F.blank(), @u)
  @corner2 F.quartet(@corner1, @side1, F.rot(@side1), @u)

  @corner F.nonet(
            @corner2,
            @side2,
            @side2,
            F.rot(@side2),
            @u,
            F.rot(@t),
            F.rot(@side2),
            F.rot(@t),
            F.rot(@q)
          )
  @squarelimit F.cycle(@corner)

  @graph Graph.build(font: :roboto, font_size: 24, theme: :light)
         |> group(
           &path(&1, Enum.concat(Utils.initial_path(), Utils.path(@squarelimit)),
             stroke: {0.002, :black},
             translate: {0, 500},
             scale: {500, -500}
           ),
           translate: {50, @body_offset}
         )
         |> Nav.add_to_graph(__MODULE__)
         |> Notes.add_to_graph(@notes)

  def init(_, _opts) do
    push_graph(@graph)

    {:ok, @graph}
  end
end
