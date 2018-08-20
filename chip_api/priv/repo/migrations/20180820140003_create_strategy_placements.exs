defmodule ChipApi.Repo.Migrations.CreateStrategyPlacements do
  use Ecto.Migration

  def change do
    create table(:strategy_placements) do
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:strategy_placements, [:name])
  end
end
