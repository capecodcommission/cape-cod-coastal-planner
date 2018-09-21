defmodule ChipApi.Seeds do

    def run() do
        alias ChipApi.{Adaptation, Geospatial, Repo}
        alias Decimal, as: D

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
        # STRATEGY PLACEMENTS
        #
        
        developed = %Adaptation.Placement{
            name: "Developed"
        }
        |> Repo.insert!

        undeveloped = %Adaptation.Placement{
            name: "Undeveloped"
        }
        |> Repo.insert!

        coastal_dune = %Adaptation.Placement{
            name: "CoastalDune"
        }
        |> Repo.insert!

        salt_marsh = %Adaptation.Placement{
            name: "SaltMarsh"
        }
        |> Repo.insert!

        #
        # ADAPTATION BENEFITS
        #

        habitat = %Adaptation.Benefit{
            name: "Habitat",
            display_order: 0
        }
        |> Repo.insert!

        water_quality = %Adaptation.Benefit{
            name: "Water Quality",
            display_order: 1
        }
        |> Repo.insert!

        carbon_storage = %Adaptation.Benefit{
            name: "Carbon Storage",
            display_order: 2
        }
        |> Repo.insert!

        aesthetics = %Adaptation.Benefit{
            name: "Aesthetics",
            display_order: 3
        }
        |> Repo.insert!

        flood_management = %Adaptation.Benefit{
            name: "Flood Mgt.",
            display_order: 4
        }
        |> Repo.insert!

        recreation_tourism = %Adaptation.Benefit{
            name: "Recreation/Tourism",
            display_order: 5
        }
        |> Repo.insert!

        #
        # ADAPTATION STRATEGIES
        #

        _no_action = %Adaptation.Strategy{
            name: "No Action",
            description: "Take no action to address changes in the coast. Effects of erosion, SLR, and flooding will continue or intensify. Depending on conditions, coastal resources may not migrate naturally where steep topography or preexisting coastal erosion control structures are present. Structures or facilities may be threatened or undermined.",
            adaptation_categories: [retreat],
            coastal_hazards: [],
            impact_scales: [site, community, neighborhood, regional],
            strategy_placements: [developed, undeveloped, coastal_dune, salt_marsh],
            adaptation_benefits: [habitat, aesthetics, recreation_tourism],
            is_active: true
        }
        |> Repo.insert!
        
        _undevelopment = %Adaptation.Strategy{
            name: "Undevelopment",
            description: "Removing development from an existing location by land purchase, flood insurance buy-out programs, or other means.",
            adaptation_categories: [retreat],
            coastal_hazards: [erosion, storm_surge, sea_level_rise],
            impact_scales: [site],
            strategy_placements: [developed, undeveloped, coastal_dune, salt_marsh],
            is_active: true
        }
        |> Repo.insert!

        _managed_relocation = %Adaptation.Strategy{
            name: "Managed Relocation",
            description: "Gradually moving development and infrastructure away from the coastline and areas of projected loss due to flooding and sea level rise.",
            adaptation_categories: [retreat],
            coastal_hazards: [erosion, storm_surge, sea_level_rise],
            impact_scales: [site, neighborhood, community, regional],
            strategy_placements: [], # TODO Revist - ask Matt
            adaptation_benefits: [habitat, water_quality, carbon_storage, aesthetics, flood_management, recreation_tourism],
            currently_permittable: "Various local and state permits may be required.",
            adaptation_advantages: [
                %Adaptation.Advantage{name: "Spares existing development from the effects of erosion and flooding.", display_order: 0},
                %Adaptation.Advantage{name: "Protects future development from flooding.", display_order: 1},
                %Adaptation.Advantage{name: "Allows for the maintenance or restoration of intertidal habitat.", display_order: 2}
            ],
            adaptation_disadvantages: [
                %Adaptation.Disadvantage{name: "Cost of moving development.", display_order: 0},
                %Adaptation.Disadvantage{name: "Acquisition of land for new development.", display_order: 1},
                %Adaptation.Disadvantage{name: "Loss of coastal property values.", display_order: 2}
            ],
            is_active: true
        }
        |> Repo.insert!

        _transfer_of_development = %Adaptation.Strategy{
            name: "Transfer of Development Credit/Transferable Development Rights",
            description: "Land use mechanism that encourages the permanent removal of development rights in defined “sending” districts, and allows those rights to be transferred to defined “receiving” districts.",
            adaptation_categories: [retreat],
            coastal_hazards: [erosion, storm_surge, sea_level_rise],
            impact_scales: [community],
            strategy_placements: [], # TODO Revist - ask Matt
            adaptation_benefits: [habitat, water_quality, carbon_storage, aesthetics, flood_management, recreation_tourism],
            currently_permittable: "Local bylaws allowing for Transfer of Development Rights must be in place.",
            adaptation_advantages: [
                %Adaptation.Advantage{name: "Conserves undisturbed areas that may serve as habitat or flood buffers.", display_order: 0},
                %Adaptation.Advantage{name: "Prevents development in areas likely to become inundated or hazard areas.", display_order: 1},
                %Adaptation.Advantage{name: "Allows for the same development potential in a community, redirecting development to revitalize urban and mixed-use centers.", display_order: 2}
            ],
            adaptation_disadvantages: [
                %Adaptation.Disadvantage{name: "TDR may be difficult to set up and administer so it functions as intended.", display_order: 0},
                %Adaptation.Disadvantage{name: "May encourage the development of previously undeveloped inland lands.", display_order: 1},
                %Adaptation.Disadvantage{name: "Limits development along coastline where higher returns on investment are possible.", display_order: 2}
            ],
            is_active: true
        }
        |> Repo.insert!

        _open_space_protection = %Adaptation.Strategy{
            name: "Open Space Protection",
            description: "Including protection of existing wetland, drainage system, and buffer zone resources in planning will protect them from development impacts preserving them as a natural defense system.",
            adaptation_categories: [protect, retreat],
            coastal_hazards: [erosion, storm_surge, sea_level_rise],
            impact_scales: [site, neighborhood, community, regional],
            strategy_placements: [undeveloped],
            is_active: true
        }
        |> Repo.insert!

        _salt_marsh_restoration = %Adaptation.Strategy{
            name: "Salt Marsh Restoration",
            description: "Protecting, restoring, and creating salt marsh as a buffer to storm surges and sea level rise to provide natural flood protection.",
            adaptation_categories: [protect],
            coastal_hazards: [erosion, storm_surge, sea_level_rise],
            impact_scales: [site, neighborhood],
            strategy_placements: [developed, undeveloped, coastal_dune, salt_marsh],
            is_active: true
        }
        |> Repo.insert!

        _revetment = %Adaptation.Strategy{
            name: "Revetment",
            description: "Sloped piles of boulders constructed along eroding coastal banks designed to intercept wave energy and decrease erosion.",
            adaptation_categories: [protect],
            coastal_hazards: [erosion, storm_surge],
            impact_scales: [site, neighborhood],
            strategy_placements: [coastal_dune],
            adaptation_benefits: [habitat, flood_management],
            currently_permittable: "Various local, state, and federal permits required.",
            adaptation_advantages: [
                %Adaptation.Advantage{name: "Mitigates wave action.", display_order: 0},
                %Adaptation.Advantage{name: "Low maintenance.", display_order: 1},
                %Adaptation.Advantage{name: "Longterm lifespan.", display_order: 2},
                %Adaptation.Advantage{name: "Creates hard structure for non-mobile marine life.", display_order: 3}
            ],
            adaptation_disadvantages: [
                %Adaptation.Disadvantage{name: "Loss and fragmentation of intertidal habitat.", display_order: 0},
                %Adaptation.Disadvantage{name: "Erosion of adjacent unreinforced sites.", display_order: 1},
                %Adaptation.Disadvantage{name: "No high water protection.", display_order: 2},
                %Adaptation.Disadvantage{name: "Aesthetic impacts.", display_order: 3},
                %Adaptation.Disadvantage{name: "Reduces longshore sediment transport.", display_order: 4},
                %Adaptation.Disadvantage{name: "Can eliminate dry beach over time if beach nourishment is not required.", display_order: 5}
            ],
            is_active: true
        }
        |> Repo.insert!

        _seawalls = %Adaptation.Strategy{
            name: "Seawalls",
            description: "Structures built parallel to the shore with vertical or sloped walls (typically smooth) to reinforce the shoreline against forces of wave action and erosion.",
            adaptation_categories: [protect],
            coastal_hazards: [erosion],
            impact_scales: [site, neighborhood],
            strategy_placements: [coastal_dune],
            is_active: true
        }
        |> Repo.insert!

        _dune_creation = %Adaptation.Strategy{
            name: "Dune Restoration/Creation",
            description: "Restoring existing dunes or creating new dunes to protect the shoreline against erosion and flooding.",
            adaptation_categories: [protect],
            coastal_hazards: [erosion, storm_surge, sea_level_rise],
            impact_scales: [site, neighborhood],
            strategy_placements: [developed, undeveloped, coastal_dune],
            is_active: true
        }
        |> Repo.insert!

        _bank_stabilization_fiber_coir_roll = %Adaptation.Strategy{
            name: "Bank Stabilization: Fiber/Coir Roll",
            description: "Cylindrical rolls, 12-20 inches in diameter & 10-20 feet long, made of coir (coconut fiber) held together by a fiber mesh, covered with sand, and are planted with salt-tolerant vegetation with extensive root systems. These reinforced banks act as physical barriers to waves, tides, and currents. The rolls typically disintegrate over 5-7 years to allow plants time to grow their root systems to keep sand and soil in place.",
            adaptation_categories: [protect],
            coastal_hazards: [erosion, storm_surge],
            impact_scales: [site, neighborhood],
            strategy_placements: [coastal_dune],
            is_active: true
        }
        |> Repo.insert!

        _bank_stabilization_coir_envelopes = %Adaptation.Strategy{
            name: "Bank Stabilization: Coir Envelopes",
            description: "Envelopes are constructed of coir (coconut fiber) fabric and are filled with local sand. The envelopes are placed in terraces along the beach, are typically covered with sand, and may also be planted with native vegetation to hold sand together and absorb water.",
            adaptation_categories: [protect],
            coastal_hazards: [erosion, storm_surge],
            impact_scales: [site, neighborhood],
            strategy_placements: [coastal_dune],
            is_active: true
        }
        |> Repo.insert!

        _living_shoreline_vegetation = %Adaptation.Strategy{
            name: "Living Shoreline: Vegetation Only",
            description: "Shoreline stabilization techniques along estuarine coasts, bays, sheltered coastlines, and tributaries. A living shoreline has a footprint that is made up mostly of native material. It incorporates vegetation or other living, natural \"soft\" elements alone or in combination with some other type of harder shoreline structures (e.g. oyster reefs or rock sills) for added stability. Using vegetation alone is one approach. Roots hold soil in place to reduce erosion. Provides a buffer to upload areas and breaks small waves.",
            adaptation_categories: [protect],
            coastal_hazards: [erosion, storm_surge],
            impact_scales: [site, neighborhood],
            strategy_placements: [developed, undeveloped, coastal_dune],
            is_active: true
        }
        |> Repo.insert!

        _living_shoreline_vegetation_structural = %Adaptation.Strategy{
            name: "Living Shoreline: Combined Vegetation and Structural Measures",
            description: "Shoreline stabilization techniques along estuarine coasts, bays, sheltered coastlines, and tributaries. A living shoreline has a footprint that is made up mostly of native material. It incorporates vegetation or other living, natural \"soft\" elements alone or in combination with some other type of harder shoreline structures (e.g. oyster reefs or rock sills) for added stability. A combined approach integrates living components, such as plantings, with strategically placed structural elements, such as sills, or breakwaters.",
            adaptation_categories: [protect],
            coastal_hazards: [erosion, storm_surge],
            impact_scales: [site, neighborhood],
            strategy_placements: [developed, undeveloped, coastal_dune],
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
            strategy_placements: [developed, undeveloped, coastal_dune],
            is_active: true
        }
        |> Repo.insert!

        _beach_nourishment = %Adaptation.Strategy{
            name: "Beach Nourishment",
            description: "The process of adding sediment (sand) to an eroding beach to widen or elevate the beach to maintain or advance the shoreline seaward. Sediment can be sourced from inland mining, dredging from navigation channels, and/or offshore mining.",
            adaptation_categories: [protect],
            coastal_hazards: [erosion, storm_surge],
            impact_scales: [site, neighborhood],
            strategy_placements: [developed, undeveloped, coastal_dune],
            is_active: true
        }
        |> Repo.insert!

        #
        # LITTORAL CELLS
        #

        _sandy_neck = %Geospatial.LittoralCell{
            name: "Sandy Neck",
            min_x: -70.49519532,
            min_y: 41.72443529,
            max_x: -70.27194534,
            max_y: 41.77707184,
            length_miles: D.new("12.8821297"),
            imperv_percent: D.new("4.404603481"),
            critical_facilities_count: 1,
            coastal_structures_count: 52,
            working_harbor: false,
            public_buildings_count: 8,
            salt_marsh_acres: D.new("204.0055084"),
            eelgrass_acres: D.new("5.9798193"),
            coastal_dune_acres: D.new("650.0172119"),
            rare_species_acres: D.new("4021.1875"),
            public_beach_count: 7,
            recreation_open_space_acres: D.new("130.4343719"),
            town_ways_to_water: 1,
            national_seashore: false,
            total_assessed_value: D.new("461244800.00")
        }
        |> Repo.insert!

        _buttermilk_bay = %Geospatial.LittoralCell{
            name: "Buttermilk Bay",
            min_x: -70.63352723,
            min_y: 41.73653947,
            max_x: -70.60927811,
            max_y: 41.765290014,
            length_miles: D.new("4.9664421"),
            imperv_percent: D.new("25.71430588"),
            critical_facilities_count: 5,
            coastal_structures_count: 106,
            working_harbor: true,
            public_buildings_count: 218,
            salt_marsh_acres: D.new("34.2522774"),
            eelgrass_acres: D.new("171.8101501"),
            coastal_dune_acres: D.new("5.9395294"),
            rare_species_acres: D.new("657.7874146"),
            public_beach_count: 4,
            recreation_open_space_acres: D.new("55.6946297"),
            town_ways_to_water: 1,
            national_seashore: false,
            total_assessed_value: D.new("393422600.00")
        }
        |> Repo.insert!

        _mashnee = %Geospatial.LittoralCell{
            name: "Mashnee",
            min_x: -70.64053898,
            min_y: 41.71461278,
            max_x: -70.62087102,
            max_y: 41.73706887,
            length_miles: D.new("2.939918"),
            imperv_percent: D.new("13.06014061"),
            critical_facilities_count: 0,
            coastal_structures_count: 63,
            working_harbor: false,
            public_buildings_count: 21,
            salt_marsh_acres: D.new("20.3502502"),
            eelgrass_acres: D.new("179.1102753"),
            coastal_dune_acres: D.new("61.0107536"),
            rare_species_acres: D.new("476.4459839"),
            public_beach_count: 2,
            recreation_open_space_acres: D.new("20.6207943"),
            town_ways_to_water: 0,
            national_seashore: false,
            total_assessed_value: D.new("301794700.00")
        }
        |> Repo.insert!

        _monument_beach = %Geospatial.LittoralCell{
            name: "Monument Beach",
            min_x: -70.63728516,
            min_y: 41.70796773,
            max_x: -70.6149776,
            max_y: 41.73706887,
            length_miles: D.new("3.889698"),
            imperv_percent: D.new("11.41208649"),
            critical_facilities_count: 2,
            coastal_structures_count: 89,
            working_harbor: true,
            public_buildings_count: 8,
            salt_marsh_acres: D.new("26.915144"),
            eelgrass_acres: D.new("95.0147705"),
            coastal_dune_acres: D.new("63.1204758"),
            rare_species_acres: D.new("597.7488403"),
            public_beach_count: 1,
            recreation_open_space_acres: D.new("12.8510218"),
            town_ways_to_water: 1,
            national_seashore: false,
            total_assessed_value: D.new("290605160.00")
        }
        |> Repo.insert!

        _wings_neck = %Geospatial.LittoralCell{
            name: "Wings Neck",
            min_x: -70.663057,
            min_y: 41.6796427,
            max_x: -70.61667597,
            max_y: 41.70797868,
            length_miles: D.new("4.0165191"),
            imperv_percent: D.new("9.428860664"),
            critical_facilities_count: 0,
            coastal_structures_count: 113,
            working_harbor: false,
            public_buildings_count: 3,
            salt_marsh_acres: D.new("64.2526627"),
            eelgrass_acres: D.new("74.3793411"),
            coastal_dune_acres: D.new("5.8283544"),
            rare_species_acres: D.new("381.8328247"),
            public_beach_count: 2,
            recreation_open_space_acres: D.new("31.8369522"),
            town_ways_to_water: 2,
            national_seashore: false,
            total_assessed_value: D.new("323256020.00")
        }
        |> Repo.insert!
        
        _red_brook_harbor = %Geospatial.LittoralCell{
            name: "Red Brook Harbor",
            min_x: -70.6623887,
            min_y: 41.6611958,
            max_x: -70.63281991,
            max_y: 41.68116405,
            length_miles: D.new("3.7567761"),
            imperv_percent: D.new("4.952525139"),
            critical_facilities_count: 0,
            coastal_structures_count: 73,
            working_harbor: false,
            public_buildings_count: 1,
            salt_marsh_acres: D.new("9.7079134"),
            eelgrass_acres: D.new("271.3979797"),
            coastal_dune_acres: D.new("2.6752608"),
            rare_species_acres: D.new("486.3106384"),
            public_beach_count: 2,
            recreation_open_space_acres: D.new("0.0"),
            town_ways_to_water: 0,
            national_seashore: false,
            total_assessed_value: D.new("217658870.00")
        }
        |> Repo.insert!

        _megansett_harbor = %Geospatial.LittoralCell{
            name: "Megansett Harbor",
            min_x: -70.65483116,
            min_y: 41.63744685,
            max_x: -70.61986912,
            max_y: 41.66400311,
            length_miles: D.new("4.5419111"),
            imperv_percent: D.new("12.91113758"),
            critical_facilities_count: 4,
            coastal_structures_count: 191,
            working_harbor: true,
            public_buildings_count: 3,
            salt_marsh_acres: D.new("21.2656403"),
            eelgrass_acres: D.new("283.9780273"),
            coastal_dune_acres: D.new("24.9014893"),
            rare_species_acres: D.new("459.4194336"),
            public_beach_count: 3,
            recreation_open_space_acres: D.new("3.3487511"),
            town_ways_to_water: 1,
            national_seashore: false,
            total_assessed_value: D.new("683448500.00")
        }
        |> Repo.insert!

        _old_silver_beach = %Geospatial.LittoralCell{
            name: "Old Silver Beach",
            min_x: -70.65423194,
            min_y: 41.60672672,
            max_x: -70.63976768,
            max_y: 41.64190766,
            length_miles: D.new("3.843195"),
            imperv_percent: D.new("16.91975403"),
            critical_facilities_count: 2,
            coastal_structures_count: 109,
            working_harbor: false,
            public_buildings_count: 6,
            salt_marsh_acres: D.new("31.3422775"),
            eelgrass_acres: D.new("175.4341583"),
            coastal_dune_acres: D.new("30.8582382"),
            rare_species_acres: D.new("236.6368408"),
            public_beach_count: 11,
            recreation_open_space_acres: D.new("2.9746351"),
            town_ways_to_water: 0,
            national_seashore: false,
            total_assessed_value: D.new("635004300.00")
        }
        |> Repo.insert!

        _sippewissett = %Geospatial.LittoralCell{
            name: "Sippewissett",
            min_x: -70.66416133,
            min_y: 41.54130225,
            max_x: -70.64149517,
            max_y: 41.6069038,
            length_miles: D.new("5.3717442"),
            imperv_percent: D.new("8.564338684"),
            critical_facilities_count: 0,
            coastal_structures_count: 72,
            working_harbor: false,
            public_buildings_count: 0,
            salt_marsh_acres: D.new("95.0317993"),
            eelgrass_acres: D.new("431.8627625"),
            coastal_dune_acres: D.new("66.9046783"),
            rare_species_acres: D.new("737.499939"),
            public_beach_count: 9,
            recreation_open_space_acres: D.new("6.4433169"),
            town_ways_to_water: 0,
            national_seashore: false,
            total_assessed_value: D.new("582787000.00")
        }
        |> Repo.insert!

        _woods_hole = %Geospatial.LittoralCell{
            name: "Woods Hole",
            min_x: -70.68869066,
            min_y: 41.51665019,
            max_x: -70.6630743,
            max_y: 41.54181222,
            length_miles: D.new("4.9520388"),
            imperv_percent: D.new("10.31838799"),
            critical_facilities_count: 7,
            coastal_structures_count: 102,
            working_harbor: true,
            public_buildings_count: 110,
            salt_marsh_acres: D.new("3.9876704"),
            eelgrass_acres: D.new("284.7936707"),
            coastal_dune_acres: D.new("0.4507518"),
            rare_species_acres: D.new("825.6036987"),
            public_beach_count: 3,
            recreation_open_space_acres: D.new("22.3431664"),
            town_ways_to_water: 1,
            national_seashore: false,
            total_assessed_value: D.new("626611700.00")
        }
        |> Repo.insert!

        _nobska = %Geospatial.LittoralCell{
            name: "Nobska",
            min_x: -70.66831085,
            min_y: 41.51431148,
            max_x: -70.65519,
            max_y: 41.52329243,
            length_miles: D.new("1.395851"),
            imperv_percent: D.new("18.66693115"),
            critical_facilities_count: 6,
            coastal_structures_count: 43,
            working_harbor: true,
            public_buildings_count: 89,
            salt_marsh_acres: D.new("0.4663978"),
            eelgrass_acres: D.new("87.6272888"),
            coastal_dune_acres: D.new("3.2719717"),
            rare_species_acres: D.new("237.9641266"),
            public_beach_count: 1,
            recreation_open_space_acres: D.new("4.3100624"),
            town_ways_to_water: 0,
            national_seashore: false,
            total_assessed_value: D.new("251606300.00")
        }
        |> Repo.insert!

        _south_falmouth = %Geospatial.LittoralCell{
            name: "South Falmouth",
            min_x: -70.65551689,
            min_y: 41.51432919,
            max_x: -70.52806583,
            max_y: 41.55234115,
            length_miles: D.new("7.9527521"),
            imperv_percent: D.new("13.50438404"),
            critical_facilities_count: 3,
            coastal_structures_count: 185,
            working_harbor: true,
            public_buildings_count: 28,
            salt_marsh_acres: D.new("38.2330894"),
            eelgrass_acres: D.new("975.5437622"),
            coastal_dune_acres: D.new("67.3718033"),
            rare_species_acres: D.new("1746.2563477"),
            public_beach_count: 17,
            recreation_open_space_acres: D.new("175.8104095"),
            town_ways_to_water: 0,
            national_seashore: false,
            total_assessed_value: D.new("1025546449.00")
        }
        |> Repo.insert!

        _new_seabury = %Geospatial.LittoralCell{
            name: "New Seabury",
            min_x: -70.52807964,
            min_y: 41.54657161,
            max_x: -70.44974468,
            max_y: 41.5880774,
            length_miles: D.new("5.3732042"),
            imperv_percent: D.new("11.50544548"),
            critical_facilities_count: 0,
            coastal_structures_count: 39,
            working_harbor: false,
            public_buildings_count: 0,
            salt_marsh_acres: D.new("61.836483"),
            eelgrass_acres: D.new("19.7484436"),
            coastal_dune_acres: D.new("26.8142071"),
            rare_species_acres: D.new("1490.3686523"),
            public_beach_count: 5,
            recreation_open_space_acres: D.new("298.637207"),
            town_ways_to_water: 0,
            national_seashore: false,
            total_assessed_value: D.new("894116100.00")
        }
        |> Repo.insert!

        _cotuit = %Geospatial.LittoralCell{
            name: "Cotuit",
            min_x: -70.45280941,
            min_y: 41.58731796,
            max_x: -70.40093848,
            max_y: 41.60903925,
            length_miles: D.new("3.7948329"),
            imperv_percent: D.new("6.853813171"),
            critical_facilities_count: 0,
            coastal_structures_count: 89,
            working_harbor: true,
            public_buildings_count: 4,
            salt_marsh_acres: D.new("25.401474"),
            eelgrass_acres: D.new("54.628727"),
            coastal_dune_acres: D.new("89.3615646"),
            rare_species_acres: D.new("1101.5426025"),
            public_beach_count: 4,
            recreation_open_space_acres: D.new("0.8072858"),
            town_ways_to_water: 0,
            national_seashore: false,
            total_assessed_value: D.new("435699300.00")
        }
        |> Repo.insert!

        _wianno = %Geospatial.LittoralCell{
            name: "Wianno",
            min_x: -70.40095626,
            min_y: 41.6057665,
            max_x: -70.36438018,
            max_y: 41.6221806,
            length_miles: D.new("2.2582591"),
            imperv_percent: D.new("11.87512684"),
            critical_facilities_count: 0,
            coastal_structures_count: 104,
            working_harbor: false,
            public_buildings_count: 2,
            salt_marsh_acres: D.new("3.102915"),
            eelgrass_acres: D.new("322.4924316"),
            coastal_dune_acres: D.new("16.1339588"),
            rare_species_acres: D.new("551.7070923"),
            public_beach_count: 2,
            recreation_open_space_acres: D.new("33.4862099"),
            town_ways_to_water: 0,
            national_seashore: false,
            total_assessed_value: D.new("513900700.00")
        }
        |> Repo.insert!

        _centerville_harbor = %Geospatial.LittoralCell{
            name: "Centerville Harbor",
            min_x: -70.365511,
            min_y: 41.62175632,
            max_x: -70.31690959,
            max_y: 41.63630151,
            length_miles: D.new("3.4090099"),
            imperv_percent: D.new("11.96304893"),
            critical_facilities_count: 1,
            coastal_structures_count: 79,
            working_harbor: false,
            public_buildings_count: 4,
            salt_marsh_acres: D.new("99.109169"),
            eelgrass_acres: D.new("191.6327057"),
            coastal_dune_acres: D.new("39.8272591"),
            rare_species_acres: D.new("909.6130371"),
            public_beach_count: 7,
            recreation_open_space_acres: D.new("40.852684"),
            town_ways_to_water: 1,
            national_seashore: false,
            total_assessed_value: D.new("523927500.00")
        }
        |> Repo.insert!

        _lewis_bay = %Geospatial.LittoralCell{
            name: "Lewis Bay",
            min_x: -70.3172616,
            min_y: 41.60842778,
            max_x: -70.24010809,
            max_y: 41.65174441,
            length_miles: D.new("11.5430002"),
            imperv_percent: D.new("18.56052208"),
            critical_facilities_count: 38,
            coastal_structures_count: 294,
            working_harbor: true,
            public_buildings_count: 115,
            salt_marsh_acres: D.new("137.3874664"),
            eelgrass_acres: D.new("466.7622681"),
            coastal_dune_acres: D.new("106.2389297"),
            rare_species_acres: D.new("1913.0593262"),
            public_beach_count: 17,
            recreation_open_space_acres: D.new("131.2438965"),
            town_ways_to_water: 2,
            national_seashore: false,
            total_assessed_value: D.new("1428641000.00")
        }
        |> Repo.insert!

        _nantucket_sound = %Geospatial.LittoralCell{
            name: "Nantucket Sound",
            min_x: -70.26578859,
            min_y: 41.60844647,
            max_x: -69.98190808,
            max_y: 41.67233469,
            length_miles: D.new("17.3015995"),
            imperv_percent: D.new("15.66193962"),
            critical_facilities_count: 9,
            coastal_structures_count: 518,
            working_harbor: true,
            public_buildings_count: 70,
            salt_marsh_acres: D.new("380.8373108"),
            eelgrass_acres: D.new("2486.3562012"),
            coastal_dune_acres: D.new("340.8415222"),
            rare_species_acres: D.new("4085.7602539"),
            public_beach_count: 51,
            recreation_open_space_acres: D.new("490.1095581"),
            town_ways_to_water: 0,
            national_seashore: false,
            total_assessed_value: D.new("2537257400.00")
        }
        |> Repo.insert!

        _monomoy = %Geospatial.LittoralCell{
            name: "Monomoy",
            min_x: -70.01549706,
            min_y: 41.5394904,
            max_x: -69.94167893,
            max_y: 41.67242025,
            length_miles: D.new("20.9548302"),
            imperv_percent: D.new("0.722238481"),
            critical_facilities_count: 1,
            coastal_structures_count: 10,
            working_harbor: false,
            public_buildings_count: 5,
            salt_marsh_acres: D.new("105.3767395"),
            eelgrass_acres: D.new("560.2143555"),
            coastal_dune_acres: D.new("1051.571167"),
            rare_species_acres: D.new("6738.7255859"),
            public_beach_count: 2,
            recreation_open_space_acres: D.new("213.083374"),
            town_ways_to_water: 0,
            national_seashore: true,
            total_assessed_value: D.new("271926400.00")
        }
        |> Repo.insert!

        _chatham_harbor = %Geospatial.LittoralCell{
            name: "Chatham Harbor",
            min_x: -69.95152325,
            min_y: 41.6720345,
            max_x: -69.94433652,
            max_y: 41.70441754,
            length_miles: D.new("2.5425341"),
            imperv_percent: D.new("17.18111992"),
            critical_facilities_count: 2,
            coastal_structures_count: 33,
            working_harbor: true,
            public_buildings_count: 11,
            salt_marsh_acres: D.new("31.2736931"),
            eelgrass_acres: D.new("78.3087082"),
            coastal_dune_acres: D.new("24.9601288"),
            rare_species_acres: D.new("569.944397"),
            public_beach_count: 5,
            recreation_open_space_acres: D.new("21.3441048"),
            town_ways_to_water: 0,
            national_seashore: true,
            total_assessed_value: D.new("865465800.00")
        }
        |> Repo.insert!

        _bassing_harbor = %Geospatial.LittoralCell{
            name: "Bassing Harbor",
            min_x: -69.97397911,
            min_y: 41.70386807,
            max_x: -69.94462443,
            max_y: 41.7218528,
            length_miles: D.new("3.182462"),
            imperv_percent: D.new("9.980096817"),
            critical_facilities_count: 0,
            coastal_structures_count: 32,
            working_harbor: false,
            public_buildings_count: 4,
            salt_marsh_acres: D.new("34.5506363"),
            eelgrass_acres: D.new("361.5568237"),
            coastal_dune_acres: D.new("11.1119413"),
            rare_species_acres: D.new("619.3502197"),
            public_beach_count: 3,
            recreation_open_space_acres: D.new("37.4128647"),
            town_ways_to_water: 0,
            national_seashore: false,
            total_assessed_value: D.new("481869100.00")
        }
        |> Repo.insert!

        _wequassett = %Geospatial.LittoralCell{
            name: "Wequassett",
            min_x: -69.99657598,
            min_y: 41.71273071,
            max_x: -69.97359947,
            max_y: 41.73643113,
            length_miles: D.new("3.073679"),
            imperv_percent: D.new("11.93692398"),
            critical_facilities_count: 1,
            coastal_structures_count: 45,
            working_harbor: true,
            public_buildings_count: 8,
            salt_marsh_acres: D.new("22.9759789"),
            eelgrass_acres: D.new("71.4209671"),
            coastal_dune_acres: D.new("8.8877954"),
            rare_species_acres: D.new("674.5410156"),
            public_beach_count: 9,
            recreation_open_space_acres: D.new("152.7987518"),
            town_ways_to_water: 1,
            national_seashore: false,
            total_assessed_value: D.new("310864000.00")
        }
        |> Repo.insert!
        
        _little_pleasant_bay = %Geospatial.LittoralCell{
            name: "Little Pleasant Bay",
            min_x: -69.98772954,
            min_y: 41.70413691,
            max_x: -69.92762984,
            max_y: 41.77428196,
            length_miles: D.new("12.0422802"),
            imperv_percent: D.new("5.15602541"),
            critical_facilities_count: 1,
            coastal_structures_count: 66,
            working_harbor: true,
            public_buildings_count: 12,
            salt_marsh_acres: D.new("511.4660339"),
            eelgrass_acres: D.new("821.8519897"),
            coastal_dune_acres: D.new("261.1954651"),
            rare_species_acres: D.new("2852.9833984"),
            public_beach_count: 7,
            recreation_open_space_acres: D.new("470.2912292"),
            town_ways_to_water: 2,
            national_seashore: true,
            total_assessed_value: D.new("592666250.00")
        }
        |> Repo.insert!

        _nauset = %Geospatial.LittoralCell{
            name: "Nauset",
            min_x: -69.94028234,
            min_y: 41.70768725,
            max_x: -69.92634772,
            max_y: 41.82633149,
            length_miles: D.new("8.6657391"),
            imperv_percent: D.new("1.425156593"),
            critical_facilities_count: 0,
            coastal_structures_count: 0,
            working_harbor: false,
            public_buildings_count: 22,
            salt_marsh_acres: D.new("243.6255646"),
            eelgrass_acres: D.new("22.5867462"),
            coastal_dune_acres: D.new("487.9051819"),
            rare_species_acres: D.new("3070.623291"),
            public_beach_count: 1,
            recreation_open_space_acres: D.new("762.0858154"),
            town_ways_to_water: 0,
            national_seashore: true,
            total_assessed_value: D.new("130701200.00")
        }
        |> Repo.insert!

        _coast_guard_beach = %Geospatial.LittoralCell{
            name: "Coast Guard Beach",
            min_x: -69.95075294,
            min_y: 41.82622,
            max_x: -69.93818758,
            max_y: 41.86148426,
            length_miles: D.new("2.540206"),
            imperv_percent: D.new("2.573147058"),
            critical_facilities_count: 1,
            coastal_structures_count: 0,
            working_harbor: false,
            public_buildings_count: 9,
            salt_marsh_acres: D.new("23.6465569"),
            eelgrass_acres: D.new("0.0"),
            coastal_dune_acres: D.new("14.4632149"),
            rare_species_acres: D.new("1053.2125244"),
            public_beach_count: 3,
            recreation_open_space_acres: D.new("0.0"),
            town_ways_to_water: 0,
            national_seashore: true,
            total_assessed_value: D.new("30923200.00")
        }
        |> Repo.insert!

        _marconi = %Geospatial.LittoralCell{
            name: "Marconi",
            min_x: -69.96148559,
            min_y: 41.86138165,
            max_x: -69.94954175,
            max_y: 41.89357034,
            length_miles: D.new("2.2889249"),
            imperv_percent: D.new("2.897997141"),
            critical_facilities_count: 0,
            coastal_structures_count: 0,
            working_harbor: false,
            public_buildings_count: 6,
            salt_marsh_acres: D.new("0.0"),
            eelgrass_acres: D.new("0.0"),
            coastal_dune_acres: D.new("0.0"),
            rare_species_acres: D.new("967.5145874"),
            public_beach_count: 2,
            recreation_open_space_acres: D.new("171.526062"),
            town_ways_to_water: 0,
            national_seashore: true,
            total_assessed_value: D.new("17981400.00")
        }
        |> Repo.insert!

        _outer_cape = %Geospatial.LittoralCell{
            name: "Outer Cape",
            min_x: -70.24858201,
            min_y: 41.89346876,
            max_x: -69.9602872,
            max_y: 42.08343397,
            length_miles: D.new("28.6761799"),
            imperv_percent: D.new("1.655546427"),
            critical_facilities_count: 0,
            coastal_structures_count: 8,
            working_harbor: false,
            public_buildings_count: 75,
            salt_marsh_acres: D.new("118.0019379"),
            eelgrass_acres: D.new("12.9466887"),
            coastal_dune_acres: D.new("1095.5489502"),
            rare_species_acres: D.new("9952.5556641"),
            public_beach_count: 15,
            recreation_open_space_acres: D.new("3932.9230957"),
            town_ways_to_water: 0,
            national_seashore: true,
            total_assessed_value: D.new("171293000.00")
        }
        |> Repo.insert!

        _provincetown_harbor = %Geospatial.LittoralCell{
            name: "Provincetown Harbor",
            min_x: -70.19870082,
            min_y: 42.02392881,
            max_x: -70.16644116,
            max_y: 42.04655892,
            length_miles: D.new("3.480684"),
            imperv_percent: D.new("11.96743774"),
            critical_facilities_count: 4,
            coastal_structures_count: 50,
            working_harbor: true,
            public_buildings_count: 25,
            salt_marsh_acres: D.new("133.3305054"),
            eelgrass_acres: D.new("140.2750092"),
            coastal_dune_acres: D.new("53.2006798"),
            rare_species_acres: D.new("991.5595093"),
            public_beach_count: 8,
            recreation_open_space_acres: D.new("292.7267151"),
            town_ways_to_water: 0,
            national_seashore: true,
            total_assessed_value: D.new("726006200.00")
        }
        |> Repo.insert!

        _truro = %Geospatial.LittoralCell{
            name: "Truro",
            min_x: -70.18977157,
            min_y: 41.9681321,
            max_x: -70.07712532,
            max_y: 42.06217857,
            length_miles: D.new("10.7964802"),
            imperv_percent: D.new("17.23412132"),
            critical_facilities_count: 15,
            coastal_structures_count: 144,
            working_harbor: true,
            public_buildings_count: 79,
            salt_marsh_acres: D.new("39.6284142"),
            eelgrass_acres: D.new("1121.4608154"),
            coastal_dune_acres: D.new("103.8385391"),
            rare_species_acres: D.new("2721.8625488"),
            public_beach_count: 30,
            recreation_open_space_acres: D.new("168.9987946"),
            town_ways_to_water: 0,
            national_seashore: true,
            total_assessed_value: D.new("2369225100.00")
        }
        |> Repo.insert!

        _bound_brook = %Geospatial.LittoralCell{
            name: "Bound Brook",
            min_x: -70.07896201,
            min_y: 41.94333318,
            max_x: -70.076689,
            max_y: 41.968213,
            length_miles: D.new("1.72536"),
            imperv_percent: D.new("2.774612904"),
            critical_facilities_count: 0,
            coastal_structures_count: 0,
            working_harbor: false,
            public_buildings_count: 5,
            salt_marsh_acres: D.new("0.0"),
            eelgrass_acres: D.new("325.9089966"),
            coastal_dune_acres: D.new("47.3282356"),
            rare_species_acres: D.new("755.8833008"),
            public_beach_count: 2,
            recreation_open_space_acres: D.new("240.3492889"),
            town_ways_to_water: 0,
            national_seashore: true,
            total_assessed_value: D.new("70897100.00")
        }
        |> Repo.insert!

        _great_island = %Geospatial.LittoralCell{
            name: "Great Island",
            min_x: -70.07826461,
            min_y: 41.8838964,
            max_x: -70.06694975,
            max_y: 41.94342149,
            length_miles: D.new("4.1978979"),
            imperv_percent: D.new("8.03567028"),
            critical_facilities_count: 0,
            coastal_structures_count: 0,
            working_harbor: false,
            public_buildings_count: 0,
            salt_marsh_acres: D.new("106.9666061"),
            eelgrass_acres: D.new("425.5777283"),
            coastal_dune_acres: D.new("68.1362839"),
            rare_species_acres: D.new("1622.809082"),
            public_beach_count: 2,
            recreation_open_space_acres: D.new("489.5529175"),
            town_ways_to_water: 0,
            national_seashore: true,
            total_assessed_value: D.new("15374700.00")
        }
        |> Repo.insert!

        _wellfleet_harbor = %Geospatial.LittoralCell{
            name: "Wellfleet Harbor",
            min_x: -70.07076949,
            min_y: 41.88411699,
            max_x: -70.02296983,
            max_y: 41.93148949,
            length_miles: D.new("10.5048399"),
            imperv_percent: D.new("6.293058395"),
            critical_facilities_count: 4,
            coastal_structures_count: 97,
            working_harbor: true,
            public_buildings_count: 6,
            salt_marsh_acres: D.new("222.3549652"),
            eelgrass_acres: D.new("70.8523407"),
            coastal_dune_acres: D.new("70.2663345"),
            rare_species_acres: D.new("2528.1630859"),
            public_beach_count: 10,
            recreation_open_space_acres: D.new("624.2570801"),
            town_ways_to_water: 0,
            national_seashore: true,
            total_assessed_value: D.new("455847300.00")
        }
        |> Repo.insert!

        _blackfish_creek = %Geospatial.LittoralCell{
            name: "Blackfish Creek",
            min_x: -70.02552165,
            min_y: 41.89249817,
            max_x: -70.00587516,
            max_y: 41.9097969,
            length_miles: D.new("2.860405"),
            imperv_percent: D.new("4.120303631"),
            critical_facilities_count: 0,
            coastal_structures_count: 35,
            working_harbor: false,
            public_buildings_count: 0,
            salt_marsh_acres: D.new("177.3943939"),
            eelgrass_acres: D.new("0.0"),
            coastal_dune_acres: D.new("28.9642696"),
            rare_species_acres: D.new("922.3416748"),
            public_beach_count: 0,
            recreation_open_space_acres: D.new("0.6491886"),
            town_ways_to_water: 0,
            national_seashore: false,
            total_assessed_value: D.new("149123700.00")
        }
        |> Repo.insert!

        _cape_cod_bay = %Geospatial.LittoralCell{
            name: "Cape Cod Bay",
            min_x: -70.10876375,
            min_y: 41.76304249,
            max_x: -70.00142255,
            max_y: 41.89320727,
            length_miles: D.new("13.96208"),
            imperv_percent: D.new("10.03118896"),
            critical_facilities_count: 4,
            coastal_structures_count: 143,
            working_harbor: true,
            public_buildings_count: 96,
            salt_marsh_acres: D.new("608.8064575"),
            eelgrass_acres: D.new("189.9243622"),
            coastal_dune_acres: D.new("143.90625"),
            rare_species_acres: D.new("3427.4592285"),
            public_beach_count: 41,
            recreation_open_space_acres: D.new("201.6305389"),
            town_ways_to_water: 2,
            national_seashore: false,
            total_assessed_value: D.new("1542971500.00")
        }
        |> Repo.insert!

        _quivett = %Geospatial.LittoralCell{
            name: "Quivett",
            min_x: -70.18135437,
            min_y: 41.75132777,
            max_x: -70.10853291,
            max_y: 41.76420279,
            length_miles: D.new("4.1774969"),
            imperv_percent: D.new("8.187264442"),
            critical_facilities_count: 4,
            coastal_structures_count: 36,
            working_harbor: true,
            public_buildings_count: 3,
            salt_marsh_acres: D.new("89.2759476"),
            eelgrass_acres: D.new("9.3302622"),
            coastal_dune_acres: D.new("79.331604"),
            rare_species_acres: D.new("673.1985474"),
            public_beach_count: 8,
            recreation_open_space_acres: D.new("43.7184067"),
            town_ways_to_water: 0,
            national_seashore: false,
            total_assessed_value: D.new("446347420.00")
        }
        |> Repo.insert!

        _barnstable_harbor = %Geospatial.LittoralCell{
            name: "Barnstable Harbor",
            min_x: -70.35255989,
            min_y: 41.70837857,
            max_x: -70.18112468,
            max_y: 41.75302983,
            length_miles: D.new("16.4632301"),
            imperv_percent: D.new("5.641637325"),
            critical_facilities_count: 8,
            coastal_structures_count: 98,
            working_harbor: true,
            public_buildings_count: 27,
            salt_marsh_acres: D.new("1256.4754639"),
            eelgrass_acres: D.new("37.4771461"),
            coastal_dune_acres: D.new("319.9433594"),
            rare_species_acres: D.new("4614.3808594"),
            public_beach_count: 11,
            recreation_open_space_acres: D.new("87.6455841"),
            town_ways_to_water: 3,
            national_seashore: false,
            total_assessed_value: D.new("974675740.00")
        }
        |> Repo.insert!

        _sagamore = %Geospatial.LittoralCell{
            name: "Sagamore",
            min_x: -70.53777639,
            min_y: 41.77663144,
            max_x: -70.4932775,
            max_y: 41.8111471,
            length_miles: D.new("3.3053861"),
            imperv_percent: D.new("10.14210987"),
            critical_facilities_count: 0,
            coastal_structures_count: 33,
            working_harbor: false,
            public_buildings_count: 8,
            salt_marsh_acres: D.new("0.0"),
            eelgrass_acres: D.new("5.9798193"),
            coastal_dune_acres: D.new("58.2020454"),
            rare_species_acres: D.new("960.220459"),
            public_beach_count: 2,
            recreation_open_space_acres: D.new("138.4368439"),
            town_ways_to_water: 0,
            national_seashore: false,
            total_assessed_value: D.new("255135300.00")
        }
        |> Repo.insert!

        :ok
    end
end