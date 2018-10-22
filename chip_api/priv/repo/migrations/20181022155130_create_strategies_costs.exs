defmodule ChipApi.Repo.Migrations.CreateStrategiesCosts do
  use Ecto.Migration

  def change do
    create table(:strategies_costs, primary_key: false) do
      add :strategy_id, references(:adaptation_strategies), null: false
      add :scale_id, references(:impact_costs), null: false
    end
  end
end
