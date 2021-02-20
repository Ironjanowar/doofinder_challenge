MIX_ENV?=dev

deps:
	mix deps.get
	mix deps.compile
compile: deps
	mix compile

iex:
	iex -S mix phx.server

clean:
	rm -rf _build

.PHONY: deps compile iex clean
