defmodule CallJSonClientWeb.DeviceLive.FormComponent do
  use CallJSonClientWeb, :live_component

  alias CallJSonClient.Containers

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage device records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="device-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Device</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{device: device} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Containers.change_device(device))
     end)}
  end

  @impl true
  def handle_event("validate", %{"device" => device_params}, socket) do
    changeset = Containers.change_device(socket.assigns.device, device_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"device" => device_params}, socket) do
    save_device(socket, socket.assigns.action, device_params)
  end

  defp save_device(socket, :edit, device_params) do
    case Containers.update_device(socket.assigns.device, device_params) do
      {:ok, device} ->
        notify_parent({:saved, device})

        {:noreply,
         socket
         |> put_flash(:info, "Device updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_device(socket, :new, device_params) do
    case Containers.create_device(device_params) do
      {:ok, device} ->
        notify_parent({:saved, device})

        {:noreply,
         socket
         |> put_flash(:info, "Device created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
