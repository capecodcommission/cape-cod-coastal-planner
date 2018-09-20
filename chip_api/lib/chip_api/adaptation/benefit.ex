defmodule ChipApi.Adaptation.Benefit do
  use Ecto.Schema
  import Ecto.Changeset


  schema "adaptation_benefits" do
    field :display_order, :integer
    field :name, :string

    many_to_many :adaptation_strategies, ChipApi.Adaptation.Strategy,
      join_through: "strategies_benefits",
      on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(benefit, attrs) do
    benefit
    |> cast(attrs, [:name, :display_order])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
