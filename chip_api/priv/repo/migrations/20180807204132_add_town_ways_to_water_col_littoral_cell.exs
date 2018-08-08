defmodule ChipApi.Repo.Migrations.AddTownWaysToWaterColLittoralCell do
  use Ecto.Migration

  def change do

    alter table("littoral_cells") do
      add :town_ways_to_water, :integer, null: false
    end

  end
end
