export const deleteCharacter = (payload) => {
  console.log("Deleting character:", payload)
  let chatInput = document.querySelector("#chat-input")
  const firstHalf = chatInput.value.slice(0, payload.selection_start - 1)
  const secondHalf = chatInput.value.slice(payload.selection_end)
  chatInput.value = `${firstHalf}${secondHalf}`
}

export const addCharacter = (payload) => {
  let chatInput = document.querySelector("#chat-input")
  console.log(`PRE UPDATE: ${chatInput.value}`);
  const firstHalf = chatInput.value.slice(0, payload.selection_start)
  const secondHalf = chatInput.value.slice(payload.selection_end)
  chatInput.value = `${firstHalf}${payload.key}${secondHalf}`
  console.log(`POST UPDATE: ${chatInput.value}`);
}
