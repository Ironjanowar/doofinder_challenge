defmodule ShareCodeWeb.DefaultRoomChannelTest do
  use ShareCodeWeb.ChannelCase, async: false

  alias ShareCode.RoomStateManager

  setup _tags do
    # Reset the RoomStateManager state at the beginning of every test
    :sys.replace_state(RoomStateManager, fn _ -> %{} end)
  end

  test "Join default_room" do
    {:ok, reply, _} =
      ShareCodeWeb.RoomSocket
      |> socket()
      |> subscribe_and_join(ShareCodeWeb.DefaultRoomChannel, "default_room:default_room")

    uuid_info = reply |> Map.get(:assign_id) |> UUID.info()

    assert Map.get(reply, :room_text) == ""
    assert elem(uuid_info, 0) == :ok
  end

  test "Save data sending to socket" do
    {:ok, %{assign_id: assign_id}, socket} =
      ShareCodeWeb.RoomSocket
      |> socket()
      |> subscribe_and_join(ShareCodeWeb.DefaultRoomChannel, "default_room:default_room")

    push(socket, "new_msg", %{
      "key" => "a",
      "assign_id" => assign_id,
      "selection_start" => 0,
      "selection_end" => 0
    })

    assert_broadcast("new_msg", %{
      "key" => "a",
      "assign_id" => _,
      "selection_start" => 0,
      "selection_end" => 0
    })

    assert RoomStateManager.get_room_state("default_room") == "a"
  end

  test "Receive decault_room state when joining" do
    {:ok, %{assign_id: assign_id}, socket} =
      ShareCodeWeb.RoomSocket
      |> socket()
      |> subscribe_and_join(ShareCodeWeb.DefaultRoomChannel, "default_room:default_room")

    push(socket, "new_msg", %{
      "key" => "a",
      "assign_id" => assign_id,
      "selection_start" => 0,
      "selection_end" => 0
    })

    {:ok, %{room_text: room_text}, _} =
      ShareCodeWeb.RoomSocket
      |> socket()
      |> subscribe_and_join(ShareCodeWeb.DefaultRoomChannel, "default_room:default_room")

    assert room_text == "a"
  end
end
