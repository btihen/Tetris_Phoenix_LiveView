defmodule Tetris.Points do

  alias Tetris.Point

  def i_shape(base \\ {0, 0}) do
    {x,y} = base
    [
                  {x+1, y+0},
                  {x+1, y+1},
                  {x+1, y+2},
                  {x+1, y+3}
    ]
  end
  def j_shape(base \\ {0, 0}) do
    {x,y} = base
    [
                  {x+1, y+0},
                  {x+1, y+1},
      {x+0,y+2},  {x+1, y+2}
    ]
  end
  def l_shape(base \\ {0, 0}) do
    {x,y} = base
    [
                  {x+1, y+0},
                  {x+1, y+1},
                  {x+1, y+2}, {x+2,y+2}
    ]
  end
  def o_shape(base \\ {0, 0}) do
    {x, y} = base
    [
                  {x+1, y+1}, {x+2, y+1},
                  {x+1, y+2}, {x+2, y+2}
    ]
  end
  def s_shape(base \\ {0, 0}) do
    {x, y} = base
    [
                  {x+1, y+1}, {x+2, y+1},
      {x+0, y+2}, {x+1, y+2}
    ]
  end
  def t_shape(base \\ {0, 0}) do
    {x, y} = base
    [
      {x+0, y+1}, {x+1, y+1}, {x+2, y+1},
                  {x+1, y+2}
    ]
  end
  def z_shape(base \\ {0, 0}) do
    {x, y} = base
    [
      {x+0, y+1}, {x+1, y+1},
                  {x+1, y+2}, {x+2, y+2}
    ]
  end

  def move(points, change) do
    points
    |> Enum.map( &Point.move(&1, change) )
  end
  # def move(points, change) do
  #   points
  #   |> Enum.map( fn point -> Point.move(point, change) end )
  # end
  # def move(points, {delta_x, delta_y}=_change) do
  #   points |> Enum.map( Point.move({tx, ty} -> {tx + x, ty + y} end)
  # end

end