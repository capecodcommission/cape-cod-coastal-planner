defmodule ChipApi.Repo.Migrations.CreateImpactScales do
  use Ecto.Migration

  def change do
    create table(:impact_scales) do
      add :name, :string, null: false
      add :description, :string
      add :impact, :integer, null: false

      timestamps()
    end

    create unique_index(:impact_scales, [:name])
  end
end
