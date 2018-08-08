defmodule ChipApi.Repo.Migrations.AddCoastalStructuresCountColLittoralCell do
  use Ecto.Migration

  def change do

    alter table("littoral_cells") do
      add :coastal_structures_count, :integer, null: false
    end

  end
end
