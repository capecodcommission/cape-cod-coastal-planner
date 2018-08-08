defmodule ChipApi.Repo.Migrations.PreventNullLengthMilesColLittoralCell do
  use Ecto.Migration

  def change do

    alter table("littoral_cells") do
      remove :length_miles
      add :length_miles, :decimal, null: false
    end

  end
end
