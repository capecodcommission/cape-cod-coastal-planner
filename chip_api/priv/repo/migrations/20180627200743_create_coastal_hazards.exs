defmodule ChipApi.Repo.Migrations.CreateCoastalHazards do
  use Ecto.Migration

  def change do
    create table(:coastal_hazards) do
      add :name, :string, null: false
      add :description, :text

      timestamps()
    end

    create unique_index(:coastal_hazards, [:name])

  end
end
