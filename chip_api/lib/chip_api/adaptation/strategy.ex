defmodule ChipApi.Adaptation.Strategy do
  use Ecto.Schema
  import Ecto.Changeset


  schema "adaptation_strategies" do
    field :description, :string
    field :name, :string

    many_to_many :adaptation_categories, ChipApi.Adaptation.Category,
      join_through: "strategies_categories",
      on_delete: :delete_all

    many_to_many :coastal_hazards, ChipApi.Adaptation.Hazard,
      join_through: "strategies_hazards",
      on_delete: :delete_all

    many_to_many :impact_scales, ChipApi.Adaptation.Scale,
      join_through: "strategies_scales",
      on_delete: :delete_all

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
