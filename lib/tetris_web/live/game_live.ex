defmodule TetrisWeb.GameLive do
  use TetrisWeb, :live_view
  alias Tetris.Tetromino
  alias Tetris.TimeAlive

  @down_keys ["Enter", "ArrowDown"]

  def mount(_params, _sessions, socket) do
    # be sure we have a stable connection before backgrounding processes
    if connected?(socket) do
      :timer.send_interval(1000, :sec)
      :timer.send_interval(300, :tick)
    end
    new_socket = socket
              |> new_tetromino
              |> new_time
              |> show
    {:ok, new_socket}
  end

  def handle_info(:tick, socket) do
    # direction = [:cc, :cw, :nc] |> Enum.random
    updated_socket = socket
                  |> down
                  |> show
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
                  |> show
    {:noreply, updated_socket}
  end
  def handle_event("keystroke", %{"key" => "ArrowUp"}, socket) do
    updated_socket = socket
                  |> rotate(:cw)
                  |> show
    {:noreply, updated_socket}
  end
  def handle_event("keystroke", %{"key" => key}, socket) when key in @down_keys do
    updated_socket = socket
                  |> down
                  |> show
    {:noreply, updated_socket}
  end
  def handle_event("keystroke", %{"key" => "ArrowRight"}, socket) do
    updated_socket = socket
                  |> right
                  |> show
    {:noreply, updated_socket}
  end
  def handle_event("keystroke", %{"key" => "ArrowLeft"}, socket) do
    updated_socket = socket
                  |> left
                  |> show
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
      <h2>Time Alive: <%= @time %> secs</h2>
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
      <%= render_falling_tetromino(assigns) %>
    </svg>
    """
  end

  def render_falling_tetromino(assigns) do
    ~L"""
      <% {red, green, blue} = @tetro.color %>
      <%= for {x, y} <- @points do %>
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
      Points: <%= inspect @points %>
      <pre>
        shape: <%= @tetro.shape %>
        rotation: <%= @tetro.rotation %>
        location: <%= inspect @tetro.location %>
        color: <%= inspect @tetro.color %>
      </pre>
    </h3>
    """
  end

  # PRIVATE
  # everything ready to render
  defp show(socket) do
    assign( socket,
            # tetro: Tetromino.show(socket.assigns.tetro)
            points: Tetromino.show(socket.assigns.tetro)
          )
  end

  # Actions
  defp rotate(%{assigns: %{tetro: tetro}}=socket, direction) do
    assign(socket, tetro: Tetromino.rotate(tetro, direction))
    # assign(socket, rotation: Tetromino.rotate(tetro, direction))
  end
  # defp rotate(%{assigns: %{tetro: tetro}}=socket, :cw=direction) do
  #   assign(socket, tetro: Tetromino.rotate(tetro))
  # end
  # start over when we hit bottom
  defp down(%{assigns: %{tetro: %{location: {_, 19}}}}=socket) do
    # assign(socket, tetro: Tetromino.new_random())
    new_tetromino(socket)
  end
  defp down(%{assigns: %{tetro: tetro}}=socket) do
    assign(socket, tetro: Tetromino.down(tetro))
  end
  # start over when we hit bottom
  defp left(%{assigns: %{tetro: %{location: {0, _}}}}=socket) do
    # assign(socket, tetro: Tetromino.new_random())
    socket
  end
  defp left(%{assigns: %{tetro: tetro}}=socket) do
    assign(socket, tetro: Tetromino.left(tetro))
  end
  # start over when we hit bottom
  defp right(%{assigns: %{tetro: %{location: {10, _}}}}=socket) do
    # assign(socket, tetro: Tetromino.new_random())
    socket
  end
  defp right(%{assigns: %{tetro: tetro}}=socket) do
    assign(socket, tetro: Tetromino.right(tetro))
  end
  defp update_time(%{assigns: %{time: time}}=socket) do
    assign(socket, time: TimeAlive.increment(time))
  end

  defp new_time(socket) do
    assign(socket, time: TimeAlive.new())
  end
  defp new_tetromino(socket) do
    assign(socket, tetro: Tetromino.new_random())
  end

end