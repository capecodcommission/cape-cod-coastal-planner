defmodule ChipApi.Repo.Migrations.CreateStrategyCategories do
  use Ecto.Migration

  def change do
    create table(:strategy_categories, primary_key: false) do
      add :strategy_id, references(:adaptation_strategies), null: false
      add :category_id, references(:adaptation_categories), null: false
    end
  end
end
