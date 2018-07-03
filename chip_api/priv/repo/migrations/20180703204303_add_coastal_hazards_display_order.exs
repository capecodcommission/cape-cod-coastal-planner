defmodule ChipApi.Repo.Migrations.AddCoastalHazardsDisplayOrder do
  use Ecto.Migration

  def change do
    alter table(:coastal_hazards) do
      add :display_order, :integer
    end
  end
end
