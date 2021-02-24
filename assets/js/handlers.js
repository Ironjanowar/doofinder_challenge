import { addCharacter, deleteCharacter } from "./utils"

const getSelectionRange = event => {
  let chatInput = document.querySelector("#text-input")

  return {
    selection_start: chatInput.selectionStart,
    selection_end: chatInput.selectionEnd
  }
}

export const pasteHandler = (event, channel) => {
  const textPasted = (event.clipboardData || window.clipboardData).getData('text')

  const selectionRange = getSelectionRange(event)

  channel.push("new_msg", {
    key: textPasted,
    selection_start: selectionRange.selection_start,
    selection_end: selectionRange.selection_end
  })
}

export const keydownHandler = (event, channel) => {
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

  const isKeyCommand = event.ctrlKey || event.metaKey || event.altKey
  const isCutCommand = isKeyCommand && event.keyCode === 88

  const selectionRange = getSelectionRange(event)

  if(valid && (!isKeyCommand || isCutCommand)) {
    channel.push("new_msg", {
      key: isCutCommand ? "cut" : event.key,
      selection_start: selectionRange.selection_start,
      selection_end: selectionRange.selection_end
    })
  }
}

export const socketMessageHandler = (payload) => {
  if(["backspace", "delete", "cut"].includes(payload.key.toLowerCase())) {
    deleteCharacter(payload)
  } else {
    addCharacter(payload)
  }
}
