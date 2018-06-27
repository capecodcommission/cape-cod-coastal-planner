defmodule ChipApi.Repo.Migrations.CreateStrategyHazards do
  use Ecto.Migration

  def change do
    create table(:strategy_hazards, primary_key: false) do
      add :strategy_id, references(:adaptation_strategies), null: false
      add :hazard_id, references(:coastal_hazards), null: false
    end
  end
end
