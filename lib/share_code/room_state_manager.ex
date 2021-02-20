defmodule ShareCode.RoomStateManager do
  use GenServer

  alias ShareCode.MessageFormatter

  @rooms ["default_room"]

  def child_spec(_) do
    %{id: __MODULE__, start: {__MODULE__, :start_link, [@rooms]}}
  end

  # Client API
  def start_link(rooms) do
    GenServer.start_link(__MODULE__, rooms, name: __MODULE__)
  end

  def handle_new_msg(room, msg) do
    GenServer.cast(__MODULE__, {:new_msg, room, msg})
  end

  def get_room_state(room) do
    GenServer.call(__MODULE__, {:get_room_state, room})
  end

  # Server callbacks
  def init(rooms) do
    state =
      rooms
      |> Enum.map(fn room -> {room, ""} end)
      |> Enum.into(%{})

    {:ok, state}
  end

  def handle_cast({:new_msg, room, msg}, state) do
    # Select room text from state
    room_state =
      case Map.get(state, room, :no_room) do
        :no_room -> ""
        room_text -> room_text
      end

    # Apply add character algorithm
    new_room_state = MessageFormatter.add_character(room_state, msg)

    # Creates a room if does not exist
    {:noreply, Map.put(state, room, new_room_state)}
  end

  def handle_call({:get_room_state, room}, _from, state) do
    case Map.get(state, room, :no_room) do
      :no_room -> {:reply, "", state}
      text -> {:reply, text, state}
    end
  end
end
