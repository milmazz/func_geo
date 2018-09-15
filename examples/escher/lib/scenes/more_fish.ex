defmodule Escher.Scene.MoreFish do
  @moduledoc """
  Fish
  """

  use Scenic.Scene

  import Scenic.Primitives

  alias Scenic.Graph
  alias Escher.Component.{Nav, Notes}
  alias Escher.Utils
  alias FuncGeo, as: F

  @notes """
  t shows how nicely the four basic fish tiles fit together
  """

  @body_offset 80

  # Basic pictures: p, q, r, s
  @p Utils.grid(:p)

  @q Utils.grid(:q)

  @r Utils.grid(:r)

  @s Utils.grid(:s)

  @t F.quartet(@p, @q, @r, @s)

  @side1 F.quartet(F.blank(), F.blank(), F.rot(@t), @t)
  @side2 F.quartet(@side1, @side1, F.rot(@t), @t)

  @u @q |> F.rot() |> F.cycle()

  @graph Graph.build(font: :roboto, font_size: 24, theme: :light)
         |> group(
           fn g ->
             g
             |> group(&Utils.container(&1, @t, text: "t = quartet(p, q, r, s)", font_size: 15),
               translate: {0, 250}
             )
             |> group(
               &Utils.container(&1, @side1,
                 text: "side1 = quartet(\n\tblank(), blank(), rot(t), t)",
                 font_size: 15
               ),
               translate: {0, 500}
             )
             |> group(
               &Utils.container(&1, @side2,
                 text: "quartet(side1, side1, rot(t), t)",
                 font_size: 15
               ),
               translate: {250, 250}
             )
             |> group(&Utils.container(&1, @u, text: "u = cycle(rot(q))", font_size: 15),
               translate: {250, 500}
             )
           end,
           translate: {50, @body_offset}
         )
         |> Nav.add_to_graph(__MODULE__)
         |> Notes.add_to_graph(@notes)

  def init(_, _opts) do
    push_graph(@graph)

    {:ok, @graph}
  end
end
