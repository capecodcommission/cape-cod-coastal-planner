defmodule ChipApi.Repo.Migrations.AddAdaptationCategoriesDisplayOrder do
  use Ecto.Migration

  def change do
    alter table(:adaptation_categories) do
      add :display_order, :integer
    end
  end
end
