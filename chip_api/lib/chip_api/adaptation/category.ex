defmodule ChipApi.Adaptation.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias ChipApi.Adaptation.Category


  schema "adaptation_categories" do
    field :description, :string
    field :name, :string
    field :display_order, :integer

    many_to_many :adaptation_strategies, ChipApi.Adaptation.Strategy,
      join_through: "strategies_categories",
      on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :description, :display_order])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
