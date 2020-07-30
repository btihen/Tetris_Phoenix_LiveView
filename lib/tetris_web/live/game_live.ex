defmodule TetrisWeb.GameLive do
  use TetrisWeb, :live_view
  alias Tetris.Tetromino
  alias Tetris.{Game, TimeAlive}

  @down_keys ["Enter", "ArrowDown"]

  def mount(_params, _sessions, socket) do
    # be sure we have a stable connection before backgrounding processes
    if connected?(socket) do
      :timer.send_interval(1000, :sec)
      :timer.send_interval(300, :tick)
    end
    new_socket = socket |> new_game
    {:ok, new_socket}
  end

  def handle_info(:tick, socket) do
    # direction = [:cc, :cw, :nc] |> Enum.random
    updated_socket = socket
                  |> down
    {:noreply, updated_socket}
  end

  def handle_info(:sec, socket) do
    updated_socket = socket
                  |> update_time
    {:noreply, updated_socket}
  end

  def handle_event("keystroke", %{"key" => " "}, socket) do
    updated_socket = socket
                  |> rotate(:cc)
    {:noreply, updated_socket}
  end
  def handle_event("keystroke", %{"key" => "ArrowUp"}, socket) do
    updated_socket = socket
                  |> rotate(:cw)
    {:noreply, updated_socket}
  end
  def handle_event("keystroke", %{"key" => key}, socket) when key in @down_keys do
    updated_socket = socket
                  |> down
    {:noreply, updated_socket}
  end
  def handle_event("keystroke", %{"key" => "ArrowRight"}, socket) do
    updated_socket = socket
                  |> right
    {:noreply, updated_socket}
  end
  def handle_event("keystroke", %{"key" => "ArrowLeft"}, socket) do
    updated_socket = socket
                  |> left
    {:noreply, updated_socket}
  end
  # ignore all other keystrokes
  def handle_event("keystroke", %{"key" => _key}, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <h1>Wecome to Tetris<h1>
      <h2>Time Alive: <%= @game.time %> secs</h2>
      <div phx-window-keydown="keystroke">
        <%= render_board(assigns) %>
        <%= render_debug_info(assigns) %>
      </div>
    </section>
    """
  end

  def render_board(assigns) do
    ~L"""
    <svg width="300" height="400">
      <rect width="300" height="400" style="fill:rgb(245,245,245);stroke-width:2;stroke:rgb(0,0,0)" />
      <%# render_tetromino(assigns) %>
      <%= render_tetromino_n_gaves(assigns) %>
    </svg>
    """
  end

  def render_tetromino(assigns) do
    ~L"""
      <% {red, green, blue} = @game.tetro.color %>
      <%= for {x, y} <- @game.points do %>
        <rect
            width="20" height="20"
            x="<%= x*20 %>" y="<%= y*20 %>"
            style="fill:rgb(<%= red %>,<%= green %>,<%= blue %>);stroke-width:1;stroke:rgb(0,0,0)" />
      <% end %>
    """
  end

  def render_tetromino_n_gaves(assigns) do
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
      Points: <%= inspect @game.points %>
      <pre>
        shape: <%= @game.tetro.shape %>
        rotation: <%= @game.tetro.rotation %>
        location: <%= inspect @game.tetro.location %>
        color: <%= inspect @game.tetro.color %>
      </pre>
      Graveyard: <%= inspect @game %>
    </h3>
    """
  end

  # PRIVATE
  # everything ready to render

  # Actions
  defp rotate(%{assigns: %{game: game}}=socket, direction) do
    assign(socket, game: Game.rotate(game, direction))
    # assign(socket, rotation: Tetromino.rotate(tetro, direction))
  end
  # # start over when we hit bottom
  # defp down(%{assigns: %{game: %{tetro: %{location: {_, y}}}}}=socket) when y > 15 do
  #   new_tetromino(socket)
  # end
  defp down(%{assigns: %{game: game}}=socket) do
    assign(socket, game: Game.down(game))
  end
  defp left(%{assigns: %{game: game}}=socket) do
    assign(socket, game: Game.left(game))
  end
  defp right(%{assigns: %{game: game}}=socket) do
    assign(socket, game: Game.right(game))
  end
  defp update_time(%{assigns: %{game: game}}=socket) do
    assign(socket, game: Game.update_time(game))
  end

  defp new_time(socket) do
    assign(socket, time: TimeAlive.new())
  end
  defp new_game(socket) do
    assign(socket, game: Game.new())
  end
  defp new_tetromino(socket) do
    assign(socket, game: Game.new_tetromino(socket.assigns.game))
  end

end