defmodule ChipApi.Repo.Migrations.AddDurationToCoastalHazards do
  use Ecto.Migration

  def change do
    alter table(:coastal_hazards) do
      add :duration, :string
    end
  end
end
