defmodule ChipApi.Repo.Migrations.CreateStrategiesScales do
  use Ecto.Migration

  def change do
    create table(:strategies_scales, primary_key: false) do
      add :strategy_id, references(:adaptation_strategies), null: false
      add :scale_id, references(:impact_scales), null: false
    end
  end
end
