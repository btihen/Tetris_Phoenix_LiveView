defmodule Tetris.Tetromino do

  alias Tetris.{Point, Points}

  defstruct shape: :l, rotation: 0, location: {5, 0}, color: {0,0,255}

  @width Enum.to_list 0..9
  @shapes ~w[i j l o s t z]a
  @rotations [0, 90, 180, 270]
  @color_range [100, 175, 250] # Enum.to_list 0..255

  def new(options \\ []) do
    __struct__(options)
  end

  def new_random do
    new(
        shape: random_shape(),
        color: random_color(),
        rotation: random_rotation(),
        location: random_location()
        )
  end

  def show(tetro) do
    tetro
    |> shape
    |> Points.move(tetro.location)
  end

  defp shape(%{shape: :i}=tetro) do
    Points.i_shape
  end
  defp shape(%{shape: :j}=tetro) do
    Points.j_shape
  end
  defp shape(%{shape: :l}=tetro) do
    Points.l_shape
  end
  defp shape(%{shape: :o}=tetro) do
    Points.o_shape
  end
  defp shape(%{shape: :s}=tetro) do
    Points.s_shape
  end
  defp shape(%{shape: :t}=tetro) do
    Points.t_shape
  end
  defp shape(%{shape: :z}=tetro) do
    Points.z_shape
  end
  defp shape(tetro) do
    Points.l_shape
  end

  def left(tetro) do
    %{ tetro | location: Point.left(tetro.location)}
  end

  def right(tetro) do
    %{ tetro | location: Point.right(tetro.location)}
  end

  def down(tetro) do
    %{ tetro | location: Point.down(tetro.location)}
  end

  def rotate(tetro) do
    %{ tetro | rotation: rotate_clockwise(tetro.rotation)}
  end

  # PRIVATE
  defp rotate_clockwise(270) do
    0
  end
  defp rotate_clockwise(n) do
    n + 90
  end
  defp rotate_counterclockwise(0) do
    270
  end
  defp rotate_counterclockwise(n) do
    n - 90
  end

  defp random_shape do
    @shapes |> Enum.random
    # ~w[i j l o s t z]a |> Enum.random
  end

  defp random_color do
    red   = @color_range |> Enum.random
    green = @color_range |> Enum.random
    blue  = @color_range |> Enum.random
    {red, green, blue}
  end

  defp random_location do
    x = @width |> Enum.random
    {x, 0}
  end

  defp random_rotation do
    @rotations |> Enum.random
  end

end
