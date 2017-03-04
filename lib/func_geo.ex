defmodule FuncGeo do
  @moduledoc """
  Functional Geometry

  This work is based on the *Functional Geometry* paper by [Peter Henderson][ph],
  the most recent version of this document is from [2002][funcgeo2], the original
  version is from [1982][funcgeo]. In this paper Peter Henderson deconstructs
  the [M.C. Escher][m-c-escher]'s woodcut [Square Limit][square-limit] using
  an *algebra of pictures*.

  Peter Henderson also mentions that this idea can be applied to many more complex
  domains such as music or animation.

  ## Other implementations

  * [Lisp][lisp] by Frank Buß
  * [F#][fsharp] by Satnam Singh
  * [Python][python] and [Haskell][haskell] by Will McCutchen
  * [Julia][julia] by Shashi Gowda

  [ph]: http://users.ecs.soton.ac.uk/ph/
  [funcgeo]: http://users.ecs.soton.ac.uk/ph/funcgeo.pdf
  [funcgeo2]: http://users.ecs.soton.ac.uk/ph/papers/funcgeo2.pdf
  [m-c-escher]: http://www.wikiart.org/en/m-c-escher
  [square-limit]: http://www.wikiart.org/en/m-c-escher/square-limit
  [lisp]: http://www.frank-buss.de/lisp/functional.html
  [python]: https://github.com/mccutchen/funcgeo/blob/master/funcgeo.py
  [haskell]: https://github.com/mccutchen/funcgeo/blob/master/funcgeo.hs
  [julia]: https://shashi.github.io/ijulia-notebooks/funcgeo/
  [fsharp]: https://blogs.msdn.microsoft.com/satnam_singh/2010/01/05/an-f-functional-geometry-description-of-eschers-fish/
  """

  import Kernel, except: [div: 2]
  import FuncGeo.Vector, only: [add: 2, sub: 2, neg: 1, mul: 2, div: 2]

  require EEx

  @doc """
  Defines a picture function from lines in a grid
  """
  def grid(m, n, s) do
    fn a, b, c ->
      for {{x0, y0}, {x1, y1}} <- s do
        {Enum.reduce([div(mul(b, x0), m), a, div(mul(c, y0), n)], &add/2),
         Enum.reduce([div(mul(b, x1), m), a, div(mul(c, y1), n)], &add/2)}
      end
    end
  end

  @doc """
  Convert the given points, which specifies a polygon, in a list of lines
  """
  def polygon(points) do
    List.zip([[List.last(points)] ++ points, points])
  end

  @doc """
  Returns picture `p` rotated anticlockwise by 90 degrees
  """
  def rot(p) do
    fn a, b, c ->
      p.(add(a, b), c, neg(b))
    end
  end

  @doc """
  Returns picture `p` flipped through its vertical centre axis
  """
  def flip(p) do
    fn a, b, c ->
      p.(add(a, b), neg(b), c)
    end
  end

 @doc """
  Returns picture that has `p` in the upper half of its locating box and `q` in
  the lower half
  """
  def above(p, q) do
    fn a, b, c ->
      c_half = div(c, 2)

      a
      |> add(c_half)
      |> p.(b, c_half)
      |> MapSet.new()
      |> MapSet.union(MapSet.new(q.(a, b, c_half)))
      |> MapSet.to_list()
    end
  end

  @doc """
  Place picture `p` above `q` scaled by `m` and `n`
  """
  def above(m, n, p, q) do
    fn a, b, c ->
      m_scaled = m / (m + n)
      n_scaled = n / (m + n)
      c_scaled = mul(c, n_scaled)

      a
      |> add(c_scaled)
      |> p.(b, mul(c, m_scaled))
      |> MapSet.new()
      |> MapSet.union(MapSet.new(q.(a, b, c_scaled)))
      |> MapSet.to_list()
    end
  end

  @doc """
  Returns picture that has `p` in the left half of its locating box and `q` in
  the right half
  """
  def beside(p, q) do
    fn a, b, c ->
      b_half = div(b, 2)

      a
      |> p.(b_half, c)
      |> MapSet.new()
      |> MapSet.union(MapSet.new(q.(add(a, b_half), b_half, c)))
      |> MapSet.to_list()
    end
  end

  @doc """
  Place picture `p` besides `q` scaled by `m` and `n`
  """
  def beside(m, n, p, q) do
    fn a, b, c ->
      m_scaled = m / (m + n)
      n_scaled = n / (m + n)
      b_scaled = mul(b, m_scaled)

      a
      |> p.(b_scaled, c)
      |> MapSet.new()
      |> MapSet.union(MapSet.new(q.(add(a, b_scaled), mul(b, n_scaled), c)))
      |> MapSet.to_list()
    end
  end

  @doc """
  Rotates a picture about its top left corner, through 45 degrees
  anticlockwise. It also reduces the picture is size by `sqrt(2)`
  """
  def rot45(p) do
    fn a, b, c ->
      bc_half = div(add(b, c), 2)
      p.(add(a, bc_half), bc_half, div(sub(c, b), 2))
    end
  end

  @doc """
  Returns the picture p, q, r and s, layouted in a square
  """
  def quartet(p, q, r, s) do
    above(beside(p, q), beside(r, s))
  end

  @doc """
  Returns four times the p, layouted in a square and rotated
  """
  def cycle(p) do
    quartet(p, rot(rot(rot(p))), rot(p), rot(rot(p)))
  end

  def nonet(p, q, r, s, t, u, v, w, x) do
    above(1, 2, beside(1, 2, p, beside(1, 1, q, r)),
          above(1, 1, beside(1, 2, s, beside(1, 1, t, u)),
                beside(1, 2, v, beside(1, 1, w, x))))
  end

  @doc """
  Overlays one picture `p` directly on top of the other picture `q`
  """
  def over(p, q) do
    fn a, b, c ->
      a
      |> p.(b, c)
      |> MapSet.new()
      |> MapSet.union(MapSet.new(q.(a, b, c)))
      |> MapSet.to_list()
    end
  end

  @doc """
  Represents an empty picture
  """
  def blank do
    fn _a, _b, _c -> [] end
  end

  @doc """
  Writes the given picture in the given format.
  """
  def plot(p, options \\ []) do
    format = Keyword.get(options, :format, "ps")
    output = Keyword.get(options, :file_name, "output")
    callback = if format == "ps", do: &as_ps/1, else: &as_svg/1

    content = callback.(p.({0, 0}, {1, 0}, {0, 1}))
    File.write!("#{output}.#{format}", content)
  end

  EEx.function_from_file(:def,
                         :as_ps,
                         Path.expand("templates/postscript.eex", __DIR__),
                         [:list])

  EEx.function_from_file(:def,
                         :as_svg,
                         Path.expand("templates/svg.eex", __DIR__),
                         [:list])
end
