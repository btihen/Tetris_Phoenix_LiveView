defmodule TetrisWeb.GameLive do
  use TetrisWeb, :live_view
  alias Tetris.Tetromino
  alias Tetris.TimeAlive

  def mount(_params, _sessions, socket) do
    :timer.send_interval(1000, :sec)
    :timer.send_interval(300, :tick)
    new_socket = socket
              |> new_tetromino
              |> new_time
              |> show
    {:ok, new_socket}
  end

  def handle_info(:tick, socket) do
    updated_socket = socket
                  |> down
                  |> show
    {:noreply, updated_socket}
  end

  def handle_info(:sec, socket) do
    updated_socket = socket
                  |> update_time
                  # |> new_tetromino(socket)
    {:noreply, updated_socket}
  end

  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <h1>Wecome to Tetris<h1>
      <h2>Time Alive: <%= @time %> secs</h2>

      <%= render_board(assigns) %>

      <hr>

      <%= render_info(assigns) %>

    </section>
    """
  end

  def render_board(assigns) do
    ~L"""
    <svg width="200" height="400">
      <rect width="200" height="400" style="fill:rgb(245,245,245);stroke-width:2;stroke:rgb(0,0,0)" />
      <%= render_points(assigns) %>
    </svg>
    """
  end

  def render_points(assigns) do
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

  def render_info(assigns) do
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
            points: Tetromino.show(socket.assigns.tetro)
          )
  end

  # Actions
  defp down(%{assigns: %{tetro: %{location: {_, 19}}}}=socket) do
    # assign(socket, tetro: Tetromino.new_random())
    new_tetromino(socket)
  end
  defp down(%{assigns: %{tetro: tetro}}=socket) do
    assign(socket, tetro: Tetromino.down(tetro))
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