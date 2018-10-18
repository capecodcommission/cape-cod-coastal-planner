defmodule ChipApi.Repo.Migrations.CreateImpactLifeSpans do
  use Ecto.Migration

  def change do
    create table(:impact_life_spans) do
      add :name, :string, null: false
      add :description, :text
      add :life_span, :integer, null: false
      
      timestamps()
    end

    create unique_index(:impact_life_spans, [:name])
  end
end