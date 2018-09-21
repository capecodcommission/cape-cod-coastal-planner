defmodule ChipApi.Adaptation.Disadvantage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "adaptation_disadvantages" do
    field :name, :string
    field :display_order, :integer

    # One to many relationship with strategy
    belongs_to :adaptation_strategies, ChipApi.Adaptation.Strategy

    timestamps()
  end

  @doc false
  def changeset(disadvantage, attrs) do
    disadvantage
    |> cast(attrs, [:name, :display_order])
    |> validate_required([:name])
  end

end