#!/usr/bin/env bash
set -ex

# mix ecto.create
# mix ecto.migrate
# mix run priv/repo/seeds.exs

MIX_ENV=dev

mix phx.server