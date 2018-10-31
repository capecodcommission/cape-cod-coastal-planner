defmodule ChipApi.Repo.Migrations.AddAdaptationStrategiesBeachWidthImpactM do
  use Ecto.Migration

  def change do
    alter table(:adaptation_strategies) do
      add :beach_width_impact_m, :float
    end
  end
end
