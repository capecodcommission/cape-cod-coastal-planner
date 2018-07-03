defmodule ChipApi.Repo.Migrations.AddAdaptationStrategiesDisplayOrder do
  use Ecto.Migration

  def change do
    alter table(:adaptation_strategies) do
      add :display_order, :integer
    end
  end
end
