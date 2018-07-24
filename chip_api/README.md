# ChipApi

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000/graphiql`](http://localhost:4000/graphiql) from your browser and query the API.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix


# More Commands cheatsheet

  * `mix help <command>`
    * print help documentation for a given command
  * `set "MIX_ENV=<env>" && mix <command> <args>`
    * set your mix env (ie: to `prod`) when not running against the default of `dev`
  * `mix deps.clean --all`
    * clean out deps
  * `set "MIX_ENV=prod && mix release --env=prod`
    * build a production release
  * `set "MIX_ENV=prod && mix release.clean`
    * clean out release files but leave generated release configuration
  * `set "MIX_ENV=prod && mix release.clean --implode`
    * completely clean out entire release folder
  * `mix ecto.dump -d my_file.sql`
    * create a sql dump of database migrations
  * `mix test`
    * run all tests
  * `mix test --only <moduletag>`
    * run tests that include a given modeule tag and no others

pg_dump.bat --column-inserts --data-only 