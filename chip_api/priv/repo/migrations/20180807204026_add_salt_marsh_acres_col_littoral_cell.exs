defmodule ChipApi.Repo.Migrations.AddSaltMarshAcresColLittoralCell do
  use Ecto.Migration

  def change do

    alter table("littoral_cells") do
      add :salt_marsh_acres, :decimal, null: false
    end

  end
end
