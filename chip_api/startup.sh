#!/usr/bin/env bash
set -ex
# ONLY FOR DATABASE UPDATES
mix ecto.reset
# ONLY IF BLANK DATABASE (e.g. PRUNED DOCKER SYSTEM)
# mix ecto.setup
# mix phx.server