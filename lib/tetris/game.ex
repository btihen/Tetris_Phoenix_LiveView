defmodule Tetris.Game do
  alias Tetris.{Points, Tetromino, TimeAlive}

  defstruct tetro: Tetromino.new_random, points: [], time: 0, score: 0, graveyard: %{}, continue_game: true

  def new(options \\ []) do
    game = __struct__(options)
        |> new_tetromino
        |> show
IO.inspect options
IO.inspect game
    game
  end

  def move(game, move_function) do
    {old, new, valid} = move_data(game, move_function)
    valid_tetro = Tetromino.test_move(old, new, valid)
    %{game | tetro: valid_tetro}
  end

  defp move_data(game, move_function) do
    old = game.tetro
    new = game.tetro
          |> move_function.()
    valid = new
          |> Tetromino.show
          |> Points.valid?(game.graveyard)
          #(&Points.all_valid?/1)
    {old, new, valid}
  end

  def down(game) do
    {old, new, valid} = move_data(game, &Tetromino.down/1)
    valid_tetro = Tetromino.test_move(old, new, valid)
    move_down_or_merge(game, old, new, valid)
  end
  defp move_down_or_merge(game, _old, new, true=_valid) do
    %{ game | tetro: new }
    |> show
    |> inc_score(1)
  end
  defp move_down_or_merge(game, old, _new, false=_valid) do
    game
    |> merge(old)
    |> new_tetromino()
    |> game_over?
    |> show
  end

  def inc_score(game, value) do
    %{ game | score: game.score + value }
  end

  # def down(game),         do: game |> move(&Tetromino.down/1) |> show
  def left(game),         do: game |> move(&Tetromino.left/1) |> show
  def right(game),        do: game |> move(&Tetromino.right/1) |> show
  def rotate(game, :cc),  do: game |> move(&Tetromino.rotate_cc/1) |> show
  def rotate(game, :cw),  do: game |> move(&Tetromino.rotate_cw/1) |> show
  def rotate(game, _),    do: game |> move(&Tetromino.rotate_cw/1) |> show
  def rotate(game),       do: game |> move(&Tetromino.rotate_cw/1) |> show

  def merge(game, old_tetro) do
    new_graveyard = old_tetro
                  |> Tetromino.points_w_color
                  |> Enum.into(game.graveyard)
    %{game | graveyard: new_graveyard}
  end

  def graveyard_points(game) do
    game.junkyard
    |> Enum.map(fn {{x,y}, _color} -> {x,y} end)
  end

  def update_time(game) do
    %{ game | time: TimeAlive.increment(game.time) }
  end

  def show(game) do
    %{game | points: Tetromino.show(game.tetro)}
  end

  def new_tetromino(game) do
    %{ game | tetro: Tetromino.new_random()}
  end

  defp game_over?(game) do
    new_is_valid = game.tetro
                |> Tetromino.show
                |> Points.valid?(game.graveyard)
    continue_game = new_is_valid and game.continue_game
    %{game | continue_game: continue_game}
  end

end