defmodule ChipApi.Repo.Migrations.AddImpervPercentColLittoralCell do
  use Ecto.Migration

  def change do

    alter table("littoral_cells") do
      add :imperv_percent, :decimal
    end

  end
end
