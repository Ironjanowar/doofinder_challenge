defmodule ShareCode.MessageFormatter do
  def translate_key_code(%{"key" => "Enter"} = msg), do: Map.put(msg, "key", "\n")
  def translate_key_code(msg), do: msg

  def add_room(msg, room), do: Map.put(msg, "room", room)
end
