defmodule Escher.Scene.F do
  @moduledoc """
  F
  """

  use Scenic.Scene

  import Scenic.Primitives

  alias Scenic.Graph
  alias Escher.Component.{Nav, Notes}
  alias Escher.Utils
  alias FuncGeo, as: F

  @notes """
  The value f denotes the picture of the letter F.

  NOTE: The image it is located within a frame, but we do not consider the
  frame to be part of the picture.
  """

  @body_offset 80

  @f Utils.grid(:f)
  @rot_f F.rot(@f)
  @flip_f F.flip(@f)
  @rot_flip_f @f |> F.flip() |> F.rot()

  @graph Graph.build(font: :roboto, font_size: 24, theme: :light)
         |> group(
           fn g ->
             g
             |> group(&Utils.container(&1, @f, text: "f"), translate: {0, 250})
             |> group(&Utils.container(&1, @rot_f, text: "rot(f)"), translate: {0, 500})
             |> group(&Utils.container(&1, @flip_f, text: "flip(f)"), translate: {250, 250})
             |> group(&Utils.container(&1, @rot_flip_f, text: "rot(flip(f))"),
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
