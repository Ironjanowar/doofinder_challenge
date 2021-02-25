# Design

To perform this technical test I have created a web server that serves an HTML page with a `textarea` where we can write some text.

The server will have a default room where the clients can join and type, connecting to the server via websockets.

When new keys are detected in the browser, the client will send the key events to the server. On receiving this event, the server records the changes (mantaining a state) and broadcasts it to every client (except the one who sent the message).

When a new client joins the server will assign an identifier to that client and send the current room state.

# Implementation

To create the web server I have used Phoenix Framework from Elixir, this framework offers websockets and the possibility to serve static HTML directly.

The client is made in Javascript and It will be served with the HTML.

## Client-Server Communication

The client will send an event for every key pressed, the event looks like this:

```json
{
  "key": "a",
  "selection_start": 0,
  "selection_end": 0
}
```

The attributes are:
 - `key` -> The key that was pressed.
 - `selection_start` -> If there is text selected indicates where in the textarea the selection starts, if not shows where the `key` was inserted.
 - `selection_end` -> If there is a text selected indicates whene in the textarea the selection ends, if not shows where the `key` was inserted.

The server will record the events in a GenServer, so when a new client joins the server will send the current state of the room. After recording the message the server will also broadcast the event to the rest of the clients.

## Modules

_I recommend reading this along with the code._

### `ShareCode.RoomStateManager`

This module defines the GenServer that is in charge of mantaining the room state. It has two main functions:
  - `&handle_new_msg/2` -> Receives a room and a new message. Makes an asynchronous call to the GenServer with a `cast`. The GenServer will record the new event in the given room.
  - `&get_room_state/1` -> Receives a room. Makes a synchronous call to the GenServer with a `call`. The GenServer will answer with the state of the room provided.

## `ShareCode.MessageFormatter`

This module defines different functions used to format a message to send or a message received. It has the following functions:
  - `&translate_key_code/1` -> Translates special key codes, right now it only translates the `Enter` to a `\n`.
  - `&add_room/2` -> Adds a room to a Map (normally an event).
  - `&add_assign_id/2` -> Adds an `assign_id` to a Map (normally an event) from a socket.
  - `&record_new_event/2` -> Modifies a `room_state` with the given event.
  - `&get_halfs/3` -> Divides a text by the given start and end selections.
  - `&delete_selection/4` and `&delete_selection/3` -> Deletes the text between the start and end selection. `&delete_selection/4` will delete the last character of the first half if `:delete_left` is provided and the first character of the second half if `:delete_right` is provided.
  - `&replace_selection/4` -> Replaces the text between selections with a new one.

## `ShareCodeWeb.DefaultRoomChannel`

This module specifies the behaviour for the socket where the clients are going to be connected. It has the following functions:
 - `&join/3` -> This function is called when new client joins. The server will get the room state and send it back to the client. The server will also assign an ID to that client to identify it.
 - `&handle_in/3` -> This function is called when a new message arrives (with the topic `new_msg`). The server will record the message, add the client ID to the message and brodcast it.
 - `&handle_out/3` -> This function is called when a message is going to be sent. The server will check if the message that we are sending has the same ID of the socket that where we are going to push the message, if the ID is the same the server will not send the message. This avoids that the client replicates the information.

# Whys

In this section I am going to explain some key decisions that I have made.

## Why sending key events and not text?

To minimize web traffic, sending text changes could not escalate properly. By sending the minimum information we can update in the server the changes and broadcast the same event.

## Why handle_out?

The main reason for `handle_out` is to avoid text replication in the client that sent the event.

The first version of this application had a different aproach, the `assign_id` (the client identification) was stored in each client and sent in every message. The clients will simply ignore the message if the `assign_id` in it was theirs, but once again this will only cause more web traffic.

The `handle_out` lets us intercept the outgoing message and do the work for the client. This will also make the client a bit lighter.

## Why a Map as the RoomStateManager state

By using a Map we can store multiple rooms with indpendent states, this may be helpful for future development.

# Usage

To deploy the web server execute the script `./deploy.sh`, it should create a release and start it. To stop the process execute `./stop.sh`

If this does not work start the aplication in dew with:
 - `make deps`
 - `make compile`
 - `make iex`

# Future Development

- Make the state in the server persistent. Using a non relational storage system such as Redis to save the rooms data we could save the state if the application needs an update or if it crashes.
- Modify clients to allow multiple rooms. The server is prepared for that but not the clients.
- Show cursor positions of other clients in the same room. By sending the cursor position everytime it moves the clients could render a bar to show the position of other clients.
