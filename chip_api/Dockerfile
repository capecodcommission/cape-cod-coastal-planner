FROM elixir:1.6.6
WORKDIR /app
COPY . /app
RUN apt-get update && apt-get install -y postgresql-client && apt-get autoclean
RUN mix local.hex --force Y
RUN mix deps.get
RUN mix local.rebar
ENV MIX_ENV=test
EXPOSE 4000
CMD ["/bin/bash","/app/startup.sh"]
