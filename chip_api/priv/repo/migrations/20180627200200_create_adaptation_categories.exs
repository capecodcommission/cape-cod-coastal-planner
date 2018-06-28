defmodule ChipApi.Repo.Migrations.CreateAdaptationCategories do
  use Ecto.Migration

  def change do
    create table(:adaptation_categories) do
      add :name, :string, null: false
      add :description, :text

      timestamps()
    end

    create unique_index(:adaptation_categories, [:name])
  end
end
