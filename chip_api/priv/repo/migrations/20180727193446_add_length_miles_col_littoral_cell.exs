defmodule ChipApi.Repo.Migrations.AddLengthMilesColLittoralCell do
  use Ecto.Migration

  def change do
    
    alter table("littoral_cells") do
      add :length_miles, :decimal
    end

  end
end
