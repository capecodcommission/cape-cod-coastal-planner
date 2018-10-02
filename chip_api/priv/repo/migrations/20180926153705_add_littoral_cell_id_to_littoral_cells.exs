defmodule ChipApi.Repo.Migrations.AddLittoralCellIdToLittoralCells do
  use Ecto.Migration

  def change do
    alter table(:littoral_cells) do
      add :littoral_cell_id, :integer
    end
  end
end
