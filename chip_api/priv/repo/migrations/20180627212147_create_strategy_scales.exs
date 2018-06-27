defmodule ChipApi.Repo.Migrations.CreateStrategyScales do
  use Ecto.Migration

  def change do
    create table(:strategy_scales, primary_key: false) do
      add :strategy_id, references(:adaptation_strategies), null: false
      add :scale_id, references(:impact_scales), null: false
    end
  end
end
