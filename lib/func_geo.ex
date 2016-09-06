defmodule FuncGeo do
  import Kernel, except: [div: 2]
  require EEx

  @doc """
  Returns the point addition of `a` and `b`.

  iex> a = {1, 2}
  {1, 2}
  iex> FuncGeo.add(a, a)
  {2, 4}
  """
  @spec add({number, number}, {number, number}) :: {number, number}
  def add({x0, y0}, {x1, y1}) do
    {x0 + x1, y0 + y1}
  end

  @doc """
  Returns the point subtraction of `a` and `b`.

  iex> a = {1, 2}
  {1, 2}
  iex> FuncGeo.sub(a, a)
  {0, 0}
  """
  @spec sub({number, number}, {number, number}) :: {number, number}
  def sub({x0, y0}, {x1, y1}) do
    {x0 - x1, y0 - y1}
  end

  @doc """
  Returns the point negation

  iex> a = {1, 2}
  {1, 2}
  iex> FuncGeo.neg(a)
  {-1, -2}
  """
  @spec neg({number, number}) :: {number, number}
  def neg({x, y}) do
    {-x, -y}
  end

  @doc """
  Returns the point scalar multiplication

  iex> a = {1, 2}
  {1, 2}
  iex> FuncGeo.mul(a, 2)
  {2, 4}
  """
  @spec mul({number, number}, number) :: {number, number}
  def mul({x, y}, a) when is_number(a) do
    {x * a, y * a}
  end

  @doc """
  Returns the point scalar division

  iex> a = {2, 4}
  {2, 4}
  iex> FuncGeo.div(a, 2)
  {1.0, 2.0}
  """
  @spec div({number, number}, number) :: {number, number}
  def div({x, y}, a) when is_number(a) do
    # TODO: Raise ArithmeticError if one of the arguments is not a number
    # o when the divisor is 0
    {x / a, y / a}
  end

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
      p.(a, b, c_half) + q.(add(a, c_half), b, c_half)
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
      p.(add(a, c_scaled), b, mul(c, m_scaled)) + q.(a, b, c_scaled)
    end
  end

  @doc """
  Returns picture that has `p` in the left half of its locating box and `q` in
  the right half
  """
  def beside(p, q) do
    fn(a, b, c) ->
      b_half = div(b, 2)
      p.(a, b_half, c) + q.(add(a, b_half), b_half, c)
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
      p.(a, b_scaled, c) + q.(add(a, b_scaled), mul(b, n_scaled), c)
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
    p |> beside(q) |> above(r |> beside(s))
  end

  @doc """
  Returns four times the p, layouted in a square and rotated
  """
  def cycle(p) do
    q = p |> rot()
    r = q |> rot()
    s = r |> rot()
    p |> quartet(q, r, s)
  end

  def nonet(p, q, r, s, t, u, v, w, x) do
    above(1, 2, beside(1, 2, p, beside(1, 1, q, r)),
          above(1, 1, beside(1, 2, s, beside(1, 1, t, u)),
                beside(1, 2, v, beside(1, 1, w, x))))
  end

  def over(p, q) do
    fn(a, b, c) ->
      p.(a, b, c) + q.(a, b, c)
    end
  end

  @doc """
  """
  def blank do
    fn(_a, _b, _c) -> {} end
  end

  @doc """
    Writes the given picture function to a PostScript file
  """
  def plot(p) do
    IO.inspect(p)
    r = p.({0, 0}, {1, 0}, {0, 1})
    IO.inspect(r)
    #content = ps_template(p.({0, 0}, {1, 0}, {0, 1}))
    #File.write!("output.ps", content)
  end

  EEx.function_from_file(:def, :ps_template, Path.expand("postscript_template.eex", __DIR__), [:list])
end
