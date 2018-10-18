defmodule ChipApi.Repo.Migrations.CreateImpactCosts do
  use Ecto.Migration

  def change do
    create table(:impact_costs) do
      add :name, :string, null: false
      add :name_linear_foot, :string, null: false
      add :description, :text
      add :cost, :integer, null: false

      timestamps()
    end

    create unique_index(:impact_costs, [:name])
  end
end