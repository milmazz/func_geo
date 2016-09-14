defmodule FuncGeo.Vector do
  @moduledoc """
  2D Vector operations
  """

  @type vector :: {number, number}

  @doc """
  Returns the 2D point addition of `a` and `b`.

  ## Examples

      iex> a = {1, 2}
      {1, 2}
      iex> FuncGeo.Vector.add(a, a)
      {2, 4}

  """
  @spec add(vector, vector) :: vector
  def add({x0, y0}, {x1, y1}) do
    {x0 + x1, y0 + y1}
  end

  @doc """
  Returns the point subtraction of `a` and `b`.

  ## Examples

      iex> a = {1, 2}
      {1, 2}
      iex> FuncGeo.Vector.sub(a, a)
      {0, 0}

  """
  @spec sub(vector, vector) :: vector
  def sub({x0, y0}, {x1, y1}) do
    {x0 - x1, y0 - y1}
  end

  @doc """
  Returns the point negation

  ## Examples

      iex> a = {1, 2}
      {1, 2}
      iex> FuncGeo.Vector.neg(a)
      {-1, -2}

  """
  @spec neg(vector) :: vector
  def neg({x, y}) do
    {-x, -y}
  end

  @doc """
  Returns the point scalar multiplication

  ## Examples

      iex> a = {1, 2}
      {1, 2}
      iex> FuncGeo.Vector.mul(a, 2)
      {2, 4}

  """
  @spec mul(vector, number) :: vector
  def mul({x, y}, a) when is_number(a) do
    {x * a, y * a}
  end

  @doc """
  Returns the point scalar division

  ## Examples

      iex> a = {2, 4}
      {2, 4}
      iex> FuncGeo.Vector.div(a, 2)
      {1.0, 2.0}

  """
  @spec div(vector, number) :: vector
  def div({x, y}, a) when is_number(a) do
    {x / a, y / a}
  end
end
