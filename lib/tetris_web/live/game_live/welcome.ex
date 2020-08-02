defmodule TetrisWeb.GameLive.Welcome do
  use TetrisWeb, :live_view
  alias Tetris.Game
  # alias Tetris.Tetromino

  def mount(_params, _sessions, socket) do
    # game_done  = Map.get(socket.assigns, :game) || Game.new(continue_game: false)
    # new_socket = assign(socket,game: game_done)
    {:ok, socket}
  end

  def handle_event("play", _, socket) do
    {:noreply, play(socket)}
  end

  defp play(socket) do
    push_redirect(socket, to: "/game/play")
  end

  def render_board(assigns) do
    ~L"""
    <svg width="300" height="400">
      <rect width="300" height="400" style="fill:rgb(245,245,245);stroke-width:2;stroke:rgb(0,0,0)" />
      <%# render_gaves(assigns) %>
    </svg>
    """
  end

end