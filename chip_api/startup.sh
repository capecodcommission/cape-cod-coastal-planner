#!/usr/bin/env bash
set -ex

mix ecto.setup
mix test
mix phx.server