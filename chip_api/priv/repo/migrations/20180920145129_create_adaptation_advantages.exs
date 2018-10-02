defmodule ChipApi.Repo.Migrations.CreateAdaptationAdvantages do
  use Ecto.Migration

  def change do
    create table(:adaptation_advantages) do
      add :name, :string
      add :display_order, :integer

      timestamps()
    end
  end
end
