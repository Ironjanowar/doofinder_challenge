defmodule ShareCodeWeb.DefaultRoomChannel do
  use Phoenix.Channel

  alias ShareCode.{MessageFormatter, RoomStateManager}

  require Logger

  @room_name "default_room"

  def join("default_room:lobby", _message, socket) do
    {:ok, UUID.uuid4(), socket}
  end

  def handle_in("new_msg", msg, socket) do
    Logger.debug("socket: #{inspect(socket)}")
    Logger.debug("msg: #{inspect(msg)}")

    new_msg =
      msg |> MessageFormatter.translate_key_code() |> MessageFormatter.add_room(@room_name)

    broadcast!(socket, "new_msg", new_msg)

    {:noreply, socket}
  end
end
