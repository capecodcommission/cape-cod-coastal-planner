defmodule ChipApi.Repo.Migrations.AddRecreationOpenSpaceAcresColLittoralCell do
  use Ecto.Migration

  def change do

    alter table("littoral_cells") do
      add :recreation_open_space_acres, :decimal, null: false
    end

  end
end
