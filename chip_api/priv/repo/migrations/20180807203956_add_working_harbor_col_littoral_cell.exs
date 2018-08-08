defmodule ChipApi.Repo.Migrations.AddWorkingHarborColLittoralCell do
  use Ecto.Migration

  def change do

    alter table("littoral_cells") do
      add :working_harbor, :boolean, null: false
    end

  end
end
