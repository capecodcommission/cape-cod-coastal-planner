defmodule ChipApi.Repo.Migrations.CreateStrategiesHazards do
  use Ecto.Migration

  def change do
    create table(:strategies_hazards, primary_key: false) do
      add :strategy_id, references(:adaptation_strategies), null: false
      add :hazard_id, references(:coastal_hazards), null: false
    end
  end
end
