defmodule ShareCode.MessageFormatter do
  @doc ~S"""
  Translates keys to actual characters

  ## Examples

      iex> ShareCode.MessageFormatter.translate_key_code(%{"key" => "Enter"})
      %{"key" => "\n"}

      iex> ShareCode.MessageFormatter.translate_key_code(%{"key" => "2"})
      %{"key" => "2"}
  """
  def translate_key_code(%{"key" => "Enter"} = msg), do: Map.put(msg, "key", "\n")
  def translate_key_code(msg), do: msg

  @doc ~S"""
  Adds the room name to a message

  ## Examples

      iex> ShareCode.MessageFormatter.add_room(%{}, "room_name")
      %{"room" => "room_name"}
  """
  def add_room(msg, room), do: Map.put(msg, "room", room)

  def add_character(room_state, %{
        "key" => "Backspace",
        "selection_start" => selection_start,
        "selection_end" => selection_end
      }) do
    delete_selection(room_state, selection_start, selection_end)
  end

  def add_character(room_state, %{
        "key" => character,
        "selection_start" => selection_start,
        "selection_end" => selection_end
      }) do
    replace_selection(room_state, character, selection_start, selection_end)
  end

  # Utils
  @doc ~S"""
  Splits a text leaving the selection in the middle

  ## Examples

      iex> ShareCode.MessageFormatter.get_halfs("aoeu", 1, 1)
      {"a", "oeu"}
      iex> ShareCode.MessageFormatter.get_halfs("aoeu", 1, 2)
      {"a", "eu"}
  """
  def get_halfs(text, selection_start, selection_end) do
    first_half = String.slice(text, 0, selection_start)
    second_half = String.slice(text, selection_end..-1)

    {first_half, second_half}
  end

  @doc ~S"""
  Deletes text from a given selection

  ## Examples

      iex> ShareCode.MessageFormatter.delete_selection("aoeu", 2, 2)
      "aeu"
      iex> ShareCode.MessageFormatter.delete_selection("aoeu", 1, 2)
      "eu"
  """
  def delete_selection(text, selection_start, selection_end) do
    {first_half, second_half} = get_halfs(text, selection_start, selection_end)
    first_half_with_backspace = String.slice(first_half, 0..-2)

    "#{first_half_with_backspace}#{second_half}"
  end

  @doc ~S"""
  Adds text replacing a given selection

  ## Examples

      iex> ShareCode.MessageFormatter.replace_selection("aoeu", "b", 1, 1)
      "aboeu"
      iex> ShareCode.MessageFormatter.replace_selection("aoeu", "b", 1, 2)
      "abeu"
  """
  def replace_selection(text, new_text, selection_start, selection_end) do
    {first_half, second_half} = get_halfs(text, selection_start, selection_end)

    "#{first_half}#{new_text}#{second_half}"
  end
end
