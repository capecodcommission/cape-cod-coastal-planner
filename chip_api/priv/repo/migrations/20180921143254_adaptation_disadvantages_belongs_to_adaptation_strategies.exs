defmodule ChipApi.Repo.Migrations.AdaptationDisadvantagesBelongsToAdaptationStrategies do
  use Ecto.Migration

  def change do
    alter table(:adaptation_disadvantages) do
      add :strategy_id, references(:adaptation_strategies)
    end
  end
end
