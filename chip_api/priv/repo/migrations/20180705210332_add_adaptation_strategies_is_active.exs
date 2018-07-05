defmodule ChipApi.Repo.Migrations.AddAdaptationStrategiesIsActive do
  use Ecto.Migration

  def change do
    alter table(:adaptation_strategies) do
      add :is_active, :boolean
    end
  end
end
