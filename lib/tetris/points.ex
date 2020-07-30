defmodule Tetris.Points do

  alias Tetris.Point

  # reducers
  def valid?(points, graveyard) do
    in_bounds = in_bounds?(points)
    collision = collision?(points, graveyard)
    is_valid?(in_bounds, collision)
    # in_bounds?(points)
  end
  def is_valid?(true, false), do: true
  def is_valid?(_in_bounds, _collision), do: false

  def in_bounds?(points) do
    points |> Enum.all?( &Point.in_bounds?/1 )
  end

  def collision?(points, graveyard) do
    # points |> Enum.any?( &Point.in_bounds?/1 )
# IO.inspect points
    grave_list = graveyard |> Enum.map(fn {{x,y}, _color} -> {x,y} end)
    Enum.any?(points, fn point -> point in grave_list end)
  end

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
  def i_shape do
    [
              {2, 1},
              {2, 2},
              {2, 3},
              {2, 4}
    ]
  end
  def j_shape do
    [
                      {3, 1},
                      {3, 2},
              {2,3},  {3, 3}
    ]
  end
  def l_shape do
    [
              {2, 1},
              {2, 2},
              {2, 3}, {3,3}
    ]
  end
  def o_shape do
    [
              {2, 2}, {3, 2},
              {2, 3}, {3, 3}
    ]
  end
  def s_shape do
    [
              {2, 2}, {3, 2},
      {1, 3}, {2, 3}
    ]
  end
  def t_shape do
    [
      {1, 2}, {2, 2}, {3, 2},
              {2, 3}
    ]
  end
  def z_shape do
    [
      {1, 2}, {2, 2},
              {2, 3}, {3, 3}
    ]
  end


end