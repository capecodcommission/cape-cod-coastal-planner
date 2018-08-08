--
-- PostgreSQL database dump
--

-- Dumped from database version 10.4
-- Dumped by pg_dump version 10.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: adaptation_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.adaptation_categories (id, name, description, inserted_at, updated_at, display_order) VALUES (1, 'Protect', NULL, '2018-08-08 17:57:15.338', '2018-08-08 17:57:15.338', 10);
INSERT INTO public.adaptation_categories (id, name, description, inserted_at, updated_at, display_order) VALUES (2, 'Accommodate', NULL, '2018-08-08 17:57:15.346', '2018-08-08 17:57:15.346', 20);
INSERT INTO public.adaptation_categories (id, name, description, inserted_at, updated_at, display_order) VALUES (3, 'Retreat', NULL, '2018-08-08 17:57:15.356', '2018-08-08 17:57:15.356', 30);


--
-- Data for Name: adaptation_strategies; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (1, 'Do Nothing', NULL, '2018-08-08 17:57:15.365', '2018-08-08 17:57:15.365', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (2, 'Undevelopment', 'Removing development from an existing location by land purchase, flood insurance buy-out programs, or other means.', '2018-08-08 17:57:15.368', '2018-08-08 17:57:15.368', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (3, 'Open Space Protection', 'Including protection of existing wetland, drainage system, and buffer zone resources in planning will protect them from development impacts preserving them as a natural defense system.', '2018-08-08 17:57:15.446', '2018-08-08 17:57:15.446', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (4, 'Salt Marsh Restoration', 'Protecting, restoring, and creating salt marsh as a buffer to storm surges and sea level rise to provide natural flood protection.', '2018-08-08 17:57:15.464', '2018-08-08 17:57:15.464', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (5, 'Revetment', 'Sloped wall of boulders constructed along eroding coastal banks designed to reflect wave energy and protect upland structures.', '2018-08-08 17:57:15.474', '2018-08-08 17:57:15.474', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (6, 'Seawalls', 'Structures built parallel to the shore with vertical or sloped walls (typically smooth) to reinforce the shoreline against forces of wave action and erosion.', '2018-08-08 17:57:15.482', '2018-08-08 17:57:15.482', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (7, 'Dune Restoration/Creation', 'Restoring existing dunes or creating new dunes to protect the shoreline against erosion and flooding.', '2018-08-08 17:57:15.492', '2018-08-08 17:57:15.492', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (8, 'Bank Stabilization: Fiber/Coir Roll', 'Cylindrical rolls, 12-20 inches in diameter & 10-20 feet long, made of coir (coconut fiber) held together by a fiber mesh, covered with sand, and are planted with salt-tolerant vegetation with extensive root systems. These reinforced banks act as physical barriers to waves, tides, and currents. The rolls typically disintegrate over 5-7 years to allow plants time to grow their root systems to keep sand and soil in place.', '2018-08-08 17:57:15.504', '2018-08-08 17:57:15.504', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (9, 'Bank Stabilization: Coir Envelopes', 'Envelopes are constructed of coir (coconut fiber) fabric and are filled with local sand. The envelopes are placed in terraces along the beach, are typically covered with sand, and may also be planted with native vegetation to hold sand together and absorb water.', '2018-08-08 17:57:15.514', '2018-08-08 17:57:15.514', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (10, 'Living Shoreline: Vegetation Only', 'Shoreline stabilization techniques along estuarine coasts, bays, sheltered coastlines, and tributaries. A living shoreline has a footprint that is made up mostly of native material. It incorporates vegetation or other living, natural "soft" elements alone or in combination with some other type of harder shoreline structures (e.g. oyster reefs or rock sills) for added stability. Using vegetation alone is one approach. Roots hold soil in place to reduce erosion. Provides a buffer to upload areas and breaks small waves.', '2018-08-08 17:57:15.523', '2018-08-08 17:57:15.523', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (11, 'Living Shoreline: Combined Vegetation and Structural Measures', 'Shoreline stabilization techniques along estuarine coasts, bays, sheltered coastlines, and tributaries. A living shoreline has a footprint that is made up mostly of native material. It incorporates vegetation or other living, natural "soft" elements alone or in combination with some other type of harder shoreline structures (e.g. oyster reefs or rock sills) for added stability. A combined approach integrates living components, such as plantings, with strategically placed structural elements, such as sills, or breakwaters.', '2018-08-08 17:57:15.533', '2018-08-08 17:57:15.533', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (12, 'Living Shoreline: Living Breakwater/Oyster Reefs', 'Shoreline stabilization techniques along estuarine coasts, bays, sheltered coastlines, and tributaries. A living shoreline has a footprint that is made
            up mostly of native material. It incorporates vegetation or other living, natural "soft" elements alone or in combination with some other type of harder shoreline structures (e.g. oyster reefs or rock sills) for added stability. Restoring or creating oyster reefs or reef balls to serve as natural breakwaters, attenuate wave energy, and slow inland water transfer.', '2018-08-08 17:57:15.543', '2018-08-08 17:57:15.543', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (13, 'Beach Nourishment', 'The process of adding sediment (sand) to an eroding beach to widen or elevate the beach to maintain or advance the shoreline seaward. Sediment can be sourced from inland mining, dredging from navigation channels, and/or offshore mining.', '2018-08-08 17:57:15.55', '2018-08-08 17:57:15.55', NULL, true);


--
-- Data for Name: coastal_hazards; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.coastal_hazards (id, name, description, inserted_at, updated_at, display_order) VALUES (1, 'Erosion', NULL, '2018-08-08 17:57:15.311', '2018-08-08 17:57:15.311', NULL);
INSERT INTO public.coastal_hazards (id, name, description, inserted_at, updated_at, display_order) VALUES (2, 'Storm Surge', NULL, '2018-08-08 17:57:15.319', '2018-08-08 17:57:15.319', NULL);
INSERT INTO public.coastal_hazards (id, name, description, inserted_at, updated_at, display_order) VALUES (3, 'Sea Level Rise', NULL, '2018-08-08 17:57:15.33', '2018-08-08 17:57:15.33', NULL);


--
-- Data for Name: impact_scales; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.impact_scales (id, name, description, impact, inserted_at, updated_at, display_order) VALUES (1, 'Site', NULL, 1, '2018-08-08 17:57:15.225', '2018-08-08 17:57:15.225', NULL);
INSERT INTO public.impact_scales (id, name, description, impact, inserted_at, updated_at, display_order) VALUES (2, 'Neighborhood', NULL, 2, '2018-08-08 17:57:15.283', '2018-08-08 17:57:15.283', NULL);
INSERT INTO public.impact_scales (id, name, description, impact, inserted_at, updated_at, display_order) VALUES (3, 'Community', NULL, 3, '2018-08-08 17:57:15.294', '2018-08-08 17:57:15.294', NULL);
INSERT INTO public.impact_scales (id, name, description, impact, inserted_at, updated_at, display_order) VALUES (4, 'Regional', NULL, 4, '2018-08-08 17:57:15.303', '2018-08-08 17:57:15.303', NULL);


--
-- Data for Name: littoral_cells; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (1, 'Sandy Neck', -70.495195319999993, 41.724435290000002, -70.271945340000002, 41.777071839999998, '2018-08-08 17:57:15.556', '2018-08-08 17:57:15.556', 1, 52, false, 8, 204.0055084, 5.9798193, 7, 130.4343719, 1, 461244800.00, 12.8821297, 4.404603481);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (2, 'Buttermilk Bay', -70.633527229999999, 41.736539469999997, -70.609278110000005, 41.765290014000001, '2018-08-08 17:57:15.576', '2018-08-08 17:57:15.576', 5, 106, true, 218, 34.2522774, 171.8101501, 4, 55.6946297, 1, 393422600.00, 4.9664421, 25.71430588);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (3, 'Mashnee', -70.640538980000002, 41.714612780000003, -70.620871019999996, 41.737068870000002, '2018-08-08 17:57:15.579', '2018-08-08 17:57:15.579', 0, 63, false, 21, 20.3502502, 179.1102753, 2, 20.6207943, 0, 301794700.00, 2.939918, 13.06014061);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (4, 'Monument Beach', -70.637285160000005, 41.70796773, -70.614977600000003, 41.737068870000002, '2018-08-08 17:57:15.581', '2018-08-08 17:57:15.581', 2, 89, true, 8, 26.915144, 95.0147705, 1, 12.8510218, 1, 290605160.00, 3.889698, 11.41208649);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (5, 'Wings Neck', -70.663056999999995, 41.679642700000002, -70.616675970000003, 41.707978679999997, '2018-08-08 17:57:15.583', '2018-08-08 17:57:15.583', 0, 113, false, 3, 64.2526627, 74.3793411, 2, 31.8369522, 2, 323256020.00, 4.0165191, 9.428860664);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (6, 'Red Brook Harbor', -70.662388699999994, 41.661195800000002, -70.632819909999995, 41.68116405, '2018-08-08 17:57:15.585', '2018-08-08 17:57:15.585', 0, 73, false, 1, 9.7079134, 271.3979797, 2, 0.0, 0, 217658870.00, 3.7567761, 4.952525139);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (7, 'Megansett Harbor', -70.654831160000001, 41.637446850000003, -70.619869120000004, 41.664003110000003, '2018-08-08 17:57:15.587', '2018-08-08 17:57:15.587', 4, 191, true, 3, 21.2656403, 283.9780273, 3, 3.3487511, 1, 683448500.00, 4.5419111, 12.91113758);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (8, 'Old Silver Beach', -70.654231940000003, 41.606726719999997, -70.639767680000006, 41.641907660000001, '2018-08-08 17:57:15.589', '2018-08-08 17:57:15.589', 2, 109, false, 6, 31.3422775, 175.4341583, 11, 2.9746351, 0, 635004300.00, 3.843195, 16.91975403);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (9, 'Sippewissett', -70.664161329999999, 41.541302250000001, -70.641495169999999, 41.606903799999998, '2018-08-08 17:57:15.591', '2018-08-08 17:57:15.591', 0, 72, false, 0, 95.0317993, 431.8627625, 9, 6.4433169, 0, 582787000.00, 5.3717442, 8.564338684);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (10, 'Woods Hole', -70.688690660000006, 41.51665019, -70.663074300000005, 41.541812219999997, '2018-08-08 17:57:15.593', '2018-08-08 17:57:15.593', 7, 102, true, 110, 3.9876704, 284.7936707, 3, 22.3431664, 1, 626611700.00, 4.9520388, 10.31838799);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (11, 'Nobska', -70.668310849999997, 41.514311480000003, -70.655190000000005, 41.523292429999998, '2018-08-08 17:57:15.595', '2018-08-08 17:57:15.595', 6, 43, true, 89, 0.4663978, 87.6272888, 1, 4.3100624, 0, 251606300.00, 1.395851, 18.66693115);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (12, 'South Falmouth', -70.655516890000001, 41.514329189999998, -70.528065830000003, 41.552341149999997, '2018-08-08 17:57:15.597', '2018-08-08 17:57:15.597', 3, 185, true, 28, 38.2330894, 975.5437622, 17, 175.8104095, 0, 1025546449.00, 7.9527521, 13.50438404);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (13, 'New Seabury', -70.528079640000001, 41.546571610000001, -70.449744679999995, 41.588077400000003, '2018-08-08 17:57:15.598', '2018-08-08 17:57:15.598', 0, 39, false, 0, 61.836483, 19.7484436, 5, 298.637207, 0, 894116100.00, 5.3732042, 11.50544548);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (14, 'Cotuit', -70.45280941, 41.58731796, -70.400938479999994, 41.609039250000002, '2018-08-08 17:57:15.6', '2018-08-08 17:57:15.6', 0, 89, true, 4, 25.401474, 54.628727, 4, 0.8072858, 0, 435699300.00, 3.7948329, 6.853813171);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (15, 'Wianno', -70.400956260000001, 41.605766500000001, -70.364380179999998, 41.6221806, '2018-08-08 17:57:15.601', '2018-08-08 17:57:15.601', 0, 104, false, 2, 3.102915, 322.4924316, 2, 33.4862099, 0, 513900700.00, 2.2582591, 11.87512684);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (16, 'Centerville Harbor', -70.365510999999998, 41.621756320000003, -70.316909589999995, 41.636301510000003, '2018-08-08 17:57:15.603', '2018-08-08 17:57:15.603', 1, 79, false, 4, 99.109169, 191.6327057, 7, 40.852684, 1, 523927500.00, 3.4090099, 11.96304893);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (17, 'Lewis Bay', -70.317261599999995, 41.60842778, -70.240108090000007, 41.651744409999999, '2018-08-08 17:57:15.604', '2018-08-08 17:57:15.604', 38, 294, true, 115, 137.3874664, 466.7622681, 17, 131.2438965, 2, 1428641000.00, 11.5430002, 18.56052208);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (18, 'Nantucket Sound', -70.26578859, 41.608446469999997, -69.981908079999997, 41.67233469, '2018-08-08 17:57:15.606', '2018-08-08 17:57:15.606', 9, 518, true, 70, 380.8373108, 2486.3562012, 51, 490.1095581, 0, 2537257400.00, 17.3015995, 15.66193962);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (19, 'Monomoy', -70.015497060000001, 41.539490399999998, -69.941678929999995, 41.672420250000002, '2018-08-08 17:57:15.607', '2018-08-08 17:57:15.607', 1, 10, false, 5, 105.3767395, 560.2143555, 2, 213.083374, 0, 271926400.00, 20.9548302, 0.722238481);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (20, 'Chatham Harbor', -69.951523249999994, 41.672034500000002, -69.944336519999993, 41.704417540000001, '2018-08-08 17:57:15.609', '2018-08-08 17:57:15.609', 2, 33, true, 11, 31.2736931, 78.3087082, 5, 21.3441048, 0, 865465800.00, 2.5425341, 17.18111992);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (21, 'Bassing Harbor', -69.973979110000002, 41.703868069999999, -69.944624430000005, 41.721852800000001, '2018-08-08 17:57:15.61', '2018-08-08 17:57:15.61', 0, 32, false, 4, 34.5506363, 361.5568237, 3, 37.4128647, 0, 481869100.00, 3.182462, 9.980096817);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (22, 'Wequassett', -69.996575980000003, 41.712730710000002, -69.973599469999996, 41.73643113, '2018-08-08 17:57:15.611', '2018-08-08 17:57:15.611', 1, 45, true, 8, 22.9759789, 71.4209671, 9, 152.7987518, 1, 310864000.00, 3.073679, 11.93692398);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (23, 'Little Pleasant Bay', -69.987729540000004, 41.704136910000003, -69.927629839999994, 41.774281960000003, '2018-08-08 17:57:15.613', '2018-08-08 17:57:15.613', 1, 66, true, 12, 511.4660339, 821.8519897, 7, 470.2912292, 2, 592666250.00, 12.0422802, 5.15602541);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (24, 'Nauset', -69.940282339999996, 41.707687249999999, -69.926347719999995, 41.826331490000001, '2018-08-08 17:57:15.615', '2018-08-08 17:57:15.615', 0, 0, false, 22, 243.6255646, 22.5867462, 1, 762.0858154, 0, 130701200.00, 8.6657391, 1.425156593);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (25, 'Coast Guard Beach', -69.950752940000001, 41.826219999999999, -69.938187580000005, 41.861484259999997, '2018-08-08 17:57:15.616', '2018-08-08 17:57:15.616', 1, 0, false, 9, 23.6465569, 0.0, 3, 0.0, 0, 30923200.00, 2.540206, 2.573147058);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (26, 'Marconi', -69.961485589999995, 41.861381649999998, -69.949541749999995, 41.893570339999997, '2018-08-08 17:57:15.617', '2018-08-08 17:57:15.617', 0, 0, false, 6, 0.0, 0.0, 2, 171.526062, 0, 17981400.00, 2.2889249, 2.897997141);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (27, 'Outer Cape', -70.248582010000007, 41.893468759999998, -69.960287199999996, 42.083433970000002, '2018-08-08 17:57:15.619', '2018-08-08 17:57:15.619', 0, 8, false, 75, 118.0019379, 12.9466887, 15, 3932.9230957, 0, 171293000.00, 28.6761799, 1.655546427);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (28, 'Provincetown Harbor', -70.198700819999999, 42.023928810000001, -70.166441160000005, 42.046558920000003, '2018-08-08 17:57:15.62', '2018-08-08 17:57:15.62', 4, 50, true, 25, 133.3305054, 140.2750092, 8, 292.7267151, 0, 726006200.00, 3.480684, 11.96743774);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (29, 'Truro', -70.189771570000005, 41.968132099999998, -70.077125319999993, 42.06217857, '2018-08-08 17:57:15.622', '2018-08-08 17:57:15.622', 15, 144, true, 79, 39.6284142, 1121.4608154, 30, 168.9987946, 0, 2369225100.00, 10.7964802, 17.23412132);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (30, 'Bound Brook', -70.078962009999998, 41.943333180000003, -70.076689000000002, 41.968212999999999, '2018-08-08 17:57:15.623', '2018-08-08 17:57:15.623', 0, 0, false, 5, 0.0, 325.9089966, 2, 240.3492889, 0, 70897100.00, 1.72536, 2.774612904);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (31, 'Great Island', -70.078264610000005, 41.883896399999998, -70.066949750000006, 41.943421489999999, '2018-08-08 17:57:15.625', '2018-08-08 17:57:15.625', 0, 0, false, 0, 106.9666061, 425.5777283, 2, 489.5529175, 0, 15374700.00, 4.1978979, 8.03567028);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (32, 'Wellfleet Harbor', -70.070769490000004, 41.884116990000003, -70.022969829999994, 41.931489489999997, '2018-08-08 17:57:15.627', '2018-08-08 17:57:15.627', 4, 97, true, 6, 222.3549652, 70.8523407, 10, 624.2570801, 0, 455847300.00, 10.5048399, 6.293058395);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (33, 'Blackfish Creek', -70.025521650000002, 41.892498170000003, -70.005875160000002, 41.909796900000003, '2018-08-08 17:57:15.628', '2018-08-08 17:57:15.628', 0, 35, false, 0, 177.3943939, 0.0, 0, 0.6491886, 0, 149123700.00, 2.860405, 4.120303631);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (34, 'Cape Cod Bay', -70.108763749999994, 41.763042489999997, -70.001422550000001, 41.893207269999998, '2018-08-08 17:57:15.63', '2018-08-08 17:57:15.63', 4, 143, true, 96, 608.8064575, 189.9243622, 41, 201.6305389, 2, 1542971500.00, 13.96208, 10.03118896);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (35, 'Quivett', -70.181354369999994, 41.751327770000003, -70.108532909999994, 41.764202789999999, '2018-08-08 17:57:15.631', '2018-08-08 17:57:15.631', 4, 36, true, 3, 89.2759476, 9.3302622, 8, 43.7184067, 0, 446347420.00, 4.1774969, 8.187264442);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (36, 'Barnstable Harbor', -70.352559889999995, 41.708378570000001, -70.181124679999996, 41.753029830000003, '2018-08-08 17:57:15.633', '2018-08-08 17:57:15.633', 8, 98, true, 27, 1256.4754639, 37.4771461, 11, 87.6455841, 3, 974675740.00, 16.4632301, 5.641637325);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent) VALUES (37, 'Sagamore', -70.537776390000005, 41.776631440000003, -70.493277500000005, 41.811147099999999, '2018-08-08 17:57:15.634', '2018-08-08 17:57:15.634', 0, 33, false, 8, 0.0, 5.9798193, 2, 138.4368439, 0, 255135300.00, 3.3053861, 10.14210987);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627200200, '2018-08-08 17:57:12.986');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627200743, '2018-08-08 17:57:13.062');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627201108, '2018-08-08 17:57:13.122');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627203452, '2018-08-08 17:57:13.181');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627211906, '2018-08-08 17:57:13.22');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627212047, '2018-08-08 17:57:13.254');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627212147, '2018-08-08 17:57:13.284');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180703202705, '2018-08-08 17:57:13.315');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180703204221, '2018-08-08 17:57:13.347');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180703204303, '2018-08-08 17:57:13.376');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180703205219, '2018-08-08 17:57:13.406');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180705210332, '2018-08-08 17:57:13.438');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180718180304, '2018-08-08 17:57:13.489');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180726173204, '2018-08-08 17:57:13.523');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180727193446, '2018-08-08 17:57:13.563');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180727194146, '2018-08-08 17:57:13.593');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807203920, '2018-08-08 17:57:13.62');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807203940, '2018-08-08 17:57:13.646');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807203956, '2018-08-08 17:57:13.671');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807204011, '2018-08-08 17:57:13.698');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807204026, '2018-08-08 17:57:13.724');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807204040, '2018-08-08 17:57:13.751');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807204054, '2018-08-08 17:57:13.775');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807204115, '2018-08-08 17:57:13.802');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807204132, '2018-08-08 17:57:13.828');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807204145, '2018-08-08 17:57:13.853');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180808140524, '2018-08-08 17:57:13.879');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180808140539, '2018-08-08 17:57:13.905');


--
-- Data for Name: strategies_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (2, 3);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (3, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (3, 3);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (4, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (5, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (6, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (7, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (8, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (9, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (10, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (11, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (12, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (13, 1);


--
-- Data for Name: strategies_hazards; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (2, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (2, 2);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (2, 3);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (3, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (3, 2);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (3, 3);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (4, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (4, 2);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (4, 3);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (5, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (6, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (7, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (7, 2);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (7, 3);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (8, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (8, 2);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (9, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (9, 2);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (10, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (10, 2);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (11, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (11, 2);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (12, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (12, 2);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (13, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (13, 2);


--
-- Data for Name: strategies_scales; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (2, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (3, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (3, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (3, 3);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (3, 4);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (4, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (4, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (5, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (5, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (6, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (6, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (7, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (7, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (8, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (8, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (9, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (9, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (10, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (10, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (11, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (11, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (12, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (12, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (13, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (13, 2);


--
-- Name: adaptation_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adaptation_categories_id_seq', 3, true);


--
-- Name: adaptation_strategies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adaptation_strategies_id_seq', 13, true);


--
-- Name: coastal_hazards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.coastal_hazards_id_seq', 3, true);


--
-- Name: impact_scales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.impact_scales_id_seq', 4, true);


--
-- Name: littoral_cells_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.littoral_cells_id_seq', 37, true);


--
-- PostgreSQL database dump complete
--

