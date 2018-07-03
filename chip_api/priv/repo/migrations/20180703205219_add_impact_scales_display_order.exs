defmodule ChipApi.Repo.Migrations.AddImpactScalesDisplayOrder do
  use Ecto.Migration

  def change do
    alter table(:impact_scales) do
      add :display_order, :integer
    end
  end
end
