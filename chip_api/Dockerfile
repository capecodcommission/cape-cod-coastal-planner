FROM elixir:1.6.6
WORKDIR /app
COPY . /app
RUN apt-get update && apt-get install -y postgresql-client && apt-get autoclean
RUN mix local.hex --force Y
RUN mix local.rebar
RUN mix deps.get
# MASTER
# EXPOSE 4000 
# DEV
EXPOSE 9000 
CMD ["/bin/bash","/app/startup.sh"]
