defmodule Escher.Scene.MoreF do
  @moduledoc """
  More F
  """

  use Scenic.Scene

  import Scenic.Primitives

  alias Scenic.Graph
  alias Escher.Component.{Nav, Notes}
  alias Escher.Utils
  alias FuncGeo, as: F

  @notes "Basic operations on pictures."

  @body_offset 80

  @f Utils.grid(:f)
  @above_f F.above(@f, @f)
  @beside_f F.beside(@f, @f)
  @above_beside_f @f |> F.beside(@f) |> F.above(@f)
  @over F.over(@f, F.flip(@f))

  @graph Graph.build(font: :roboto, font_size: 24, theme: :light)
         |> group(
           fn g ->
             g
             |> group(&Utils.container(&1, @above_f, text: "above(f, f)"), translate: {0, 250})
             |> group(&Utils.container(&1, @beside_f, text: "beside(f, f)"), translate: {0, 500})
             |> group(&Utils.container(&1, @above_beside_f, text: "above(beside(f, f), f)"),
               translate: {250, 250}
             )
             |> group(&Utils.container(&1, @over, text: "over(f, flip(f))"), translate: {250, 500})
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
