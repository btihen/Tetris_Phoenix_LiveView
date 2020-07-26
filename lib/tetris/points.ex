defmodule Tetris.Points do

  alias Tetris.Point

  @base {0,0}

  # reducers
  def rotation(points, degrees) do
    points
    |> Enum.map( &Point.rotate(&1, degrees) )
    # |> Enum.map(fn point ->
    #                 point |> Point.rotate(degrees)
    #             end)
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

  # constructors
  def i_shape(base \\ @base) do
    {x,y} = base
    [
                  {x, y-1},
                  {x, y},
                  {x, y+1},
                  {x, y+2}
    ]
  end
  def j_shape(base \\ @base) do
    {x,y} = base
    [
                  {x, y-1},
                  {x, y},
      {x-1,y+1},  {x, y+1}
    ]
  end
  def l_shape(base \\ @base) do
    {x,y} = base
    [
                  {x, y-1},
                  {x, y},
                  {x, y+1}, {x+1,y+1}
    ]
  end
  def o_shape(base \\ @base) do
    {x, y} = base
    [
                  {x, y+1}, {x+1, y+1},
                  {x, y+2}, {x+1, y+2}
    ]
  end
  def s_shape(base \\ @base) do
    {x, y} = base
    [
                  {x, y}, {x+1, y},
      {x-1, y+1}, {x, y+1}
    ]
  end
  def t_shape(base \\ @base) do
    {x, y} = base
    [
      {x-1, y}, {x, y}, {x+1, y},
                {x, y+1}
    ]
  end
  def z_shape(base \\ @base) do
    {x, y} = base
    [
      {x-1, y}, {x, y},
                {x, y+1}, {x+1, y+1}
    ]
  end


end