defmodule ChipApi.Adaptation.Scale do
  use Ecto.Schema
  import Ecto.Changeset


  schema "impact_scales" do
    field :description, :string
    field :impact, :integer
    field :name, :string

    many_to_many :adaptation_strategies, ChipApi.Adaptation.Strategy,
      join_through: "strategy_scales"

    timestamps()
  end

  @doc false
  def changeset(scale, attrs) do
    scale
    |> cast(attrs, [:name, :description, :impact])
    |> validate_required([:name, :impact])
    |> unique_constraint(:name)
  end
end
