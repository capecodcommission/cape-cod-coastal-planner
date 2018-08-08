defmodule ChipApi.Repo.Migrations.PreventNullImpervPercentColLittoralCell do
  use Ecto.Migration

  def change do

    alter table("littoral_cells") do
      remove :imperv_percent
      add :imperv_percent, :decimal, null: false
    end

  end
end
