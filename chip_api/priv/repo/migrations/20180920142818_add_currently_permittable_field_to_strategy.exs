defmodule ChipApi.Repo.Migrations.AddCurrentlyPermittableFieldToStrategy do
  use Ecto.Migration

  def change do
    alter table(:adaptation_strategies) do
      add :currently_permittable, :string
    end
  end
end
