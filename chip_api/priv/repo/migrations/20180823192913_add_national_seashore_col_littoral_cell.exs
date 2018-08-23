defmodule ChipApi.Repo.Migrations.AddNationalSeashoreColLittoralCell do
  use Ecto.Migration

  def change do

    alter table("littoral_cells") do
      add :national_seashore, :boolean, null: false
    end

  end
end
