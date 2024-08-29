defmodule CallJSonClientWeb.DeviceLive.Index do
  use CallJSonClientWeb, :live_view
  alias CallJSonClient.Containers

  @impl true
  def mount(_params, _session, socket) do
    Process.send_after(self(), :timer, 300)
    {:ok, stream(socket, :devices, Containers.list_devices())}
  end

  @impl true
  def handle_info(:timer, socket) do
    Process.send_after(self(), :timer, 200)
    [plid] = Enum.take_random(1..2, 1)
    pl = "polyline" <> to_string(plid)
    y = :rand.uniform() * 100
    t = :rand.uniform() * 10
    {:noreply, push_event(socket, "xy_plot_event", %{id: pl, t: t, y: y})}
  end
end
