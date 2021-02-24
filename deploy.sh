#!/bin/bash

export SECRET_KEY_BASE=$(mix phx.gen.secret)

echo -e "\nExecuting mix deps.get\n"
mix deps.get --only prod

export MIX_ENV=prod
echo -e "\n\nExecuting mix deps.copmile\n"
mix deps.compile

echo -e "\n\nExecuting mix compile\n"
mix compile

echo -e "\n\nInstalling npm dependencies\n"
cd assets && npm install && cd ..

echo -e "\n\nCompiling assets\n"
npm run deploy --prefix ./assets
mix phx.digest

echo -e "\n\nCreating release\n"
mix release

echo -e "\n\nStarting application\n"
echo -e "_build/prod/rel/share_code/bin/share_code daemon"
_build/prod/rel/share_code/bin/share_code daemon
