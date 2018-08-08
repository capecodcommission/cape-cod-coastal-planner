defmodule ChipApi.Repo.Migrations.AddPublicBuildingsCountColLittoralCell do
  use Ecto.Migration

  def change do

    alter table("littoral_cells") do
      add :public_buildings_count, :integer, null: false
    end

  end
end
