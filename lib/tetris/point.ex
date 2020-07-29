defmodule Tetris.Point do

  # constructor
  def origin() do
    {0, 0}
  end

  # Point reducers
  def down({x, y}) do
    {x, y+1}
  end
  def left({x, y}) do
    {x-1, y}
  end
  def right({x, y}) do
    {x+1, y}
  end

  def rotate(point, 0=_degrees), do: point
  def rotate(point, 360=_degrees), do: point
  def rotate(point, 90=_degrees) do
    point
    |> flip
    |> transpose
  end
  def rotate(point, 180=_degrees) do
    point
    |> mirror
    |> flip
  end
  def rotate(point, 270=_degrees) do
    point
    |> mirror
    |> transpose
  end
  # def rotate(point, _degrees), do: point

  def transpose({x,y}) do
    {y,x}
  end
  def mirror({x,y}) do # vertical
    {5-x, y}
  end
  def flip({x,y}) do
    {x, 5-y}
  end

  def move({x, y}, {delta_x, delta_y}) do
    {(x + delta_x), (y + delta_y)}
  end

  def in_bounds?({x, _y}) when x <  0, do: false
  def in_bounds?({x, _y}) when x > 14, do: false
  def in_bounds?({_x, y}) when y > 19, do: false
  def in_bounds?(_point), do: true

end
