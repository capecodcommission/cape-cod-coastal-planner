FROM elixir:1.6.6
WORKDIR /app
COPY . /app
RUN mix local.hex --force Y
RUN mix deps.get
RUN mix local.rebar
ENV MIX_ENV=dev
RUN mix ecto.create
RUN mix ecto.migrate
RUN mix run priv/repo/seeds.exs
RUN mix test
EXPOSE 4000
CMD ["mix", "phx.server"] 
