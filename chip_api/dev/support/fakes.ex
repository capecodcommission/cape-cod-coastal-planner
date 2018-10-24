defmodule ChipApi.Fakes do
    alias ChipApi.Repo
    alias ChipApi.Adaptation.{Strategy, Category, Hazard, Scale, Placement, Benefit, Advantage, Disadvantage, CostRange, LifeSpanRange}
    alias ChipApi.Geospatial.LittoralCell
    alias Decimal, as: D

    @cat1 %Category{name: "cat1"}
    @cat2 %Category{name: "cat2"}
    @haz1 %Hazard{name: "haz1", display_order: 2}
    @haz2 %Hazard{name: "haz2", display_order: 1}
    @scale1 %Scale{name: "scale1", impact: 1, display_order: 1}
    @scale2 %Scale{name: "scale2", impact: 2}
    @scale3 %Scale{name: "scale3", impact: 3, display_order: 2}
    @costrange1 %CostRange{name: "costrange1", cost: 1, display_order: 1}
    @costrange2 %CostRange{name: "costrange2", cost: 2}
    @costrange3 %CostRange{name: "costrange3", cost: 3, display_order: 2}
    @costrange4 %CostRange{name: "costrange4", cost: 4, display_order: 3}
    @lifespanrange1 %LifeSpanRange{name: "lifespanrange1", life_span: 1, display_order: 1}
    @lifespanrange2 %LifeSpanRange{name: "lifespanrange2", life_span: 2}
    @lifespanrange3 %LifeSpanRange{name: "lifespanrange3", life_span: 3, display_order: 2}
    @lifespanrange4 %LifeSpanRange{name: "lifespanrange4", life_span: 4, display_order: 3}
    @place1 %Placement{name: "place1"}
    @place2 %Placement{name: "place2"}
    @benefit1 %Benefit{name: "benefit1", display_order: 0}
    @benefit2 %Benefit{name: "benefit2", display_order: 1}
    @advantage1 %Advantage{name: "advantage1", display_order: 0}
    @advantage2 %Advantage{name: "advantage2", display_order: 1}
    @advantage3 %Advantage{name: "advantage3", display_order: 0}
    @disadvantage1 %Disadvantage{name: "disadvantage1", display_order: 0}
    @disadvantage2 %Disadvantage{name: "disadvantage2", display_order: 1}
    @disadvantage3 %Disadvantage{name: "disadvantage3", display_order: 0}
    @strat1 %Strategy{name: "strat1", description: "desc1", is_active: true, display_order: 1}
    @strat2 %Strategy{name: "strat2", description: "desc2", is_active: false, display_order: 2}
    @cell1 %LittoralCell{
        name: "cell1", 
        min_x: -70.0, 
        min_y: 41.0, 
        max_x: -69.0, 
        max_y: 42.0, 
        length_miles: D.new("3.3"), 
        imperv_percent: D.new("3.3"),
        critical_facilities_count: 1,
        coastal_structures_count: 1,
        working_harbor: false,
        public_buildings_count: 1,
        salt_marsh_acres: D.new("10.01"),
        eelgrass_acres: D.new("1.1"),
        coastal_dune_acres: D.new("2.2"),
        rare_species_acres: D.new("3.3"),
        public_beach_count: 1,
        recreation_open_space_acres: D.new("10.01"),
        town_ways_to_water: 1,
        national_seashore: false,
        total_assessed_value: D.new("1000.00"),
        littoral_cell_id: 1
    }
    @cell2 %LittoralCell{
        name: "cell2", 
        min_x: -70.0, 
        min_y: 41.0, 
        max_x: -69.0, 
        max_y: 42.0, 
        length_miles: D.new("3.3"), 
        imperv_percent: D.new("3.3"),
        critical_facilities_count: 1,
        coastal_structures_count: 1,
        working_harbor: true,
        public_buildings_count: 1,
        salt_marsh_acres: D.new("10.01"),
        eelgrass_acres: D.new("1.1"),
        coastal_dune_acres: D.new("2.2"),
        rare_species_acres: D.new("3.3"),
        public_beach_count: 1,
        recreation_open_space_acres: D.new("10.01"),
        town_ways_to_water: 1,
        national_seashore: true,
        total_assessed_value: D.new("1000.00"),
        littoral_cell_id: 2
    }


    def run_categories do
        cat1 = @cat1 |> Repo.insert!
        cat2 = @cat2 |> Repo.insert!

        strat1 = @strat1
        |> Map.merge(%{adaptation_categories: [cat1, cat2]})
        |> Repo.insert!

        strat2 = @strat2
        |> Map.merge(%{adaptation_categories: [cat1, cat2]})
        |> Repo.insert!

        {:ok, data: %{
            cat1: cat1,
            cat2: cat2,
            strat1: strat1,
            strat2: strat2
        }}
    end
    
    def run_hazards do
        haz1 = @haz1 |> Repo.insert!
        haz2 = @haz2 |> Repo.insert!

        strat1 = @strat1
        |> Map.merge(%{coastal_hazards: [haz1, haz2]})
        |> Repo.insert!

        strat2 = @strat2
        |> Map.merge(%{coastal_hazards: [haz1, haz2]})
        |> Repo.insert!

        {:ok, data: %{
            haz1: haz1,
            haz2: haz2,
            strat1: strat1,
            strat2: strat2
        }}
    end

    def run_scales do
        scale1 = @scale1 |> Repo.insert!
        scale2 = @scale2 |> Repo.insert!
        scale3 = @scale3 |> Repo.insert!

        strat1 = @strat1
        |> Map.merge(%{impact_scales: [scale1, scale2, scale3]})
        |> Repo.insert!

        strat2 = @strat2
        |> Map.merge(%{impact_scales: [scale1, scale2, scale3]})
        |> Repo.insert!

        {:ok, data: %{
            scale1: scale1,
            scale2: scale2,
            scale3: scale3,
            strat1: strat1,
            strat2: strat2
        }}
    end
    
    def run_cost_ranges do
        costrange1 = @costrange1 |> Repo.insert!
        costrange2 = @costrange2 |> Repo.insert!
        costrange3 = @costrange3 |> Repo.insert!
        costrange4 = @costrange4 |> Repo.insert!

        strat1 = @strat1
        |> Map.merge(%{cost_ranges: [costrange1, costrange2, costrange3, costrange4]})
        |> Repo.insert!

        strat2 = @strat2
        |> Map.merge(%{cost_ranges: [costrange1, costrange2, costrange3, costrange4]})
        |> Repo.insert!

        {:ok, data: %{
            costrange1: costrange1,
            costrange2: costrange2,
            costrange3: costrange3,
            costrange4: costrange4,
            strat1: strat1,
            strat2: strat2
        }}
    end
    
    def run_life_span_ranges do
        lifespanrange1 = @lifespanrange1 |> Repo.insert!
        lifespanrange2 = @lifespanrange2 |> Repo.insert!
        lifespanrange3 = @lifespanrange3 |> Repo.insert!
        lifespanrange4 = @lifespanrange4 |> Repo.insert!

        strat1 = @strat1
        |> Map.merge(%{life_span_ranges: [lifespanrange1, lifespanrange2, lifespanrange3, lifespanrange4]})
        |> Repo.insert!

        strat2 = @strat2
        |> Map.merge(%{life_span_ranges: [lifespanrange1, lifespanrange2, lifespanrange3, lifespanrange4]})
        |> Repo.insert!

        {:ok, data: %{
            lifespanrange1: lifespanrange1,
            lifespanrange2: lifespanrange2,
            lifespanrange3: lifespanrange3,
            lifespanrange4: lifespanrange4,
            strat1: strat1,
            strat2: strat2
        }}
    end

    def run_benefits do
        benefit1 = @benefit1 |> Repo.insert!
        benefit2 = @benefit2 |> Repo.insert!

        strat1 = @strat1
        |> Map.merge(%{adaptation_benefits: [benefit1, benefit2]})
        |> Repo.insert!

        strat2 = @strat2
        |> Map.merge(%{adaptation_benefits: [benefit1, benefit2]})
        |> Repo.insert!

        {:ok, data: %{
            benefit1: benefit1,
            benefit2: benefit2,
            strat1: strat1,
            strat2: strat2
        }}
    end

    def run_littoral_cells do
        cell1 = @cell1 |> Repo.insert!
        cell2 = @cell2 |> Repo.insert!

        {:ok, data: %{
            cell1: cell1,
            cell2: cell2
        }}
    end

    def run_all_adaptation do
        cat1 = @cat1 |> Repo.insert!
        cat2 = @cat2 |> Repo.insert!
        haz1 = @haz1 |> Repo.insert!
        haz2 = @haz2 |> Repo.insert!
        scale1 = @scale1 |> Repo.insert!
        scale2 = @scale2 |> Repo.insert!
        costrange1 = @costrange1 |> Repo.insert!
        costrange2 = @costrange2 |> Repo.insert!
        costrange3 = @costrange3 |> Repo.insert!
        costrange4 = @costrange4 |> Repo.insert!
        lifespanrange1 = @lifespanrange1 |> Repo.insert!
        lifespanrange2 = @lifespanrange2 |> Repo.insert!
        lifespanrange3 = @lifespanrange3 |> Repo.insert!
        lifespanrange4 = @lifespanrange4 |> Repo.insert!
        place1 = @place1 |> Repo.insert!
        place2 = @place2 |> Repo.insert!
        benefit1 = @benefit1 |> Repo.insert!
        benefit2 = @benefit2 |> Repo.insert!
        advantage1 = @advantage1 |> Repo.insert!
        advantage2 = @advantage2 |> Repo.insert!
        advantage3 = @advantage3 |> Repo.insert!
        disadvantage1 = @disadvantage1 |> Repo.insert!
        disadvantage2 = @disadvantage2 |> Repo.insert!
        disadvantage3 = @disadvantage3 |> Repo.insert!

        strat1 = @strat1
        |> Map.merge(%{
            adaptation_categories: [cat1, cat2],
            coastal_hazards: [haz1, haz2],
            impact_scales: [scale1, scale2],
            adaptation_benefits: [benefit1, benefit2],
            adaptation_advantages: [advantage1, advantage2],
            adaptation_disadvantages: [disadvantage1, disadvantage2]
        })
        |> Repo.insert!

        strat2 = @strat2
        |> Map.merge(%{
            adaptation_categories: [cat1, cat2],
            coastal_hazards: [haz1, haz2],
            impact_scales: [scale1, scale2],
            adaptation_benefits: [benefit1],
            adaptation_advantages: [advantage3],
            adaptation_disadvantages: [disadvantage3]
        })
        |> Repo.insert!

        {:ok, data: %{
            cat1: cat1,
            cat2: cat2,
            haz1: haz1,
            haz2: haz2,
            scale1: scale1,
            scale2: scale2,
            costrange1: costrange1,
            costrange2: costrange2,
            costrange3: costrange3,
            costrange4: costrange4,
            lifespanrange1: lifespanrange1,
            lifespanrange2: lifespanrange2,
            lifespanrange3: lifespanrange3,
            lifespanrange4: lifespanrange4,
            place1: place1,
            place2: place2,
            benefit1: benefit1,
            benefit2: benefit2,
            advantage1: advantage1,
            advantage2: advantage2,
            disadvantage1: disadvantage1,
            disadvantage2: disadvantage2,
            strat1: strat1,
            strat2: strat2            
        }}
    end
end