defmodule Mix.Tasks.App.Version do
    use Mix.Task

    @shortdoc "Prints current app version to console"
    def run(_) do
        IO.puts Mix.Project.config[:version]
    end
end