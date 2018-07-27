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

INSERT INTO public.adaptation_categories (id, name, description, inserted_at, updated_at, display_order) VALUES (1, 'Protect', NULL, '2018-07-27 21:18:17.597', '2018-07-27 21:18:17.597', 10);
INSERT INTO public.adaptation_categories (id, name, description, inserted_at, updated_at, display_order) VALUES (2, 'Accommodate', NULL, '2018-07-27 21:18:17.606', '2018-07-27 21:18:17.606', 20);
INSERT INTO public.adaptation_categories (id, name, description, inserted_at, updated_at, display_order) VALUES (3, 'Retreat', NULL, '2018-07-27 21:18:17.619', '2018-07-27 21:18:17.619', 30);


--
-- Data for Name: adaptation_strategies; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (1, 'Do Nothing', NULL, '2018-07-27 21:18:17.629', '2018-07-27 21:18:17.629', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (2, 'Undevelopment', 'Removing development from an existing location by land purchase, flood insurance buy-out programs, or other means.', '2018-07-27 21:18:17.633', '2018-07-27 21:18:17.633', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (3, 'Open Space Protection', 'Including protection of existing wetland, drainage system, and buffer zone resources in planning will protect them from development impacts preserving them as a natural defense system.', '2018-07-27 21:18:17.713', '2018-07-27 21:18:17.713', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (4, 'Salt Marsh Restoration', 'Protecting, restoring, and creating salt marsh as a buffer to storm surges and sea level rise to provide natural flood protection.', '2018-07-27 21:18:17.732', '2018-07-27 21:18:17.732', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (5, 'Revetment', 'Sloped wall of boulders constructed along eroding coastal banks designed to reflect wave energy and protect upland structures.', '2018-07-27 21:18:17.744', '2018-07-27 21:18:17.744', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (6, 'Seawalls', 'Structures built parallel to the shore with vertical or sloped walls (typically smooth) to reinforce the shoreline against forces of wave action and erosion.', '2018-07-27 21:18:17.754', '2018-07-27 21:18:17.754', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (7, 'Dune Restoration/Creation', 'Restoring existing dunes or creating new dunes to protect the shoreline against erosion and flooding.', '2018-07-27 21:18:17.762', '2018-07-27 21:18:17.762', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (8, 'Bank Stabilization: Fiber/Coir Roll', 'Cylindrical rolls, 12-20 inches in diameter & 10-20 feet long, made of coir (coconut fiber) held together by a fiber mesh, covered with sand, and are planted with salt-tolerant vegetation with extensive root systems. These reinforced banks act as physical barriers to waves, tides, and currents. The rolls typically disintegrate over 5-7 years to allow plants time to grow their root systems to keep sand and soil in place.', '2018-07-27 21:18:17.773', '2018-07-27 21:18:17.773', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (9, 'Bank Stabilization: Coir Envelopes', 'Envelopes are constructed of coir (coconut fiber) fabric and are filled with local sand. The envelopes are placed in terraces along the beach, are typically covered with sand, and may also be planted with native vegetation to hold sand together and absorb water.', '2018-07-27 21:18:17.785', '2018-07-27 21:18:17.785', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (10, 'Living Shoreline: Vegetation Only', 'Shoreline stabilization techniques along estuarine coasts, bays, sheltered coastlines, and tributaries. A living shoreline has a footprint that is made up mostly of native material. It incorporates vegetation or other living, natural "soft" elements alone or in combination with some other type of harder shoreline structures (e.g. oyster reefs or rock sills) for added stability. Using vegetation alone is one approach. Roots hold soil in place to reduce erosion. Provides a buffer to upload areas and breaks small waves.', '2018-07-27 21:18:17.795', '2018-07-27 21:18:17.795', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (11, 'Living Shoreline: Combined Vegetation and Structural Measures', 'Shoreline stabilization techniques along estuarine coasts, bays, sheltered coastlines, and tributaries. A living shoreline has a footprint that is made up mostly of native material. It incorporates vegetation or other living, natural "soft" elements alone or in combination with some other type of harder shoreline structures (e.g. oyster reefs or rock sills) for added stability. A combined approach integrates living components, such as plantings, with strategically placed structural elements, such as sills, or breakwaters.', '2018-07-27 21:18:17.804', '2018-07-27 21:18:17.804', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (12, 'Living Shoreline: Living Breakwater/Oyster Reefs', 'Shoreline stabilization techniques along estuarine coasts, bays, sheltered coastlines, and tributaries. A living shoreline has a footprint that is made
            up mostly of native material. It incorporates vegetation or other living, natural "soft" elements alone or in combination with some other type of harder shoreline structures (e.g. oyster reefs or rock sills) for added stability. Restoring or creating oyster reefs or reef balls to serve as natural breakwaters, attenuate wave energy, and slow inland water transfer.', '2018-07-27 21:18:17.817', '2018-07-27 21:18:17.817', NULL, true);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active) VALUES (13, 'Beach Nourishment', 'The process of adding sediment (sand) to an eroding beach to widen or elevate the beach to maintain or advance the shoreline seaward. Sediment can be sourced from inland mining, dredging from navigation channels, and/or offshore mining.', '2018-07-27 21:18:17.827', '2018-07-27 21:18:17.827', NULL, true);


--
-- Data for Name: coastal_hazards; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.coastal_hazards (id, name, description, inserted_at, updated_at, display_order) VALUES (1, 'Erosion', NULL, '2018-07-27 21:18:17.562', '2018-07-27 21:18:17.562', NULL);
INSERT INTO public.coastal_hazards (id, name, description, inserted_at, updated_at, display_order) VALUES (2, 'Storm Surge', NULL, '2018-07-27 21:18:17.571', '2018-07-27 21:18:17.571', NULL);
INSERT INTO public.coastal_hazards (id, name, description, inserted_at, updated_at, display_order) VALUES (3, 'Sea Level Rise', NULL, '2018-07-27 21:18:17.586', '2018-07-27 21:18:17.586', NULL);


--
-- Data for Name: impact_scales; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.impact_scales (id, name, description, impact, inserted_at, updated_at, display_order) VALUES (1, 'Site', NULL, 1, '2018-07-27 21:18:17.499', '2018-07-27 21:18:17.499', NULL);
INSERT INTO public.impact_scales (id, name, description, impact, inserted_at, updated_at, display_order) VALUES (2, 'Neighborhood', NULL, 2, '2018-07-27 21:18:17.529', '2018-07-27 21:18:17.529', NULL);
INSERT INTO public.impact_scales (id, name, description, impact, inserted_at, updated_at, display_order) VALUES (3, 'Community', NULL, 3, '2018-07-27 21:18:17.542', '2018-07-27 21:18:17.542', NULL);
INSERT INTO public.impact_scales (id, name, description, impact, inserted_at, updated_at, display_order) VALUES (4, 'Regional', NULL, 4, '2018-07-27 21:18:17.552', '2018-07-27 21:18:17.552', NULL);


--
-- Data for Name: littoral_cells; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (1, 'Sandy Neck', -70.495195319999993, 41.724435290000002, -70.271945340000002, 41.777071839999998, '2018-07-27 21:18:17.882', '2018-07-27 21:18:17.882', 12.8821297, 4.404603481);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (2, 'Buttermilk Bay', -70.633527229999999, 41.736539469999997, -70.609278110000005, 41.765290014000001, '2018-07-27 21:18:17.922', '2018-07-27 21:18:17.922', 4.9664421, 25.71430588);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (3, 'Mashnee', -70.640538980000002, 41.714612780000003, -70.620871019999996, 41.737068870000002, '2018-07-27 21:18:17.928', '2018-07-27 21:18:17.928', 2.939918, 13.06014061);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (4, 'Monument Beach', -70.637285160000005, 41.70796773, -70.614977600000003, 41.737068870000002, '2018-07-27 21:18:17.946', '2018-07-27 21:18:17.946', 3.889698, 11.41208649);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (5, 'Wings Neck', -70.663056999999995, 41.679642700000002, -70.616675970000003, 41.707978679999997, '2018-07-27 21:18:17.949', '2018-07-27 21:18:17.949', 4.0165191, 9.428860664);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (6, 'Red Brook Harbor', -70.662388699999994, 41.661195800000002, -70.632819909999995, 41.68116405, '2018-07-27 21:18:17.95', '2018-07-27 21:18:17.95', 3.7567761, 4.952525139);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (7, 'Megansett Harbor', -70.654831160000001, 41.637446850000003, -70.619869120000004, 41.664003110000003, '2018-07-27 21:18:17.952', '2018-07-27 21:18:17.952', 4.5419111, 12.91113758);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (8, 'Old Silver Beach', -70.654231940000003, 41.606726719999997, -70.639767680000006, 41.641907660000001, '2018-07-27 21:18:17.954', '2018-07-27 21:18:17.954', 3.843195, 16.91975403);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (9, 'Sippewissett', -70.664161329999999, 41.541302250000001, -70.641495169999999, 41.606903799999998, '2018-07-27 21:18:17.955', '2018-07-27 21:18:17.955', 5.3717442, 8.564338684);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (10, 'Woods Hole', -70.688690660000006, 41.51665019, -70.663074300000005, 41.541812219999997, '2018-07-27 21:18:17.96', '2018-07-27 21:18:17.96', 4.9520388, 10.31838799);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (11, 'Nobska', -70.668310849999997, 41.514311480000003, -70.655190000000005, 41.523292429999998, '2018-07-27 21:18:17.962', '2018-07-27 21:18:17.962', 1.395851, 18.66693115);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (12, 'South Falmouth', -70.655516890000001, 41.514329189999998, -70.528065830000003, 41.552341149999997, '2018-07-27 21:18:17.964', '2018-07-27 21:18:17.964', 7.9527521, 13.50438404);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (13, 'New Seabury', -70.528079640000001, 41.546571610000001, -70.449744679999995, 41.588077400000003, '2018-07-27 21:18:17.972', '2018-07-27 21:18:17.972', 5.3732042, 11.50544548);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (14, 'Cotuit', -70.45280941, 41.58731796, -70.400938479999994, 41.609039250000002, '2018-07-27 21:18:17.974', '2018-07-27 21:18:17.974', 3.7948329, 6.853813171);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (15, 'Wianno', -70.400956260000001, 41.605766500000001, -70.364380179999998, 41.6221806, '2018-07-27 21:18:17.976', '2018-07-27 21:18:17.976', 2.2582591, 11.87512684);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (16, 'Centerville Harbor', -70.365510999999998, 41.621756320000003, -70.316909589999995, 41.636301510000003, '2018-07-27 21:18:17.978', '2018-07-27 21:18:17.978', 3.4090099, 11.96304893);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (17, 'Lewis Bay', -70.317261599999995, 41.60842778, -70.240108090000007, 41.651744409999999, '2018-07-27 21:18:17.979', '2018-07-27 21:18:17.979', 11.5430002, 18.56052208);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (18, 'Nantucket Sound', -70.26578859, 41.608446469999997, -69.981908079999997, 41.67233469, '2018-07-27 21:18:17.981', '2018-07-27 21:18:17.981', 17.3015995, 15.66193962);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (19, 'Monomoy', -70.015497060000001, 41.539490399999998, -69.941678929999995, 41.672420250000002, '2018-07-27 21:18:17.982', '2018-07-27 21:18:17.982', 20.9548302, 0.722238481);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (20, 'Chatham Harbor', -69.951523249999994, 41.672034500000002, -69.944336519999993, 41.704417540000001, '2018-07-27 21:18:17.991', '2018-07-27 21:18:17.991', 2.5425341, 17.18111992);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (21, 'Bassing Harbor', -69.973979110000002, 41.703868069999999, -69.944624430000005, 41.721852800000001, '2018-07-27 21:18:17.992', '2018-07-27 21:18:17.992', 3.182462, 9.980096817);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (22, 'Wequassett', -69.996575980000003, 41.712730710000002, -69.973599469999996, 41.73643113, '2018-07-27 21:18:17.993', '2018-07-27 21:18:17.993', 3.073679, 11.93692398);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (23, 'Little Pleasant Bay', -69.987729540000004, 41.704136910000003, -69.927629839999994, 41.774281960000003, '2018-07-27 21:18:18.02', '2018-07-27 21:18:18.02', 12.0422802, 5.15602541);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (24, 'Nauset', -69.940282339999996, 41.707687249999999, -69.926347719999995, 41.826331490000001, '2018-07-27 21:18:18.021', '2018-07-27 21:18:18.021', 8.6657391, 1.425156593);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (25, 'Coast Guard Beach', -69.950752940000001, 41.826219999999999, -69.938187580000005, 41.861484259999997, '2018-07-27 21:18:18.027', '2018-07-27 21:18:18.027', 2.540206, 2.573147058);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (26, 'Marconi', -69.961485589999995, 41.861381649999998, -69.949541749999995, 41.893570339999997, '2018-07-27 21:18:18.042', '2018-07-27 21:18:18.042', 2.2889249, 2.897997141);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (27, 'Outer Cape', -70.248582010000007, 41.893468759999998, -69.960287199999996, 42.083433970000002, '2018-07-27 21:18:18.057', '2018-07-27 21:18:18.057', 28.6761799, 1.655546427);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (28, 'Provincetown Harbor', -70.198700819999999, 42.023928810000001, -70.166441160000005, 42.046558920000003, '2018-07-27 21:18:18.059', '2018-07-27 21:18:18.059', 3.480684, 11.96743774);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (29, 'Truro', -70.189771570000005, 41.968132099999998, -70.077125319999993, 42.06217857, '2018-07-27 21:18:18.061', '2018-07-27 21:18:18.061', 10.7964802, 17.23412132);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (30, 'Bound Brook', -70.078962009999998, 41.943333180000003, -70.076689000000002, 41.968212999999999, '2018-07-27 21:18:18.062', '2018-07-27 21:18:18.062', 1.72536, 2.774612904);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (31, 'Great Island', -70.078264610000005, 41.883896399999998, -70.066949750000006, 41.943421489999999, '2018-07-27 21:18:18.07', '2018-07-27 21:18:18.07', 4.1978979, 8.03567028);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (32, 'Wellfleet Harbor', -70.070769490000004, 41.884116990000003, -70.022969829999994, 41.931489489999997, '2018-07-27 21:18:18.072', '2018-07-27 21:18:18.072', 10.5048399, 6.293058395);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (33, 'Blackfish Creek', -70.025521650000002, 41.892498170000003, -70.005875160000002, 41.909796900000003, '2018-07-27 21:18:18.078', '2018-07-27 21:18:18.078', 2.860405, 4.120303631);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (34, 'Cape Cod Bay', -70.108763749999994, 41.763042489999997, -70.001422550000001, 41.893207269999998, '2018-07-27 21:18:18.079', '2018-07-27 21:18:18.079', 13.96208, 10.03118896);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (35, 'Quivett', -70.181354369999994, 41.751327770000003, -70.108532909999994, 41.764202789999999, '2018-07-27 21:18:18.08', '2018-07-27 21:18:18.08', 4.1774969, 8.187264442);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (36, 'Barnstable Harbor', -70.352559889999995, 41.708378570000001, -70.181124679999996, 41.753029830000003, '2018-07-27 21:18:18.082', '2018-07-27 21:18:18.082', 16.4632301, 5.641637325);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, length_miles, imperv_percent) VALUES (37, 'Sagamore', -70.537776390000005, 41.776631440000003, -70.493277500000005, 41.811147099999999, '2018-07-27 21:18:18.083', '2018-07-27 21:18:18.083', 3.3053861, 10.14210987);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627200200, '2018-07-27 21:18:15.845');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627200743, '2018-07-27 21:18:15.98');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627201108, '2018-07-27 21:18:16.068');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627203452, '2018-07-27 21:18:16.193');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627211906, '2018-07-27 21:18:16.232');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627212047, '2018-07-27 21:18:16.271');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627212147, '2018-07-27 21:18:16.307');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180703202705, '2018-07-27 21:18:16.346');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180703204221, '2018-07-27 21:18:16.397');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180703204303, '2018-07-27 21:18:16.434');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180703205219, '2018-07-27 21:18:16.468');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180705210332, '2018-07-27 21:18:16.5');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180718180304, '2018-07-27 21:18:16.563');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180726173204, '2018-07-27 21:18:16.6');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180727193446, '2018-07-27 21:18:16.651');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180727194146, '2018-07-27 21:18:16.684');


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

