defmodule ChipApi.Repo.Migrations.CreateAdaptationStrategies do
  use Ecto.Migration

  def change do
    create table(:adaptation_strategies) do
      add :name, :string
      add :description, :text

      timestamps()
    end

    create unique_index(:adaptation_strategies, [:name])
  end
end
