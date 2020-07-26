defmodule Tetris.Game do
  alias Tetris.{Points, Tetromino}

  defstruct tetro: Tetromino.new, points: [], score: 0, junkyard: %{}

  def move(game, move_function) do
    old = game.tetro
    new = game.tetro
          |> move_function.()
    valid = new
          |> Tetromino.show
          |> Points.valid? #(&Points.all_valid?/1)

    Tetromino.test_move(old, new, valid)
  end

  def down(game),      do: game |> move(&Tetromino.down/1) |> show
  def left(game),      do: game |> move(&Tetromino.left/1) |> show
  def right(game),     do: game |> move(&Tetromino.right/1) |> show
  def rotate(game),    do: game |> move(&Tetromino.rotate/1) |> show
  def rotate_cw(game), do: game |> move(&Tetromino.rotate_cw/1) |> show
  def rotate_cc(game), do: game |> move(&Tetromino.rotate_cc/1) |> show

  def show(game) do
    %{game | points: Tetromino.show(game.tetro)}
    |> show
  end

  def new_tetromino(game) do
    %{ game | tetro: Tetromino.new_random() }
  end

end