defmodule ChipApi.Repo.Migrations.CreateStrategiesLifeSpans do
  use Ecto.Migration

  def change do
    create table(:strategies_life_spans, primary_key: false) do
      add :strategy_id, references(:adaptation_strategies), null: false
      add :life_span_range_id, references(:impact_life_spans), null: false
    end
  end
end