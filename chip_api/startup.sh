#!/usr/bin/env bash
set -ex
mix ecto.reset
# mix ecto.setup # ACTIVATE ONLY FOR LOCAL BUILDS
mix phx.server