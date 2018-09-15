defmodule Escher.Scene.Fish do
  @moduledoc """
  Fish
  """

  use Scenic.Scene

  import Scenic.Primitives

  alias Scenic.Graph
  alias Escher.Component.{Nav, Notes}
  alias Escher.Utils

  @notes "Basic patterns for the Square Limit: p, q, r, s"

  @body_offset 80

  # Basic pictures: p, q, r, s
  @p Utils.grid(:p)

  @q Utils.grid(:q)

  @r Utils.grid(:r)

  @s Utils.grid(:s)

  @graph Graph.build(font: :roboto, font_size: 24, theme: :light)
         |> group(
           fn g ->
             g
             |> group(&Utils.container(&1, @p, text: "p"), translate: {0, 250})
             |> group(&Utils.container(&1, @q, text: "q"),
               translate: {0, 500}
             )
             |> group(&Utils.container(&1, @r, text: "r"), translate: {250, 250})
             |> group(&Utils.container(&1, @s, text: "s"),
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
