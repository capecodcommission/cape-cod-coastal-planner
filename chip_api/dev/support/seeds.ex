defmodule ChipApi.Seeds do

    def run() do
        alias ChipApi.{Adaptation, Repo}

        #
        # SCALES OF IMPACT
        #
        
        site = %Adaptation.Scale{name: "Site", impact: 1}
        |> Repo.insert!

        neighborhood = %Adaptation.Scale{name: "Neighborhood", impact: 2}
        |> Repo.insert!

        community = %Adaptation.Scale{name: "Community", impact: 3}
        |> Repo.insert!

        regional = %Adaptation.Scale{name: "Regional", impact: 4}
        |> Repo.insert!

        #
        # HAZARD TYPES
        #

        erosion = %Adaptation.Hazard{name: "Erosion"}
        |> Repo.insert!

        storm_surge = %Adaptation.Hazard{name: "Storm Surge"}
        |> Repo.insert!

        sea_level_rise = %Adaptation.Hazard{name: "Sea Level Rise"}
        |> Repo.insert!

        #
        # ADAPTATION CATEGORIES
        #
        protect = %Adaptation.Category{name: "Protect"}
        |> Repo.insert!

        accommodate = %Adaptation.Category{name: "Accommodate"}
        |> Repo.insert!

        retreat = %Adaptation.Category{name: "Retreat"}
        |> Repo.insert!


        #
        # ADAPTIVE STRATEGIES
        #

        do_nothing = %Adaptation.Strategy{
            name: "Do Nothing",
            adaptation_categories: [],
            coastal_hazards: [],
            impact_scales: []
        }
        |> Repo.insert!
        
        undevelopment = %Adaptation.Strategy{
            name: "Undevelopment",
            description: """
            Removing development from an existing location by land purchase,
            flood insurance buy-out programs, or other means.
            """,
            adaptation_categories: [retreat],
            coastal_hazards: [erosion, storm_surge, sea_level_rise],
            impact_scales: [site]
        }
        |> Repo.insert!

        open_space_protection = %Adaptation.Strategy{
            name: "Open Space Protection",
            description: """
            Including protection of existing wetland, drainage system, and buffer
            zone resources in planning will protect them from development impacts
            preserving them as a natural defense system.
            """,
            adaptation_categories: [protect, retreat],
            coastal_hazards: [erosion, storm_surge, sea_level_rise],
            impact_scales: [site, neighborhood, community, regional]
        }
        |> Repo.insert!

        salt_marsh_restoration = %Adaptation.Strategy{
            name: "Salt Marsh Restoration",
            description: """
            Protecting, restoring, and creating salt marsh as a buffer to storm
            surges and sea level rise to provide natural flood protection.
            """,
            adaptation_categories: [protect],
            coastal_hazards: [erosion, storm, sea_level_rise],
            impact_scales: [site, neighborhood]
        }
        |> Repo.insert!

        revetment = %Adaptation.Strategy{
            name: "Revetment",
            description: """
            Sloped wall of boulders constructed along eroding coastal banks designed
            to reflect wave energy and protect upland structures.
            """,
            adaptation_categories: [protect],
            coastal_hazards: [erosion],
            impact_scales: [site, neighborhood]
        }
        |> Repo.insert!

        seawalls = %Adaptation.Strategy{
            name: "Seawalls",
            description: """
            Structures built parallel to the shore with vertical or sloped walls
            (typically smooth) to reinforce the shoreline against forces of wave
            action and erosion.
            """,
            adaptation_categories: [protect],
            coastal_hazards: [erosion],
            impact_scales: [site, neighborhood]
        }
        |> Repo.insert!

        dune_creation = %Adaptation.Strategy{
            name: "Dune Restoration/Creation",
            description: """
            Restoring existing dunes or creating new dunes to protect the shoreline
            against erosion and flooding.
            """,
            adaptation_categories: [protect],
            coastal_hazards: [erosion, storm_surge, sea_level_rise],
            impact_scales: [site, neighborhood]
        }
        |> Repo.insert!

        bank_stabilization_fiber_coir_roll = %Adaptation.Strategy{
            name: "Bank Stabilization: Fiber/Coir Roll",
            description: """
            Cylindrical rolls, 12-20 inches in diameter & 10-20 feet long, made of coir
            (coconut fiber) held together by a fiber mesh, covered with sand, and are
            planted with salt-tolerant vegetation with extensive root systems. These
            reinforced banks act as physical barriers to waves, tides, and currents.
            The rolls typically disintegrate over 5-7 years to allow plants time to
            grow their root systems to keep sand and soil in place.
            """,
            adaptation_categories: [protect],
            coastal_hazards: [erosion, storm_surge],
            impact_scales: [site, neighborhood]
        }
        |> Repo.insert!

        bank_stabilization_coir_envelopes = %Adaptation.Strategy{
            name: "Bank Stabilization: Coir Envelopes",
            description: """
            Envelopes are constructed of coir (coconut fiber) fabric and are filled
            with local sand. The envelopes are placed in terraces along the beach, are
            typically covered with sand, and may also be planted with native vegetation
            to hold sand together and absorb water.
            """,
            adaptation_categories: [protect],
            coastal_hazards: [erosion, storm_surge],
            impact_scales: [site, neighborhood]
        }
        |> Repo.insert!

        # living_shoreline = %Adaptation.Strategy{
        #     name: "Do Nothing",
        #     adaptation_categories: [],
        #     coastal_hazards: [],
        #     impact_scales: []
        # }
        # |> Repo.insert!

    end
end