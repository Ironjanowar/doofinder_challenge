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

release: deps compile release_env
	mix phx.digest
	MIX_ENV=prod mix release

start: release_env
	MIX_ENV=prod _build/prod/rel/share_code/bin/share_code daemon

stop:
	_build/prod/rel/share_code/bin/share_code stop

.PHONY: deps compile iex clean test release start stop release_env
