defmodule ChipApi.Adaptation.Cost_Range do
  use Ecto.Schema
  import Ecto.Changeset

  schema "impact_costs" do
    field :description, :string
    field :cost, :integer
    field :name, :string
    field :name_linear_foot, :string
    field :display_order, :integer

    many_to_many :adaptation_strategies, ChipApi.Adaptation.Strategy,
      join_through: "strategies_costs",
      on_delete: :delete_all

    timestamps()
  end
  
  @doc false
  def changeset(cost, attrs) do
    cost
    |> cast(attrs, [:name, :name_linear_foot, :description, :cost])
    |> validate_required([:name, :cost])
    |> unique_constraint(:name)
  end
end