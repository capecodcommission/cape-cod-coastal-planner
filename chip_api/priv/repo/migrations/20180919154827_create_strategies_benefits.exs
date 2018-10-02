defmodule ChipApi.Repo.Migrations.CreateStrategiesBenefits do
  use Ecto.Migration

  def change do
    create table(:strategies_benefits, primary_key: false) do
      add :strategy_id, references(:adaptation_strategies), null: false
      add :benefit_id, references(:adaptation_benefits), null: false
    end
  end
end
