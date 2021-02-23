defmodule ShareCode.RoomStateManagerTest do
  use ExUnit.Case, async: true

  alias ShareCode.RoomStateManager

  setup _tags do
    # Reset the RoomStateManager state at the beginning of every test
    :sys.replace_state(RoomStateManager, fn _ -> %{} end)
  end

  test "Inserts text in the default_room" do
    RoomStateManager.handle_new_msg("default_room", %{
      "key" => "a",
      "selection_start" => 0,
      "selection_end" => 0
    })

    assert :sys.get_state(RoomStateManager) == %{"default_room" => "a"}
  end

  test "Gets data from default_room" do
    RoomStateManager.handle_new_msg("default_room", %{
      "key" => "a",
      "selection_start" => 0,
      "selection_end" => 0
    })

    assert RoomStateManager.get_room_state("default_room") == "a"
  end

  test "Creates a new room" do
    RoomStateManager.handle_new_msg("new_room", %{
      "key" => "a",
      "selection_start" => 0,
      "selection_end" => 0
    })

    assert RoomStateManager.get_room_state("new_room") == "a"
    assert RoomStateManager.get_room_state("default_room") == ""
  end
end
