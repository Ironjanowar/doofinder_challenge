import { addCharacter, deleteCharacter } from "./utils"

const getSelectionRange = event => {
  let chatInput = document.querySelector("#chat-input")

  return {
    selection_start: chatInput.selectionStart,
    selection_end: chatInput.selectionEnd
  }
}

export const keydownHandler = (event, channel, assignId) => {
  const validKeys = [
    32, // Spacebar
    13, // Return
    8,  // Backspace
    46  // Delete
  ]

  const valid =
      (event.keyCode > 47 && event.keyCode < 58)   || // number keys
      (event.keyCode > 64 && event.keyCode < 91)   || // letter keys
      (event.keyCode > 95 && event.keyCode < 112)  || // numpad keys
      (event.keyCode > 185 && event.keyCode < 193) || // ;=,-./` (in order)
      (event.keyCode > 218 && event.keyCode < 223) ||  // [\]' (in order)
      validKeys.includes(event.keyCode)

  const isKeyCommand = event.ctrlKey

  const selectionRange = getSelectionRange(event)

  if(valid && !isKeyCommand) {
    channel.push("new_msg", {
      key: event.key,
      assign_id: assignId,
      selection_start: selectionRange.selection_start,
      selection_end: selectionRange.selection_end
    })
  }
}

export const socketMessageHandler = (payload, assignId) => {
  if(payload.assign_id === assignId) return

  if(["backspace", "delete"].includes(payload.key.toLowerCase())) {
    deleteCharacter(payload)
    return
  }

  addCharacter(payload)
}
