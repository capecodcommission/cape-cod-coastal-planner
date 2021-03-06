defmodule ChipApi.Adaptation.Placement do
    use Ecto.Schema
    import Ecto.Changeset

    schema "strategy_placements" do
        field :name, :string

        has_many :adaptation_strategies, ChipApi.Adaptation.Strategy,
            on_delete: :delete_all

        timestamps()
    end

    @doc false
    def changeset(placement, attrs) do
        placement
        |> cast(attrs, [:name])
        |> validate_required([:name])
        |> unique_constraint(:name)
    end
end