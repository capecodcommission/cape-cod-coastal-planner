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
        protect = %Adaptation.Category{
            name: "Protect",
            display_order: 10
        }
        |> Repo.insert!

        accommodate = %Adaptation.Category{
            name: "Accommodate",
            display_order: 20
        }
        |> Repo.insert!

        retreat = %Adaptation.Category{
            name: "Retreat",
            display_order: 30
        }
        |> Repo.insert!


        #
        # ADAPTIVE STRATEGIES
        #

        _do_nothing = %Adaptation.Strategy{
            name: "Do Nothing",
            adaptation_categories: [],
            coastal_hazards: [],
            impact_scales: [],
            is_active: true
        }
        |> Repo.insert!
        
        _undevelopment = %Adaptation.Strategy{
            name: "Undevelopment",
            description: "Removing development from an existing location by land purchase, flood insurance buy-out programs, or other means.",
            adaptation_categories: [retreat],
            coastal_hazards: [erosion, storm_surge, sea_level_rise],
            impact_scales: [site],
            is_active: true
        }
        |> Repo.insert!

        _open_space_protection = %Adaptation.Strategy{
            name: "Open Space Protection",
            description: "Including protection of existing wetland, drainage system, and buffer zone resources in planning will protect them from development impacts preserving them as a natural defense system.",
            adaptation_categories: [protect, retreat],
            coastal_hazards: [erosion, storm_surge, sea_level_rise],
            impact_scales: [site, neighborhood, community, regional],
            is_active: true
        }
        |> Repo.insert!

        _salt_marsh_restoration = %Adaptation.Strategy{
            name: "Salt Marsh Restoration",
            description: "Protecting, restoring, and creating salt marsh as a buffer to storm surges and sea level rise to provide natural flood protection.",
            adaptation_categories: [protect],
            coastal_hazards: [erosion, storm_surge, sea_level_rise],
            impact_scales: [site, neighborhood],
            is_active: true
        }
        |> Repo.insert!

        _revetment = %Adaptation.Strategy{
            name: "Revetment",
            description: "Sloped wall of boulders constructed along eroding coastal banks designed to reflect wave energy and protect upland structures.",
            adaptation_categories: [protect],
            coastal_hazards: [erosion],
            impact_scales: [site, neighborhood],
            is_active: true
        }
        |> Repo.insert!

        _seawalls = %Adaptation.Strategy{
            name: "Seawalls",
            description: "Structures built parallel to the shore with vertical or sloped walls (typically smooth) to reinforce the shoreline against forces of wave action and erosion.",
            adaptation_categories: [protect],
            coastal_hazards: [erosion],
            impact_scales: [site, neighborhood],
            is_active: true
        }
        |> Repo.insert!

        _dune_creation = %Adaptation.Strategy{
            name: "Dune Restoration/Creation",
            description: "Restoring existing dunes or creating new dunes to protect the shoreline against erosion and flooding.",
            adaptation_categories: [protect],
            coastal_hazards: [erosion, storm_surge, sea_level_rise],
            impact_scales: [site, neighborhood],
            is_active: true
        }
        |> Repo.insert!

        _bank_stabilization_fiber_coir_roll = %Adaptation.Strategy{
            name: "Bank Stabilization: Fiber/Coir Roll",
            description: "Cylindrical rolls, 12-20 inches in diameter & 10-20 feet long, made of coir (coconut fiber) held together by a fiber mesh, covered with sand, and are planted with salt-tolerant vegetation with extensive root systems. These reinforced banks act as physical barriers to waves, tides, and currents. The rolls typically disintegrate over 5-7 years to allow plants time to grow their root systems to keep sand and soil in place.",
            adaptation_categories: [protect],
            coastal_hazards: [erosion, storm_surge],
            impact_scales: [site, neighborhood],
            is_active: true
        }
        |> Repo.insert!

        _bank_stabilization_coir_envelopes = %Adaptation.Strategy{
            name: "Bank Stabilization: Coir Envelopes",
            description: "Envelopes are constructed of coir (coconut fiber) fabric and are filled with local sand. The envelopes are placed in terraces along the beach, are typically covered with sand, and may also be planted with native vegetation to hold sand together and absorb water.",
            adaptation_categories: [protect],
            coastal_hazards: [erosion, storm_surge],
            impact_scales: [site, neighborhood],
            is_active: true
        }
        |> Repo.insert!

        _living_shoreline_vegetation = %Adaptation.Strategy{
            name: "Living Shoreline: Vegetation Only",
            description: "Shoreline stabilization techniques along estuarine coasts, bays, sheltered coastlines, and tributaries. A living shoreline has a footprint that is made up mostly of native material. It incorporates vegetation or other living, natural \"soft\" elements alone or in combination with some other type of harder shoreline structures (e.g. oyster reefs or rock sills) for added stability. Using vegetation alone is one approach. Roots hold soil in place to reduce erosion. Provides a buffer to upload areas and breaks small waves.",
            adaptation_categories: [protect],
            coastal_hazards: [erosion, storm_surge],
            impact_scales: [site, neighborhood],
            is_active: true
        }
        |> Repo.insert!

        _living_shoreline_vegetation_structural = %Adaptation.Strategy{
            name: "Living Shoreline: Combined Vegetation and Structural Measures",
            description: "Shoreline stabilization techniques along estuarine coasts, bays, sheltered coastlines, and tributaries. A living shoreline has a footprint that is made up mostly of native material. It incorporates vegetation or other living, natural \"soft\" elements alone or in combination with some other type of harder shoreline structures (e.g. oyster reefs or rock sills) for added stability. A combined approach integrates living components, such as plantings, with strategically placed structural elements, such as sills, or breakwaters.",
            adaptation_categories: [protect],
            coastal_hazards: [erosion, storm_surge],
            impact_scales: [site, neighborhood],
            is_active: true
        }
        |> Repo.insert!

        _living_shoreline_breakwater_oyster = %Adaptation.Strategy{
            name: "Living Shoreline: Living Breakwater/Oyster Reefs",
            description: "Shoreline stabilization techniques along estuarine coasts, bays, sheltered coastlines, and tributaries. A living shoreline has a footprint that is made
            up mostly of native material. It incorporates vegetation or other living, natural \"soft\" elements alone or in combination with some other type of harder shoreline structures (e.g. oyster reefs or rock sills) for added stability. Restoring or creating oyster reefs or reef balls to serve as natural breakwaters, attenuate wave energy, and slow inland water transfer.",
            adaptation_categories: [protect],
            coastal_hazards: [erosion, storm_surge],
            impact_scales: [site, neighborhood],
            is_active: true
        }
        |> Repo.insert!

        _beach_nourishment = %Adaptation.Strategy{
            name: "Beach Nourishment",
            description: "The process of adding sediment (sand) to an eroding beach to widen or elevate the beach to maintain or advance the shoreline seaward. Sediment can be sourced from inland mining, dredging from navigation channels, and/or offshore mining.",
            adaptation_categories: [protect],
            coastal_hazards: [erosion, storm_surge],
            impact_scales: [site, neighborhood],
            is_active: true
        }
        |> Repo.insert!

        :ok
    end
end