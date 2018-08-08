defmodule ChipApi.Repo.Migrations.AddEelgrassAcresColLittoralCell do
  use Ecto.Migration

  def change do

    alter table("littoral_cells") do
      add :eelgrass_acres, :decimal, null: false
    end

  end
end
