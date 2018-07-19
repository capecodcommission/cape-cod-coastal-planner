defmodule ChipApi.Repo.Migrations.CreateLittoralCells do
  use Ecto.Migration

  def change do
    create table(:littoral_cells) do
      add :name, :string
      add :minX, :float
      add :minY, :float
      add :maxX, :float
      add :maxY, :float

      timestamps()
    end

    create unique_index(:littoral_cells, [:name])
  end
end
