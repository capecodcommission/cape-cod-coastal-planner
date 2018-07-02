defmodule ChipApi.Adaptation.Hazard do
  use Ecto.Schema
  import Ecto.Changeset
  alias ChipApi.Adaptation.Hazard

  schema "coastal_hazards" do
    field :description, :string
    field :name, :string

    many_to_many :adaptation_strategies, ChipApi.Adaptation.Strategy,
      join_through: "strategies_hazards",
      on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(hazard, attrs) do
    hazard
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
