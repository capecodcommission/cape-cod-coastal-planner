defmodule ChipApi.Repo.Migrations.AddCoastalDuneAcresColLittoralCell do
  use Ecto.Migration

  def change do
    
    alter table("littoral_cells") do
      add :coastal_dune_acres, :decimal, null: false
    end
    
  end

end
