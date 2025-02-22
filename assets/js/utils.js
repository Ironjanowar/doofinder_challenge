const getHalfs = (payload, text) => {
  let chatInput = document.querySelector("#text-input")
  if(payload.key === "Delete") {
    const firstHalf = chatInput.value.slice(0, payload.selection_start)
    const secondHalf = chatInput.value.slice(payload.selection_end)

    return {first_half: firstHalf, second_half: secondHalf.slice(1)}
  } else if(payload.key === "Backspace" && payload.selection_start === payload.selection_end) {
    const firstHalf = chatInput.value.slice(0, payload.selection_start !== 0 ? payload.selection_start - 1 : 0)
    const secondHalf = chatInput.value.slice(payload.selection_end)
    return {first_half: firstHalf, second_half: secondHalf}
  } else {
    const firstHalf = chatInput.value.slice(0, payload.selection_start)
    const secondHalf = chatInput.value.slice(payload.selection_end)

    return {first_half: firstHalf, second_half: secondHalf}
  }
}

export const deleteCharacter = (payload) => {
  let chatInput = document.querySelector("#text-input")
  const {first_half, second_half} = getHalfs(payload, chatInput.value)

  chatInput.value = `${first_half}${second_half}`
}

export const addCharacter = (payload) => {
  let chatInput = document.querySelector("#text-input")
  const firstHalf = chatInput.value.slice(0, payload.selection_start)
  const secondHalf = chatInput.value.slice(payload.selection_end)
  chatInput.value = `${firstHalf}${payload.key}${secondHalf}`
}
