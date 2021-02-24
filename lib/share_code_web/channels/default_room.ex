defmodule ShareCodeWeb.DefaultRoomChannel do
  use Phoenix.Channel

  alias ShareCode.{MessageFormatter, RoomStateManager}

  @room_name "default_room"

  intercept(["new_msg"])

  def join("default_room:" <> room, _message, socket) do
    room_text = RoomStateManager.get_room_state(room)
    assign_id = UUID.uuid4()

    {:ok, %{assign_id: assign_id, room_text: room_text}, assign(socket, :assign_id, assign_id)}
  end

  def handle_in("new_msg", msg, socket) do
    new_msg =
      msg
      |> MessageFormatter.translate_key_code()
      |> MessageFormatter.add_room(@room_name)
      |> MessageFormatter.add_assign_id(socket)

    RoomStateManager.handle_new_msg(@room_name, new_msg)
    broadcast!(socket, "new_msg", new_msg)

    {:noreply, socket}
  end

  def handle_out("new_msg", msg, socket) do
    {assign_id, msg_to_send} = Map.pop(msg, "assign_id")

    if socket.assigns[:assign_id] != assign_id do
      push(socket, "new_msg", msg_to_send)
    end

    {:noreply, socket}
  end
end
