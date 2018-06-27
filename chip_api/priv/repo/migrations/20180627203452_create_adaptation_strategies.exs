defmodule ChipApi.Repo.Migrations.CreateAdaptationStrategies do
  use Ecto.Migration

  def change do
    create table(:adaptation_strategies) do
      add :name, :string
      add :description, :string

      timestamps()
    end

  end
end
