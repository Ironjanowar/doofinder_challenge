const getHalfs = (payload, text) => {
  let chatInput = document.querySelector("#chat-input")
  if(payload.key === "Delete") {
    const firstHalf = chatInput.value.slice(0, payload.selection_start)
    const secondHalf = chatInput.value.slice(payload.selection_end)

    return {first_half: firstHalf, second_half: secondHalf.slice(1)}
  } else {
    const firstHalf = chatInput.value.slice(0, payload.selection_start !== 0 ? payload.selection_start - 1 : 0)
    const secondHalf = chatInput.value.slice(payload.selection_end)

    return {first_half: firstHalf, second_half: secondHalf}
  }
}

export const deleteCharacter = (payload) => {
  console.log("Deleting character:", payload)
  let chatInput = document.querySelector("#chat-input")
  const {first_half, second_half} = getHalfs(payload, chatInput.value)

  chatInput.value = `${first_half}${second_half}`
}

export const addCharacter = (payload) => {
  let chatInput = document.querySelector("#chat-input")
  const firstHalf = chatInput.value.slice(0, payload.selection_start)
  const secondHalf = chatInput.value.slice(payload.selection_end)
  chatInput.value = `${firstHalf}${payload.key}${secondHalf}`
}
