FROM elixir:1.6.6
WORKDIR /app
COPY . /app
RUN apt-get update && apt-get install -y postgresql-client && apt-get autoclean
RUN mix local.hex --force Y && mix local.rebar && mix deps.get
#
# MASTER
EXPOSE 4000 
# DEV
# EXPOSE 9000
# UAT
# EXPOSE 9001  
CMD ["/bin/bash","/app/startup.sh"]
