MIX_ENV?=dev

deps:
	mix deps.get
	mix deps.compile

compile:
	mix compile

iex:
	iex -S mix phx.server

clean:
	rm -rf _build

test: compile
	mix test

.PHONY: deps compile iex clean test release start stop release_env
