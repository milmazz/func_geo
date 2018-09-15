defmodule Escher.Scene.Man do
  @moduledoc """
  Man
  """

  use Scenic.Scene

  import Scenic.Primitives

  alias Scenic.Graph
  alias Escher.Component.{Nav, Notes}
  alias Escher.Utils
  alias FuncGeo, as: F

  @notes "Basic operations on pictures"

  @body_offset 80

  @man Utils.grid(:man)
  @man_quartet F.quartet(@man, @man, @man, @man)
  @man_cycle F.cycle(@man)
  @man_beside_man F.beside(@man, @man)

  @graph Graph.build(font: :roboto, font_size: 24, theme: :light)
         |> group(
           fn g ->
             g
             |> group(&Utils.container(&1, @man, text: "man", font_size: 20), translate: {0, 250})
             |> group(
               &Utils.container(&1, @man_quartet,
                 text: "quartet(man, man, man, man)",
                 font_size: 20
               ),
               translate: {0, 500}
             )
             |> group(&Utils.container(&1, @man_cycle, text: "cycle(man)", font_size: 20),
               translate: {250, 250}
             )
             |> group(
               &Utils.container(&1, @man_beside_man, text: "beside(man, man)", font_size: 20),
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
