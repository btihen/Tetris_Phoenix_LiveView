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

  def move({x, y}, {delta_x, delta_y}) do
    {(x + delta_x), (y + delta_y)}
  end

end
