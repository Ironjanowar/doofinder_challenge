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

release_env:
	export SECRET_KEY_BASE=$(shell mix phx.gen.secret)
	export MIX_ENV=prod

release: release_env deps compile
	mix release

start: release_env
	_build/dev/rel/share_code/bin/share_code daemon

stop:
	_build/dev/rel/share_code/bin/share_code stop

.PHONY: deps compile iex clean test release start stop
