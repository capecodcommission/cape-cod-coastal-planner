defmodule ChipApi.Repo.Migrations.PreventNullDurationColCoastalHazards do
  use Ecto.Migration

  def change do
    alter table("coastal_hazards") do
      remove :duration
      add :duration, :string, null: false
    end
  end
end
