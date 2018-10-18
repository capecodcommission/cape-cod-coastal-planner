defmodule ChipApi.Adaptation.Life_Span_Range do
  use Ecto.Schema
  import Ecto.Changeset

  schema "impact_life_spans" do
    field :description, :string
    field :life_span, :integer
    field :name, :string
    field :display_order, :integer

    many_to_many :adaptation_strategies, ChipApi.Adaptation.Strategy,
      join_through: "strategies_life_spans",
      on_delete: :delete_all

    timestamps()
  end
  
  @doc false
  def changeset(life_span, attrs) do
    life_span
    |> cast(attrs, [:name, :description, :life_span])
    |> validate_required([:name, :life_span])
    |> unique_constraint(:name)
  end
end