defmodule ChipApi.Repo.Migrations.DropStrategyPlacementsIfExist do
  use Ecto.Migration

  def change do
    drop_if_exists table("strategy_placements")
  end
end
