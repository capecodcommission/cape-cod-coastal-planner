defmodule ChipApi.Repo.Migrations.CreateStrategiesPlacements do
  use Ecto.Migration

  def change do
    create table(:strategies_placements, primary_key: false) do
      add :strategy_id, references(:adaptation_strategies), null: false
      add :placement_id, references(:strategy_placements), null: false
    end
  end
end
