defmodule ChipApi.Repo.Migrations.AddCriticalFacilitiesCountColLittoralCell do
  use Ecto.Migration

  def change do

    alter table("littoral_cells") do
      add :critical_facilities_count, :integer, null: false
    end

  end
end
