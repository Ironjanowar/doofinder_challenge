import { deleteCharacter } from "./utils"

const getSelectionRange = event => {
  let chatInput = document.querySelector("#chat-input")

  return {
    selection_start: chatInput.selectionStart,
    selection_end: chatInput.selectionEnd
  }
}

export const keyupHandler = (event, channel, assignId) => {
  const valid =
      (event.keyCode > 47 && event.keyCode < 58)   || // number keys
      event.keyCode == 32 || event.keyCode == 13   || // spacebar & return key(s) (if you want to allow carriage returns)
      (event.keyCode > 64 && event.keyCode < 91)   || // letter keys
      (event.keyCode > 95 && event.keyCode < 112)  || // numpad keys
      (event.keyCode > 185 && event.keyCode < 193) || // ;=,-./` (in order)
      (event.keyCode > 218 && event.keyCode < 223) ||  // [\]' (in order)
      event.keyCode == 8

  const selectionRange = getSelectionRange(event)

  if(valid) {
    channel.push("new_msg", {
      key: event.key,
      assign_id: assignId,
      selection_start: selectionRange.selection_start,
      selection_end: selectionRange.selection_end
    })
  }
  console.log(event)
}

export const socketMessageHandler = (payload, assignId) => {
  console.log(payload)

  if(payload.assign_id === assignId) return

  if(payload.key.toLowerCase() === "backspace") {
    deleteCharacter(payload)
    return
  }

  let chatInput = document.querySelector("#chat-input")
  console.log(`PRE UPDATE: ${chatInput.innerHTML}`);
  chatInput.value = `${chatInput.value}${payload.key}`
  console.log(`POST UPDATE: ${chatInput.innerHTML}`);
}
