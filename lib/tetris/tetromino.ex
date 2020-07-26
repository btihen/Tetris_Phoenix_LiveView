defmodule Tetris.Tetromino do

  alias Tetris.{Point, Points}

  defstruct shape: :l, rotation: 0, location: {5, 0}, color: {0,0,255}

  @width Enum.to_list -1..8
  @shapes     ~w[i j l o s t z]a
  @rotations    [0, 90, 180, 270]
  @color_range  [0, 51, 153, 255] # Enum.to_list 0..255
  @colors      %{ i: {0,    255,  255}, # pale blue (aqua)
                  j: {0,    0,    255}, # blue
                  l: {255,  153,  51},  # orange
                  o: {255,  255,  0},   # yellow
                  s: {0,    255,  0},   # green
                  t: {153,  51, 255},   # purple
                  z: {255,  0,    0},   # red
                }

  def new(options \\ []) do
    __struct__(options)
  end

  def new_random do
    shape = random_shape()
    color = shape_color(shape) # random_color()
    new(
        shape: shape,
        color: color, # each shape has its own color
        rotation: random_rotation(),
        location: random_location()
        )
  end

  def show(tetro) do
    tetro
    |> shape
    |> Points.rotation(tetro.rotation)
    |> Points.move(tetro.location)
  end

  # def show(tetro) do
  #   IO.puts inspect tetro
  #   tetro
  #   |> tetro_shape
  #   |> tetro_rotation
  #   |> tetro_placement
  # end

  def tetro_shape(tetro) do
    %{ tetro | points: shape(tetro)}
  end

  def tetro_rotation(tetro) do
    %{ tetro | points: Points.rotation(tetro.points, tetro.rotation)}
  end

  def tetro_placement(tetro) do
    %{ tetro | points: Points.move(tetro.points, tetro.location)}
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

  def rotate(tetro, :cc=direction) do
    tetro |> rotate_counterclockwise
  end
  def rotate(tetro, :cw=direction) do
    tetro |> rotate_clockwise
  end
  def rotate(tetro, _) do
    tetro
  end

  # PRIVATE
  defp rotate_clockwise(%{rotation: 360}=tetro) do
    %{ tetro | rotation: 90}
  end
  defp rotate_clockwise(%{rotation: 270}=tetro) do
    %{ tetro | rotation: 0}
  end
  defp rotate_clockwise(%{rotation: degrees}=tetro) do
    %{ tetro | rotation: degrees + 90}
  end
  defp rotate_counterclockwise(%{rotation: 0}=tetro) do
    %{ tetro | rotation: 270}
  end
  defp rotate_counterclockwise(%{rotation: 360}=tetro) do
    %{ tetro | rotation: 270}
  end
  defp rotate_counterclockwise(%{rotation: degrees}=tetro) do
    %{ tetro | rotation: degrees + 90}
  end

  defp random_shape do
    @shapes |> Enum.random
    # ~w[i j l o s t z]a |> Enum.random
  end

  defp random_location do
    x = @width |> Enum.random
    {x, -1}
  end

  defp random_rotation do
    @rotations |> Enum.random
  end

  def shape(%{shape: :i}=_tetro), do: Points.i_shape
  def shape(%{shape: :j}=_tetro), do: Points.j_shape
  def shape(%{shape: :l}=_tetro), do: Points.l_shape
  def shape(%{shape: :o}=_tetro), do: Points.o_shape
  def shape(%{shape: :s}=_tetro), do: Points.s_shape
  def shape(%{shape: :t}=_tetro), do: Points.t_shape
  def shape(%{shape: :z}=_tetro), do: Points.z_shape
  # defp shape(_tetro), do: Points.l_shape

  defp shape_color(shape), do: @colors[shape]  # returns a color by shape
  # defp random_color do
  #   red   = @color_range |> Enum.random
  #   green = @color_range |> Enum.random
  #   blue  = @color_range |> Enum.random
  #   {red, green, blue}
  # end

end
