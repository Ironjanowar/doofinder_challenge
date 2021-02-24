# Design

To perform this technical test I have created a web server that serves an HTML page with a `textarea` where we can write some text.

The server will have a default room where the clients can join and type, connecting to the server via websockets.

When new keys are detected in the browser, the client will send the key events to the server. On receiving this event, the server records the changes (mantaining a state) and broadcasts it to every client (except the one who sent the message).

When a new client joins the server will assign an identifier to that client and send the current room state.

# Implementation

To create the web server I have used Phoenix Framework from Elixir, this framework offers websockets and the possibility to serve static HTML directly.

The client is made in Javascript and It will be served with the HTML.

## Communication client-server

The client will send an event for every key pressed, the event looks like this:

```json
{
  key: "a",
  selection_start: 0,
  selection_end: 0
}
```

The attributes are:
 - `key` -> The key that was pressed
 - `selection_start` -> If there is text selected indicates where in the textarea the selection starts, if not shows where the `key` was inserted
 - `selection_end` -> If there is a text selected indicates whene in the textarea the selection ends, if not shows where the `key` was inserted

The server will record the events in a GenServer, so when a new client joins the server will send the current state of the room. After recording the message the server will also broadcast the event to the rest of the clients.

## Modules

_I recommend reading this along with the code._

### `ShareCode.RoomStateManager`

This module defines the GenServer that is in charge of mantaining the room state. It has two main functions:
  - `&handle_new_msg/2` -> Receives a room and a new message. Makes an asynchronous call to the GenServer with a `cast`. The GenServer will record the new event in the given room
  - `&get_room_state/1` -> Receives a room. It will make

## Tests

## Docs

# Future development
