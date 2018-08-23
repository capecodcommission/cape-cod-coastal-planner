defmodule ChipApi.Repo.Migrations.AddRareSpeciesAcresColLittoralCell do
  use Ecto.Migration

  def change do

    alter table("littoral_cells") do
      add :rare_species_acres, :decimal, null: false
    end

  end
end
