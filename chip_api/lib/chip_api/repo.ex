defmodule ChipApi.Repo do
  use Ecto.Repo, otp_app: :chip_api

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do

    opts = 
      opts
      |> overwrite_opt(:hostname, "DB_HOST")
      |> overwrite_opt(:username, "DB_USERNAME")
      |> overwrite_opt(:password, "DB_PASSWORD")
      |> overwrite_opt(:database, "DB_DATABASE")
      |> Keyword.put(:url, System.get_env("DATABASE_URL"))

    {:ok, opts}

  end

  defp overwrite_opt(opts, atom, key) do
    env_var = System.get_env(key)

    if env_var != nil do
      opts = Keyword.put(opts, atom, env_var)
    else
      opts
    end
  end

end
