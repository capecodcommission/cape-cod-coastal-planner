defmodule ChipApi.Repo.Migrations.CreateAdaptationDisadvantages do
  use Ecto.Migration

  def change do
    create table(:adaptation_disadvantages) do
      add :name, :string
      add :display_order, :integer

      timestamps()
    end
  end
end
