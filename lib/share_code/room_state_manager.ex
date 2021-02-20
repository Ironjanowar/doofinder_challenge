defmodule ShareCode.RoomStateManager do
  use GenServer

  def child_spec(_) do
    %{id: __MODULE__, start: {__MODULE__, :start_link, []}}
  end

  # Client API
  def start_link(rooms) do
    GenServer.start_link(__MODULE__, rooms, name: __MODULE__)
  end

  def handle_new_msg(msg) do
    GenServer.cast(__MODULE__, {:new_msg, msg})
  end

  # Server callbacks
  def init(rooms) do
    state =
      rooms
      |> Enum.map(fn room -> {room, ""} end)
      |> Enum.into(%{})

    {:ok, state}
  end

  def handle_cast({:new_msg, msg}, state) do
    # Select room text from state

    # Apply add character algorithm
  end

  def handle_call({:get_text, room}, _from, state) do
    case Map.get(state, room, :no_room) do
      :no_room -> {:reply, "", state}
      text -> {:reply, text, state}
    end
  end
end
