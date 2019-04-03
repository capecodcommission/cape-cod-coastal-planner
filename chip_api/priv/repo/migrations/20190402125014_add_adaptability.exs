defmodule ChipApi.Repo.Migrations.AddAdaptability do
  use Ecto.Migration

  def change do
    alter table("adaptation_strategies") do
      add :applicability, :string
    end
  end
end
