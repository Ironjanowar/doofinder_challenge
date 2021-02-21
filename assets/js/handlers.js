import { addCharacter, deleteCharacter } from "./utils"

const getSelectionRange = event => {
  let chatInput = document.querySelector("#chat-input")

  return {
    selection_start: chatInput.selectionStart,
    selection_end: chatInput.selectionEnd
  }
}

export const pasteHandler = (event, channel, assignId) => {
  const textPasted = (event.clipboardData || window.clipboardData).getData('text')

  const selectionRange = getSelectionRange(event)

  channel.push("new_msg", {
    key: textPasted,
    assign_id: assignId,
    selection_start: selectionRange.selection_start,
    selection_end: selectionRange.selection_end
  })
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

  const isKeyCommand = event.ctrlKey || event.metaKey
  const isCutCommand = isKeyCommand && event.keyCode === 88

  const selectionRange = getSelectionRange(event)

  if(valid && (!isKeyCommand || isCutCommand)) {
    channel.push("new_msg", {
      key: isCutCommand ? "cut" : event.key,
      assign_id: assignId,
      selection_start: selectionRange.selection_start,
      selection_end: selectionRange.selection_end
    })
  }
}

export const socketMessageHandler = (payload, assignId) => {
  if(payload.assign_id === assignId) return

  if(["backspace", "delete", "cut"].includes(payload.key.toLowerCase())) {
    deleteCharacter(payload)
    return
  }

  addCharacter(payload)
}
