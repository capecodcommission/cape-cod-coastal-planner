defmodule ChipApi.Repo.Migrations.AddImpactLifeSpansDisplayOrder do
  use Ecto.Migration

  def change do
    alter table(:impact_life_spans) do
      add :display_order, :integer
    end
  end
end
