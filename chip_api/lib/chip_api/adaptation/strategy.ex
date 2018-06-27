defmodule ChipApi.Adaptation.Strategy do
  use Ecto.Schema
  import Ecto.Changeset


  schema "adaptation_strategies" do
    field :description, :string
    field :name, :string

    many_to_many :adaptation_categories, ChipApi.Adaptation.Category,
      join_through: "strategy_categories"
    many_to_many :coastal_hazards, ChipApi.Adaptation.Hazard,
      join_through: "strategy_hazards"
    many_to_many :impact_scales, ChipApi.Adaptation.Scale,
      join_through: "strategy_scales"

    timestamps()
  end

  @doc false
  def changeset(strategy, attrs) do
    strategy
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
