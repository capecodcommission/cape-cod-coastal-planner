#!/usr/bin/env bash
set -ex
mix ecto.reset
mix phx.server