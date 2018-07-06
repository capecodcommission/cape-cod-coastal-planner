defmodule ChipApi.Fakes do
    alias ChipApi.Repo
    alias ChipApi.Adaptation.{Strategy, Category, Hazard, Scale}

    @cat1 %Category{name: "cat1"}
    @cat2 %Category{name: "cat2"}
    @haz1 %Hazard{name: "haz1", display_order: 2}
    @haz2 %Hazard{name: "haz2", display_order: 1}
    @scale1 %Scale{name: "scale1", impact: 1, display_order: 1}
    @scale2 %Scale{name: "scale2", impact: 2}
    @scale3 %Scale{name: "scale3", impact: 3, display_order: 2}
    @strat1 %Strategy{name: "strat1", description: "desc1", is_active: true, display_order: 1}
    @strat2 %Strategy{name: "strat2", description: "desc2", is_active: false, display_order: 2}

    def run_categories() do
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
    
    def run_hazards() do
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

    def run_scales() do
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

    def run_all() do
        cat1 = @cat1 |> Repo.insert!
        cat2 = @cat2 |> Repo.insert!
        haz1 = @haz1 |> Repo.insert!
        haz2 = @haz2 |> Repo.insert!
        scale1 = @scale1 |> Repo.insert!
        scale2 = @scale2 |> Repo.insert!

        strat1 = @strat1
        |> Map.merge(%{
            adaptation_categories: [cat1, cat2],
            coastal_hazards: [haz1, haz2],
            impact_scales: [scale1, scale2]
        })
        |> Repo.insert!

        strat2 = @strat2
        |> Map.merge(%{
            adaptation_categories: [cat1, cat2],
            coastal_hazards: [haz1, haz2],
            impact_scales: [scale1, scale2]
        })
        |> Repo.insert!

        {:ok, data: %{
            cat1: cat1,
            cat2: cat2,
            haz1: haz1,
            haz2: haz2,
            scale1: scale1,
            scale2: scale2,
            strat1: strat1,
            strat2: strat2
        }}
    end
end