defmodule ChipApi.Repo do
  use Ecto.Repo, otp_app: :chip_api

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do

    opts = 
      opts
      |> Keyword.put(:hostname, System.get_env("DB_HOST"))
      |> Keyword.put(:username, System.get_env("DB_USERNAME"))
      |> Keyword.put(:password, System.get_env("DB_PASSWORD"))
      |> Keyword.put(:database, System.get_env("DB_DATABASE"))
      |> Keyword.put(:url, System.get_env("DATABASE_URL"))

    {:ok, opts}

  end
end
