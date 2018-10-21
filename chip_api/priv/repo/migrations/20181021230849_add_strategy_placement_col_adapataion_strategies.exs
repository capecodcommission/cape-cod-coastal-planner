defmodule ChipApi.Repo.Migrations.AddStrategyPlacementColAdapataionStrategies do
  use Ecto.Migration

  def change do
    alter table("adaptation_strategies") do
      add :strategy_placement, :string
    end
  end
end
