defmodule TetrisWeb.GameLive.Over do
  use TetrisWeb, :live_view
  # alias Tetris.TimeAlive
  # alias Tetris.Tetromino
  alias Tetris.Game

  # @down_keys ["Enter", "ArrowDown"]

  def mount(params, _sessions, socket) do
    score = params["score"] || 0
    # game_done  = Map.get(socket.assigns, :game) || Game.new(continue_game: false)
    new_socket = assign(socket, score: score)
# IO.inspect socket
# IO.inspect game_done
# IO.inspect game_done.graveyard
# IO.inspect new_socket
    {:ok, new_socket}
  end

  def handle_event("play", _, socket) do
    {:noreply, play(socket)}
  end
  # ignore all other keystrokes
  def handle_event("keystroke", %{"key" => _key}, socket) do
    {:noreply, socket}
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

  def render_gaves(assigns) do
    ~L"""
    <% display_points = Tetromino.points_w_color(@game.tetro) |> Enum.into(@game.graveyard) |> Enum.map(&Tuple.to_list/1) %>
    <%= for [{x, y}, {red, green, blue}] <- display_points do %>
      <rect
          width="20" height="20"
          x="<%= x*20 %>" y="<%= y*20 %>"
          style="fill:rgb(<%= red %>,<%= green %>,<%= blue %>);stroke-width:1;stroke:rgb(0,0,0)" />
    <% end %>
    """
  end

  def render_debug_info(assigns) do
    ~L"""
    <h3>
      Live Action: <%= inspect @live_action %>
      <pre>
        game_over: <%= !@game.continue_game %>
        continue_game: <%= @game.continue_game %>
        shape: <%= @game.tetro.shape %>
        rotation: <%= @game.tetro.rotation %>
        location: <%= inspect @game.tetro.location %>
        color: <%= inspect @game.tetro.color %>
        Points: <%= inspect @game.points %>
        Graveyard: <%= inspect @game.graveyard %>
      </pre>
    </h3>
    """
  end

end