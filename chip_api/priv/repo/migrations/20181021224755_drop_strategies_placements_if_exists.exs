defmodule ChipApi.Repo.Migrations.DropStrategiesPlacementsIfExists do
  use Ecto.Migration

  def change do
    drop_if_exists table("strategies_placements")
  end
end
