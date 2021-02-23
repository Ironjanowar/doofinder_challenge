defmodule ShareCodeWeb.DefaultRoomChannel do
  use Phoenix.Channel

  alias ShareCode.{MessageFormatter, RoomStateManager}

  require Logger

  @room_name "default_room"

  def join("default_room:" <> room, _message, socket) do
    room_text = RoomStateManager.get_room_state(room)

    {:ok, %{assign_id: UUID.uuid4(), room_text: room_text}, socket}
  end

  def handle_in("new_msg", msg, socket) do
    new_msg =
      msg |> MessageFormatter.translate_key_code() |> MessageFormatter.add_room(@room_name)

    RoomStateManager.handle_new_msg(@room_name, new_msg)
    broadcast!(socket, "new_msg", new_msg)

    {:noreply, socket}
  end
end
