import { Socket } from "phoenix"
import { pasteHandler, socketMessageHandler, keydownHandler } from "./handlers"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

let channel = socket.channel("default_room:default_room", {})
let textInput = document.querySelector("#text-input")

textInput.addEventListener("keydown", event => keydownHandler(event, channel))
textInput.addEventListener("paste", event => pasteHandler(event, channel))
channel.on("new_msg", payload => socketMessageHandler(payload))

channel.join()
  .receive("ok", resp => {
    textInput.value = resp.room_text
  })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
