defmodule ChipApi.Repo.Migrations.AddTotalAssessedValueColLittoralCell do
  use Ecto.Migration

  def change do

    alter table("littoral_cells") do
      add :total_assessed_value, :decimal, null: false
    end

  end
end
