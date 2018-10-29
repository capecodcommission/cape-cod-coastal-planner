defmodule ChipApi.Repo.Migrations.AddImpactCostsDisplayOrder do
  use Ecto.Migration

  def change do
    alter table(:impact_costs) do
      add :display_order, :integer
    end
  end
end
