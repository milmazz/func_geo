defmodule FuncGeo do
  import Kernel, except: [div: 2]
  import FuncGeo.Vector, only: [add: 2, sub: 2, neg: 1, mul: 2, div: 2]

  require EEx  

  @doc """
  Defines a picture function from lines in a grid
  """
  def grid(m, n, s) do
    fn(a, b, c) ->
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
    fn(a, b, c) ->
      p.(add(a, b), c, neg(b))
    end
  end

  @doc """
  Returns picture `p` flipped through its vertical centre axis
  """
  def flip(p) do
    fn(a, b, c) ->
      p.(add(a, b), neg(b), c)
    end
  end

 @doc """
  Returns picture that has `p` in the upper half of its locating box and `q` in
  the lower half
  """
  def above(p, q) do
    fn(a, b, c) ->
      c_half = div(c, 2)
      MapSet.new(p.(add(a, c_half), b, c_half))
      |> MapSet.union(MapSet.new(q.(a, b, c_half)))
      |> MapSet.to_list()
    end
  end

  @doc """
  Place picture `p` above `q` scaled by `m` and `n`
  """
  def above(m, n, p, q) do
    fn(a, b, c) ->
      m_scaled = m / (m + n)
      n_scaled = n / (m + n)
      c_scaled = mul(c, n_scaled)
      MapSet.new(p.(add(a, c_scaled), b, mul(c, m_scaled)))
      |> MapSet.union(MapSet.new(q.(a, b, c_scaled)))
      |> MapSet.to_list()
    end
  end

  @doc """
  Returns picture that has `p` in the left half of its locating box and `q` in
  the right half
  """
  def beside(p, q) do
    fn(a, b, c) ->
      b_half = div(b, 2)
      MapSet.new(p.(a, b_half, c))
      |> MapSet.union(MapSet.new(q.(add(a, b_half), b_half, c)))
      |> MapSet.to_list()
    end
  end

  @doc """
  Place picture `p` besides `q` scaled by `m` and `n`
  """
  def beside(m, n, p, q) do
    fn(a, b, c) ->
      m_scaled = m / (m + n)
      n_scaled = n / (m + n)
      b_scaled = mul(b, m_scaled)
      MapSet.new(p.(a, b_scaled, c))
      |> MapSet.union(MapSet.new(q.(add(a, b_scaled), mul(b, n_scaled), c)))
      |> MapSet.to_list()
    end
  end

  @doc """
  Rotates a picture about its top left corner, through 45 degrees
  anticlockwise. It also reduces the picture is size by sqrt(2)
  """
  def rot45(p) do
    fn(a, b, c) ->
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

  def over(p, q) do
    fn(a, b, c) ->
      MapSet.new(p.(a, b, c))
      |> MapSet.union(MapSet.new(q.(a, b, c)))
      |> MapSet.to_list()
    end
  end

  @doc """
  """
  def blank do
    fn(_a, _b, _c) -> [] end
  end

  @doc """
    Writes the given picture function to a PostScript file
  """
  def plot(p) do
    content = to_ps(p.({0, 0}, {1, 0}, {0, 1}))
    File.write!("output.ps", content)
  end

  EEx.function_from_file(:def, :to_ps, Path.expand("postscript_template.eex", __DIR__), [:list])
end
