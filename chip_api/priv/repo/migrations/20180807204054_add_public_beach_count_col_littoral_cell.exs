defmodule ChipApi.Repo.Migrations.AddPublicBeachCountColLittoralCell do
  use Ecto.Migration

  def change do

    alter table("littoral_cells") do
      add :public_beach_count, :integer, null: false
    end

  end
end
