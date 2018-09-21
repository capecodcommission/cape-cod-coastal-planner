defmodule ChipApi.Adaptation.Advantage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "adaptation_advantages" do
    field :name, :string
    field :display_order, :integer

    # One to many relationship with strategy
    belongs_to :adaptation_strategies, ChipApi.Adaptation.Strategy

    timestamps()
  end

  @doc false
  def changeset(advantage, attrs) do
    advantage
    |> cast(attrs, [:name, :display_order])
    |> validate_required([:name])
  end

end