defmodule ChipApi.Repo.Migrations.AdaptationAdvantagesBelongsToAdaptationStrategies do
  use Ecto.Migration

  def change do
    alter table(:adaptation_advantages) do
      add :strategy_id, references(:adaptation_strategies)
    end
  end
end
