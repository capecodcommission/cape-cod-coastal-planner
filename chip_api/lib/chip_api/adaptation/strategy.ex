defmodule ChipApi.Adaptation.Strategy do
  use Ecto.Schema
  import Ecto.Changeset


  schema "adaptation_strategies" do
    field :description, :string
    field :name, :string
    field :display_order, :integer
    field :is_active, :boolean, default: false
    field :currently_permittable, :string
    field :strategy_placement, :string

    many_to_many :adaptation_categories, ChipApi.Adaptation.Category,
      join_through: "strategies_categories",
      on_delete: :delete_all

    many_to_many :coastal_hazards, ChipApi.Adaptation.Hazard,
      join_through: "strategies_hazards",
      on_delete: :delete_all

    many_to_many :impact_scales, ChipApi.Adaptation.Scale,
      join_through: "strategies_scales",
      on_delete: :delete_all

    many_to_many :adaptation_benefits, ChipApi.Adaptation.Benefit,
      join_through: "strategies_benefits",
      on_delete: :delete_all
    
    has_many :adaptation_advantages, ChipApi.Adaptation.Advantage, 
      on_delete: :delete_all
    
    has_many :adaptation_disadvantages, ChipApi.Adaptation.Disadvantage, 
      on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(strategy, attrs) do
    strategy
    |> cast(attrs, [:name, :description, :display_order, :currently_permittable])
    |> validate_required([:name, :is_active])
    |> unique_constraint(:name)
  end
end
