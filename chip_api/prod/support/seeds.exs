defmodule ChipApi.Prod.Seeds do
    def run() do
        alias ChipApi.{Adaptation, Geospatial, Repo}

        # #
        # # SCALES OF IMPACT
        # #
        
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

        #
        # LITTORAL CELLS
        #

        _sandy_neck = %Geospatial.LittoralCell{
            name: "Sandy Neck",
            minX: -70.49519532,
            minY: 41.72443529,
            maxX: -70.27194534,
            maxY: 41.77707184
        }
        |> Repo.insert!

        _buttermilk_bay = %Geospatial.LittoralCell{
            name: "Buttermilk Bay",
            minX: -70.63352723,
            minY: 41.73653947,
            maxX: -70.60927811,
            maxY: 41.765290014
        }
        |> Repo.insert!

        _mashnee = %Geospatial.LittoralCell{
            name: "Mashnee",
            minX: -70.64053898,
            minY: 41.71461278,
            maxX: -70.62087102,
            maxY: 41.73706887
        }
        |> Repo.insert!

        _monument_beach = %Geospatial.LittoralCell{
            name: "Monument Beach",
            minX: -70.63728516,
            minY: 41.70796773,
            maxX: -70.6149776,
            maxY: 41.73706887
        }
        |> Repo.insert!

        _wings_neck = %Geospatial.LittoralCell{
            name: "Wings Neck",
            minX: -70.663057,
            minY: 41.6796427,
            maxX: -70.61667597,
            maxY: 41.70797868
        }
        |> Repo.insert!
        
        _red_brook_harbor = %Geospatial.LittoralCell{
            name: "Red Brook Harbor",
            minX: -70.6623887,
            minY: 41.6611958,
            maxX: -70.63281991,
            maxY: 41.68116405
        }
        |> Repo.insert!

        _megansett_harbor = %Geospatial.LittoralCell{
            name: "Megansett Harbor",
            minX: -70.65483116,
            minY: 41.63744685,
            maxX: -70.61986912,
            maxY: 41.66400311
        }
        |> Repo.insert!

        _old_silver_beach = %Geospatial.LittoralCell{
            name: "Old Silver Beach",
            minX: -70.65423194,
            minY: 41.60672672,
            maxX: -70.63976768,
            maxY: 41.64190766
        }
        |> Repo.insert!

        _sippewissett = %Geospatial.LittoralCell{
            name: "Sippewissett",
            minX: -70.66416133,
            minY: 41.54130225,
            maxX: -70.64149517,
            maxY: 41.6069038
        }
        |> Repo.insert!

        _woods_hole = %Geospatial.LittoralCell{
            name: "Woods Hole",
            minX: -70.68869066,
            minY: 41.51665019,
            maxX: -70.6630743,
            maxY: 41.54181222
        }
        |> Repo.insert!

        _nobska = %Geospatial.LittoralCell{
            name: "Nobska",
            minX: -70.66831085,
            minY: 41.51431148,
            maxX: -70.65519,
            maxY: 41.52329243
        }
        |> Repo.insert!

        _new_seabury = %Geospatial.LittoralCell{
            name: "New Seabury",
            minX: -70.52807964,
            minY: 41.54657161,
            maxX: -70.44974468,
            maxY: 41.5880774
        }
        |> Repo.insert!

        _cotuit = %Geospatial.LittoralCell{
            name: "Cotuit",
            minX: -70.45280941,
            minY: 41.58731796,
            maxX: -70.40093848,
            maxY: 41.60903925
        }
        |> Repo.insert!

        _wianno = %Geospatial.LittoralCell{
            name: "Wianno",
            minX: -70.40095626,
            minY: 41.6057665,
            maxX: -70.36438018,
            maxY: 41.6221806
        }
        |> Repo.insert!

        _centerville_harbor = %Geospatial.LittoralCell{
            name: "Centerville Harbor",
            minX: -70.365511,
            minY: 41.62175632,
            maxX: -70.31690959,
            maxY: 41.63630151
        }
        |> Repo.insert!

        _lewis_bay = %Geospatial.LittoralCell{
            name: "Lewis Bay",
            minX: -70.3172616,
            minY: 41.60842778,
            maxX: -70.24010809,
            maxY: 41.65174441
        }
        |> Repo.insert!

        _nantucket_sound = %Geospatial.LittoralCell{
            name: "Nantucket Sound",
            minX: -70.26578859,
            minY: 41.60844647,
            maxX: -69.98190808,
            maxY: 41.67233469
        }
        |> Repo.insert!

        _monomoy = %Geospatial.LittoralCell{
            name: "Monomoy",
            minX: -70.01549706,
            minY: 41.5394904,
            maxX: -69.94167893,
            maxY: 41.67242025
        }
        |> Repo.insert!

        _chatham_harbor = %Geospatial.LittoralCell{
            name: "Chatham Harbor",
            minX: -69.95152325,
            minY: 41.6720345,
            maxX: -69.94433652,
            maxY: 41.70441754
        }
        |> Repo.insert!

        _bassing_harbor = %Geospatial.LittoralCell{
            name: "Bassing Harbor",
            minX: -69.97397911,
            minY: 41.70386807,
            maxX: -69.94462443,
            maxY: 41.7218528
        }
        |> Repo.insert!

        _wequassett = %Geospatial.LittoralCell{
            name: "Wequassett",
            minX: -69.99657598,
            minY: 41.71273071,
            maxX: -69.97359947,
            maxY: 41.73643113
        }
        |> Repo.insert!
        
        _little_pleasant_bay = %Geospatial.LittoralCell{
            name: "Little Pleasant Bay",
            minX: -69.98772954,
            minY: 41.70413691,
            maxX: -69.92762984,
            maxY: 41.77428196
        }
        |> Repo.insert!

        _nauset = %Geospatial.LittoralCell{
            name: "Nauset",
            minX: -69.94028234,
            minY: 41.70768725,
            maxX: -69.92634772,
            maxY: 41.82633149
        }
        |> Repo.insert!

        _coast_guard_beach = %Geospatial.LittoralCell{
            name: "Coast Guard Beach",
            minX: -69.95075294,
            minY: 41.82622,
            maxX: -69.93818758,
            maxY: 41.86148426
        }
        |> Repo.insert!

        _marconi = %Geospatial.LittoralCell{
            name: "Marconi",
            minX: -69.96148559,
            minY: 41.86138165,
            maxX: -69.94954175,
            maxY: 41.89357034
        }
        |> Repo.insert!

        _outer_cape = %Geospatial.LittoralCell{
            name: "Outer Cape",
            minX: -70.24858201,
            minY: 41.89346876,
            maxX: -69.9602872,
            maxY: 42.08343397
        }
        |> Repo.insert!

        _provincetown_harbor = %Geospatial.LittoralCell{
            name: "Provincetown Harbor",
            minX: -70.19870082,
            minY: 42.02392881,
            maxX: -70.16644116,
            maxY: 42.04655892
        }
        |> Repo.insert!

        _truro = %Geospatial.LittoralCell{
            name: "Truro",
            minX: -70.18977157,
            minY: 41.9681321,
            maxX: -70.07712532,
            maxY: 42.06217857
        }
        |> Repo.insert!

        _bound_brook = %Geospatial.LittoralCell{
            name: "Bound Brook",
            minX: -70.07896201,
            minY: 41.94333318,
            maxX: -70.076689,
            maxY: 41.968213
        }
        |> Repo.insert!

        _great_island = %Geospatial.LittoralCell{
            name: "Great Island",
            minX: -70.07826461,
            minY: 41.8838964,
            maxX: -70.06694975,
            maxY: 41.94342149
        }
        |> Repo.insert!

        _wellfleet_harbor = %Geospatial.LittoralCell{
            name: "Wellfleet Harbor",
            minX: -70.07076949,
            minY: 41.88411699,
            maxX: -70.02296983,
            maxY: 41.93148949
        }
        |> Repo.insert!

        _blackfish_creek = %Geospatial.LittoralCell{
            name: "Blackfish Creek",
            minX: -70.02552165,
            minY: 41.89249817,
            maxX: -70.00587516,
            maxY: 41.9097969
        }
        |> Repo.insert!

        _cape_cod_bay = %Geospatial.LittoralCell{
            name: "Cape Cod Bay",
            minX: -70.10876375,
            minY: 41.76304249,
            maxX: -70.00142255,
            maxY: 41.89320727
        }
        |> Repo.insert!

        _quivett = %Geospatial.LittoralCell{
            name: "Quivett",
            minX: -70.18135437,
            minY: 41.75132777,
            maxX: -70.10853291,
            maxY: 41.76420279
        }
        |> Repo.insert!

        _barnstable_harbor = %Geospatial.LittoralCell{
            name: "Barnstable Harbor",
            minX: -70.35255989,
            minY: 41.70837857,
            maxX: -70.18112468,
            maxY: 41.75302983
        }
        |> Repo.insert!

        _sagamore = %Geospatial.LittoralCell{
            name: "Sagamore",
            minX: -70.53777639,
            minY: 41.77663144,
            maxX: -70.4932775,
            maxY: 41.8111471
        }
        |> Repo.insert!

        :ok
    end
end

ChipApi.Prod.Seeds.run()