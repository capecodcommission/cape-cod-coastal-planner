defmodule ChipApi.Repo.Migrations.CreateAdaptationBenefits do
  use Ecto.Migration

  def change do
    create table(:adaptation_benefits) do
      add :name, :string
      add :display_order, :integer

      timestamps()
    end

    create unique_index(:adaptation_benefits, [:name])
  end
end
