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
-- Data for Name: adaptation_strategies; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement) VALUES (1, 'No Action', 'Take no action to address changes in the coast. Effects of erosion, SLR, and flooding will continue or intensify. Depending on conditions, coastal resources may not migrate naturally where steep topography or preexisting coastal erosion control structures are present. Structures or facilities may be threatened or undermined.', '2018-10-22 14:15:13.263', '2018-10-22 14:15:13.263', NULL, true, NULL, 'anywhere');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement) VALUES (2, 'Undevelopment', 'Removing development from an existing location by land purchase, flood insurance buy-out programs, or other means.', '2018-10-22 14:15:13.343', '2018-10-22 14:15:13.343', NULL, false, NULL, 'anywhere');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement) VALUES (3, 'Managed Relocation', 'Gradually moving development and infrastructure away from the coastline and areas of projected loss due to flooding and sea level rise.', '2018-10-22 14:15:13.371', '2018-10-22 14:15:13.371', NULL, false, 'Various local and state permits may be required.', NULL);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement) VALUES (4, 'Transfer of Development Credit/Transferable Development Rights', 'Land use mechanism that encourages the permanent removal of development rights in defined “sending” districts, and allows those rights to be transferred to defined “receiving” districts.', '2018-10-22 14:15:13.398', '2018-10-22 14:15:13.398', NULL, false, 'Local bylaws allowing for Transfer of Development Rights must be in place.', NULL);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement) VALUES (5, 'Tidal Wetland and Floodplain Restoration or Creation', 'Protecting, restoring, and creating coastal habitats within the floodplain as a buffer to storm surges and sea level rise to provide natural flood protection.', '2018-10-22 14:15:13.42', '2018-10-22 14:15:13.42', NULL, false, 'Various local, state, and federal permits required depending on scope and location of project.', NULL);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement) VALUES (6, 'Rolling Conservation Easements', 'Private property owners sell or otherwise transfer rights in these portions of their land abutting an eroding coastline.  Rolling easements allow for limited development of upland areas of the property, and restrict development and/or the construction of erosion control structures along the shoreline.', '2018-10-22 14:15:13.438', '2018-10-22 14:15:13.438', NULL, false, 'Local Conservation Commission approval; Conservation easements must be approved by the municipality involved.', NULL);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement) VALUES (7, 'Groin', 'A hard structure projecting perpendicular from the shoreline. Designed to intercept water flow and sand moving parallel to the shoreline to prevent beach erosion, retain beach sand, and break waves.', '2018-10-22 14:15:13.461', '2018-10-22 14:15:13.461', NULL, false, 'Various local, state, and federal permits required.  New groins are infrequently permitted due to impacts.', NULL);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement) VALUES (8, 'Sand Bypass System', 'Where a jetty or groin has interrupted the flow of sediment along the beach, sand may be moved hydraulically or mechanically from the accreting updrift side of an inlet to the eroding down-drift side.', '2018-10-22 14:15:13.481', '2018-10-22 14:15:13.481', NULL, false, 'Various local, state, and federal permits required depending on scope and location of project.', NULL);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement) VALUES (9, 'Open Space Protection', 'Including protection of existing wetland, drainage system, and buffer zone resources in planning will protect them from development impacts preserving them as a natural defense system.', '2018-10-22 14:15:13.496', '2018-10-22 14:15:13.496', NULL, false, NULL, 'undeveloped_only');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement) VALUES (10, 'Salt Marsh Restoration', 'Protecting, restoring, and creating salt marsh as a buffer to storm surges and sea level rise to provide natural flood protection.', '2018-10-22 14:15:13.507', '2018-10-22 14:15:13.507', NULL, false, NULL, NULL);
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement) VALUES (11, 'Revetment', 'Sloped piles of boulders constructed along eroding coastal banks designed to intercept wave energy and decrease erosion.', '2018-10-22 14:15:13.517', '2018-10-22 14:15:13.517', NULL, true, 'Various local, state, and federal permits required.', 'coastal_bank_only');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement) VALUES (12, 'Seawalls', 'Structures built parallel to the shore with vertical or sloped walls (typically smooth) to reinforce the shoreline against forces of wave action and erosion.', '2018-10-22 14:15:13.535', '2018-10-22 14:15:13.535', NULL, false, NULL, 'coastal_bank_only');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement) VALUES (13, 'Dune Creation', 'Creating additional or new dunes to protect the shoreline against erosion and flooding.', '2018-10-22 14:15:13.54', '2018-10-22 14:15:13.54', NULL, true, 'Various local and state permits may be required.', 'anywhere_but_salt_marsh');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement) VALUES (14, 'Bank Stabilization', 'Cylindrical rolls, 12-20 inches in diameter & 10-20 feet long, made of coir (coconut) fiber held together by a fiber mesh, covered with sand, and are planted with salt-tolerant vegetation with extensive root systems. These reinforced banks act as physical barriers to waves, tides, and currents. They typically disintegrate over 5-7 years to allow plants time to grow their root systems to keep sand and soil in place.', '2018-10-22 14:15:13.55', '2018-10-22 14:15:13.55', NULL, true, 'Local and state permits required, potentially federal permits depending on location.', 'coastal_bank_only');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement) VALUES (15, 'Bank Stabilization: Coir Envelopes', 'Envelopes are constructed of coir (coconut fiber) fabric and are filled with local sand. The envelopes are placed in terraces along the beach, are typically covered with sand, and may also be planted with native vegetation to hold sand together and absorb water.', '2018-10-22 14:15:13.564', '2018-10-22 14:15:13.564', NULL, false, NULL, 'coastal_bank_only');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement) VALUES (16, 'Living Shoreline: Vegetation Only', 'Shoreline stabilization techniques along estuarine coasts, bays, sheltered coastlines, and tributaries. A living shoreline has a footprint that is made up mostly of native material. It incorporates vegetation or other living, natural "soft" elements alone or in combination with some other type of harder shoreline structures (e.g. oyster reefs or rock sills) for added stability. Using vegetation alone is one approach. Roots hold soil in place to reduce erosion. Provides a buffer to upload areas and breaks small waves.', '2018-10-22 14:15:13.57', '2018-10-22 14:15:13.57', NULL, false, NULL, 'anywhere_but_salt_marsh');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement) VALUES (17, 'Living Shoreline', 'A living shoreline has a footprint that is made up mostly of native material.  It incorporates vegetation or other living, natural “soft” elements alone or in combination with some other type of harder shoreline structure (e.g. oyster reefs or rock sills) for added stability. A combined approach integrates living components, such as plantings, with strategically placed structural elements, such as sills, revetments, and breakwaters.', '2018-10-22 14:15:13.58', '2018-10-22 14:15:13.58', NULL, true, 'Various local, state, and federal permits required depending on scope and location of project.', 'anywhere_but_salt_marsh');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement) VALUES (18, 'Living Shoreline: Living Breakwater/Oyster Reefs', 'Shoreline stabilization techniques along estuarine coasts, bays, sheltered coastlines, and tributaries. A living shoreline has a footprint that is made
            up mostly of native material. It incorporates vegetation or other living, natural "soft" elements alone or in combination with some other type of harder shoreline structures (e.g. oyster reefs or rock sills) for added stability. Restoring or creating oyster reefs or reef balls to serve as natural breakwaters, attenuate wave energy, and slow inland water transfer.', '2018-10-22 14:15:13.597', '2018-10-22 14:15:13.597', NULL, false, NULL, 'anywhere_but_salt_marsh');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement) VALUES (19, 'Beach Nourishment', 'The process of adding sediment to an eroding beach to widen the beach and advance the shoreline seaward. Sources for sediment include inland mining, nearshore dredging including for navigation projects, and offshore mining.', '2018-10-22 14:15:13.603', '2018-10-22 14:15:13.603', NULL, true, 'Various local, state, and federal permits required depending on scope and location of project.', 'anywhere_but_salt_marsh');


--
-- Data for Name: adaptation_advantages; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (1, 'Allows natural erosion and sediment processes to occur.', 0, '2018-10-22 14:15:13.273', '2018-10-22 14:15:13.273', 1);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (2, 'Natural migration of resource areas and landforms may occur providing benefits to the environment and humans.', 1, '2018-10-22 14:15:13.275', '2018-10-22 14:15:13.275', 1);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (3, 'Continued recreational access (depending on conditions).', 2, '2018-10-22 14:15:13.276', '2018-10-22 14:15:13.276', 1);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (4, 'Spares existing development from the effects of erosion and flooding.', 0, '2018-10-22 14:15:13.378', '2018-10-22 14:15:13.378', 3);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (5, 'Protects future development from flooding.', 1, '2018-10-22 14:15:13.381', '2018-10-22 14:15:13.381', 3);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (6, 'Allows for the maintenance or restoration of intertidal habitat.', 2, '2018-10-22 14:15:13.382', '2018-10-22 14:15:13.382', 3);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (7, 'Conserves undisturbed areas that may serve as habitat or flood buffers.', 0, '2018-10-22 14:15:13.403', '2018-10-22 14:15:13.403', 4);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (8, 'Prevents development in areas likely to become inundated or hazard areas.', 1, '2018-10-22 14:15:13.404', '2018-10-22 14:15:13.404', 4);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (9, 'Allows for the same development potential in a community, redirecting development to revitalize urban and mixed-use centers.', 2, '2018-10-22 14:15:13.405', '2018-10-22 14:15:13.405', 4);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (10, 'Serve as  buffers for coastal areas against storm and wave damage.', 0, '2018-10-22 14:15:13.426', '2018-10-22 14:15:13.426', 5);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (11, 'Wave attenuation and/or dissipation.', 1, '2018-10-22 14:15:13.427', '2018-10-22 14:15:13.427', 5);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (12, 'Stabilize coastal shorelines to reduce or prevent erosion. Reduces or eliminates the need for hard engineered structures.', 2, '2018-10-22 14:15:13.427', '2018-10-22 14:15:13.427', 5);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (13, 'Improve water quality through filtering, storing, and breaking down pollutants.', 3, '2018-10-22 14:15:13.428', '2018-10-22 14:15:13.428', 5);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (14, 'Reduce flooding of upland areas and nearby infrastructure by reducing duration and extent of floodwater.', 4, '2018-10-22 14:15:13.429', '2018-10-22 14:15:13.429', 5);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (15, 'Conserves undisturbed areas that may serve as habitat or flood buffers.', 0, '2018-10-22 14:15:13.438', '2018-10-22 14:15:13.438', 6);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (16, 'Prevents development in areas likely to become inundated or hazard areas.', 1, '2018-10-22 14:15:13.438', '2018-10-22 14:15:13.438', 6);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (17, 'Allows for the same development potential in a community, redirecting development to revitalize urban and mixed-use centers.', 2, '2018-10-22 14:15:13.438', '2018-10-22 14:15:13.438', 6);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (18, 'Protection from wave forces.', 0, '2018-10-22 14:15:13.467', '2018-10-22 14:15:13.467', 7);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (19, 'Can be combined with beach nourishment projects to extend their lifespan.', 1, '2018-10-22 14:15:13.468', '2018-10-22 14:15:13.468', 7);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (20, 'Can be useful to the updrift side of the beach by providing extra sediment through the blockage of longshore sediment transport.', 2, '2018-10-22 14:15:13.469', '2018-10-22 14:15:13.469', 7);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (21, 'Mitigates the harmful effects of jetties and groins on longshore sediment transport by enabling sand to bypass these structures in order to nourish downdrift beaches.', 0, '2018-10-22 14:15:13.485', '2018-10-22 14:15:13.485', 8);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (22, 'Restores sediment supply to coastal resources.', 1, '2018-10-22 14:15:13.487', '2018-10-22 14:15:13.487', 8);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (23, 'Mitigates wave action.', 0, '2018-10-22 14:15:13.524', '2018-10-22 14:15:13.524', 11);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (24, 'Low maintenance.', 1, '2018-10-22 14:15:13.525', '2018-10-22 14:15:13.525', 11);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (25, 'Longterm lifespan.', 2, '2018-10-22 14:15:13.525', '2018-10-22 14:15:13.525', 11);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (26, 'Creates hard structure for non-mobile marine life.', 3, '2018-10-22 14:15:13.526', '2018-10-22 14:15:13.526', 11);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (27, 'Dunes can provide additional habitats, sediment sources, and prevent flooding.', 0, '2018-10-22 14:15:13.542', '2018-10-22 14:15:13.542', 13);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (28, 'Direct physical protection from erosion, but allows continued natural erosion to supply down-drift beaches.', 0, '2018-10-22 14:15:13.554', '2018-10-22 14:15:13.554', 14);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (29, 'Made of biodegradable materials and planted with vegetation, allowing for increased wave energy absorption and preservation of natural habitat value.', 1, '2018-10-22 14:15:13.555', '2018-10-22 14:15:13.555', 14);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (30, 'If planted with a variety of native species, rolls can provide valuable habitat.', 2, '2018-10-22 14:15:13.556', '2018-10-22 14:15:13.556', 14);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (31, 'Provides habitat, ecosystem services and recreational uses. Recreation and tourism benefits through increased fish habitat and shellfish productivity.', 0, '2018-10-22 14:15:13.584', '2018-10-22 14:15:13.584', 17);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (32, 'Dissipates wave energy thus reducing storm surge, erosion and flooding. Slows inland water transfer.', 1, '2018-10-22 14:15:13.585', '2018-10-22 14:15:13.585', 17);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (33, 'Toe protection by structural measure helps prevent wetland edge loss. Becomes more stable over time as plants, roots, and reefs grow.', 2, '2018-10-22 14:15:13.586', '2018-10-22 14:15:13.586', 17);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (34, 'Little post-construction disruption to the surrounding natural environment.', 0, '2018-10-22 14:15:13.611', '2018-10-22 14:15:13.611', 19);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (35, 'Lower environmental impact than structural measures. Can be redesigned with relative ease.', 1, '2018-10-22 14:15:13.613', '2018-10-22 14:15:13.613', 19);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (36, 'Create, restore or bolster habitat for some shorebirds, sea turtles and other flora/fauna.  Preserve beaches for recreational use.', 2, '2018-10-22 14:15:13.614', '2018-10-22 14:15:13.614', 19);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (37, 'In Barnstable County, the County Dredge program provides dredging of municipal waterways at a reduced cost, providing a source of beach compatible sand.', 3, '2018-10-22 14:15:13.615', '2018-10-22 14:15:13.615', 19);


--
-- Data for Name: adaptation_benefits; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.adaptation_benefits (id, name, display_order, inserted_at, updated_at) VALUES (1, 'Habitat', 0, '2018-10-22 14:15:13.248', '2018-10-22 14:15:13.248');
INSERT INTO public.adaptation_benefits (id, name, display_order, inserted_at, updated_at) VALUES (2, 'Water Quality', 1, '2018-10-22 14:15:13.251', '2018-10-22 14:15:13.251');
INSERT INTO public.adaptation_benefits (id, name, display_order, inserted_at, updated_at) VALUES (3, 'Carbon Storage', 2, '2018-10-22 14:15:13.256', '2018-10-22 14:15:13.256');
INSERT INTO public.adaptation_benefits (id, name, display_order, inserted_at, updated_at) VALUES (4, 'Aesthetics', 3, '2018-10-22 14:15:13.258', '2018-10-22 14:15:13.258');
INSERT INTO public.adaptation_benefits (id, name, display_order, inserted_at, updated_at) VALUES (5, 'Flood Mgt.', 4, '2018-10-22 14:15:13.259', '2018-10-22 14:15:13.259');
INSERT INTO public.adaptation_benefits (id, name, display_order, inserted_at, updated_at) VALUES (6, 'Recreation/Tourism', 5, '2018-10-22 14:15:13.261', '2018-10-22 14:15:13.261');


--
-- Data for Name: adaptation_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.adaptation_categories (id, name, description, inserted_at, updated_at, display_order) VALUES (1, 'Protect', NULL, '2018-10-22 14:15:13.222', '2018-10-22 14:15:13.222', 10);
INSERT INTO public.adaptation_categories (id, name, description, inserted_at, updated_at, display_order) VALUES (2, 'Accommodate', NULL, '2018-10-22 14:15:13.232', '2018-10-22 14:15:13.232', 20);
INSERT INTO public.adaptation_categories (id, name, description, inserted_at, updated_at, display_order) VALUES (3, 'Retreat', NULL, '2018-10-22 14:15:13.241', '2018-10-22 14:15:13.241', 30);


--
-- Data for Name: adaptation_disadvantages; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (1, 'Does not address coastal threats.', 0, '2018-10-22 14:15:13.267', '2018-10-22 14:15:13.267', 1);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (2, 'Can result in loss of upland property or changes in habitat type.', 1, '2018-10-22 14:15:13.269', '2018-10-22 14:15:13.269', 1);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (3, 'Dune, beach, or saltmarsh that may be present may be lost if there are structures or topography present that prevent migration with erosion and SLR.', 2, '2018-10-22 14:15:13.27', '2018-10-22 14:15:13.27', 1);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (4, 'Cost to maintain existing infrastructure that may be threatened by hazards.', 2, '2018-10-22 14:15:13.272', '2018-10-22 14:15:13.272', 1);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (5, 'Cost of moving development.', 0, '2018-10-22 14:15:13.372', '2018-10-22 14:15:13.372', 3);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (6, 'Acquisition of land for new development.', 1, '2018-10-22 14:15:13.376', '2018-10-22 14:15:13.376', 3);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (7, 'Loss of coastal property values.', 2, '2018-10-22 14:15:13.377', '2018-10-22 14:15:13.377', 3);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (8, 'TDR may be difficult to set up and administer so it functions as intended.', 0, '2018-10-22 14:15:13.399', '2018-10-22 14:15:13.399', 4);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (9, 'May encourage the development of previously undeveloped inland lands.', 1, '2018-10-22 14:15:13.401', '2018-10-22 14:15:13.401', 4);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (10, 'Limits development along coastline where higher returns on investment are possible.', 2, '2018-10-22 14:15:13.402', '2018-10-22 14:15:13.402', 4);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (11, 'Potential for increased mosquito populations. Potential of increased “salt marsh” smell impacting neighboring properties.', 0, '2018-10-22 14:15:13.422', '2018-10-22 14:15:13.422', 5);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (12, 'Loss of upland as the marsh expands with restored tidal flow. At minimum, short term loss of plants at site immediately after tidal restoration.', 1, '2018-10-22 14:15:13.424', '2018-10-22 14:15:13.424', 5);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (13, 'Potential impacts on coastal public access to water. Potentially higher cost than hard engineering structures.', 2, '2018-10-22 14:15:13.425', '2018-10-22 14:15:13.425', 5);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (14, 'The environmental benefits only apply to the parcel that the rolling conservation easement is on.', 0, '2018-10-22 14:15:13.438', '2018-10-22 14:15:13.438', 6);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (15, 'Perpetual conservation of the land may cause issues regarding development scenarios in the future.', 1, '2018-10-22 14:15:13.438', '2018-10-22 14:15:13.438', 6);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (16, 'Limits ability of property owner to make changes on land.', 2, '2018-10-22 14:15:13.438', '2018-10-22 14:15:13.438', 6);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (17, 'Erosion of adjacent downdrift beaches.', 0, '2018-10-22 14:15:13.462', '2018-10-22 14:15:13.462', 7);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (18, 'Can be detrimental to existing shoreline ecosystem (replaces native substrate with rock and reduces natural habitat availability).', 1, '2018-10-22 14:15:13.465', '2018-10-22 14:15:13.465', 7);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (19, 'No high water protection.', 2, '2018-10-22 14:15:13.466', '2018-10-22 14:15:13.466', 7);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (20, 'Reduces sediment and nutrient input into estuary.', 3, '2018-10-22 14:15:13.466', '2018-10-22 14:15:13.466', 7);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (21, 'Cost of constructing system.', 0, '2018-10-22 14:15:13.482', '2018-10-22 14:15:13.482', 8);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (22, 'Impacts to existing habitat resources associated with beach nourishment.', 1, '2018-10-22 14:15:13.484', '2018-10-22 14:15:13.484', 8);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (23, 'Long term annual costs to construct and maintain system.', 2, '2018-10-22 14:15:13.485', '2018-10-22 14:15:13.485', 8);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (24, 'Loss and fragmentation of intertidal habitat.', 0, '2018-10-22 14:15:13.518', '2018-10-22 14:15:13.518', 11);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (25, 'Erosion of adjacent unreinforced sites.', 1, '2018-10-22 14:15:13.52', '2018-10-22 14:15:13.52', 11);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (26, 'No high water protection.', 2, '2018-10-22 14:15:13.521', '2018-10-22 14:15:13.521', 11);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (27, 'Aesthetic impacts.', 3, '2018-10-22 14:15:13.522', '2018-10-22 14:15:13.522', 11);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (28, 'Reduces longshore sediment transport.', 4, '2018-10-22 14:15:13.523', '2018-10-22 14:15:13.523', 11);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (29, 'Can eliminate dry beach over time if beach nourishment is not required.', 5, '2018-10-22 14:15:13.523', '2018-10-22 14:15:13.523', 11);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (30, 'Can result in changes in habitat type.', 0, '2018-10-22 14:15:13.541', '2018-10-22 14:15:13.541', 13);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (31, 'May have limited recreational value due to limited access.', 1, '2018-10-22 14:15:13.541', '2018-10-22 14:15:13.541', 13);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (32, 'Use of wire and synthetic mesh rolls can be harmful to coastal/marine environments.', 0, '2018-10-22 14:15:13.551', '2018-10-22 14:15:13.551', 14);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (33, 'Potential end scour within 10-feet of the terminus of a fiber roll array should be managed on subject property.', 1, '2018-10-22 14:15:13.552', '2018-10-22 14:15:13.552', 14);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (34, 'Reduces available sediment source for down-drift beaches.', 2, '2018-10-22 14:15:13.553', '2018-10-22 14:15:13.553', 14);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (35, 'No high water protection.', 0, '2018-10-22 14:15:13.581', '2018-10-22 14:15:13.581', 17);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (36, 'Often includes installation of structural elements, which may have negative impacts on sediment supply, boating, recreation, etc. May reduce the commercial/recreational viability of the beach.', 1, '2018-10-22 14:15:13.582', '2018-10-22 14:15:13.582', 17);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (37, 'May be more difficult to permit than more conventional strategies.', 2, '2018-10-22 14:15:13.583', '2018-10-22 14:15:13.583', 17);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (38, 'Requires continual sand resources for renourishment.', 0, '2018-10-22 14:15:13.605', '2018-10-22 14:15:13.605', 19);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (39, 'No high water protection.', 1, '2018-10-22 14:15:13.605', '2018-10-22 14:15:13.605', 19);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (40, 'Can have negative impacts on marine life, beach life, and endangered species (piping plover) during construction and due to higher erosion rates (changing habitat).', 2, '2018-10-22 14:15:13.605', '2018-10-22 14:15:13.605', 19);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (41, 'Expensive (several million dollars depending on the scale).', 3, '2018-10-22 14:15:13.609', '2018-10-22 14:15:13.609', 19);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (42, 'Sediment sources, whether from inland mining, nearshore dredging, or offshore mining, may have adverse environmental effects.', 4, '2018-10-22 14:15:13.61', '2018-10-22 14:15:13.61', 19);


--
-- Data for Name: coastal_hazards; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.coastal_hazards (id, name, description, inserted_at, updated_at, display_order) VALUES (1, 'Erosion', NULL, '2018-10-22 14:15:13.182', '2018-10-22 14:15:13.182', NULL);
INSERT INTO public.coastal_hazards (id, name, description, inserted_at, updated_at, display_order) VALUES (2, 'Storm Surge', NULL, '2018-10-22 14:15:13.201', '2018-10-22 14:15:13.201', NULL);
INSERT INTO public.coastal_hazards (id, name, description, inserted_at, updated_at, display_order) VALUES (3, 'Sea Level Rise', NULL, '2018-10-22 14:15:13.213', '2018-10-22 14:15:13.213', NULL);


--
-- Data for Name: impact_scales; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.impact_scales (id, name, description, impact, inserted_at, updated_at, display_order) VALUES (1, 'Site', NULL, 1, '2018-10-22 14:15:13.146', '2018-10-22 14:15:13.146', NULL);
INSERT INTO public.impact_scales (id, name, description, impact, inserted_at, updated_at, display_order) VALUES (2, 'Neighborhood', NULL, 2, '2018-10-22 14:15:13.169', '2018-10-22 14:15:13.169', NULL);
INSERT INTO public.impact_scales (id, name, description, impact, inserted_at, updated_at, display_order) VALUES (3, 'Community', NULL, 3, '2018-10-22 14:15:13.178', '2018-10-22 14:15:13.178', NULL);
INSERT INTO public.impact_scales (id, name, description, impact, inserted_at, updated_at, display_order) VALUES (4, 'Regional', NULL, 4, '2018-10-22 14:15:13.182', '2018-10-22 14:15:13.182', NULL);


--
-- Data for Name: littoral_cells; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (1, 'Sandy Neck', -70.495195319999993, 41.724435290000002, -70.271945340000002, 41.777071839999998, '2018-10-22 14:15:13.649', '2018-10-22 14:15:13.649', 1, 52, false, 8, 204.0055084, 5.9798193, 7, 130.4343719, 1, 461244800.00, 12.8821297, 4.404603481, 650.0172119, 4021.1875, false, 101);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (2, 'Buttermilk Bay', -70.633527229999999, 41.736539469999997, -70.609278110000005, 41.765290014000001, '2018-10-22 14:15:13.661', '2018-10-22 14:15:13.661', 5, 106, true, 218, 34.2522774, 171.8101501, 4, 55.6946297, 1, 393422600.00, 4.9664421, 25.71430588, 5.9395294, 657.7874146, false, 102);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (3, 'Mashnee', -70.640538980000002, 41.714612780000003, -70.620871019999996, 41.737068870000002, '2018-10-22 14:15:13.665', '2018-10-22 14:15:13.665', 0, 63, false, 21, 20.3502502, 179.1102753, 2, 20.6207943, 0, 301794700.00, 2.939918, 13.06014061, 61.0107536, 476.4459839, false, 103);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (4, 'Monument Beach', -70.637285160000005, 41.70796773, -70.614977600000003, 41.737068870000002, '2018-10-22 14:15:13.667', '2018-10-22 14:15:13.667', 2, 89, true, 8, 26.915144, 95.0147705, 1, 12.8510218, 1, 290605160.00, 3.889698, 11.41208649, 63.1204758, 597.7488403, false, 104);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (5, 'Wings Neck', -70.663056999999995, 41.679642700000002, -70.616675970000003, 41.707978679999997, '2018-10-22 14:15:13.67', '2018-10-22 14:15:13.67', 0, 113, false, 3, 64.2526627, 74.3793411, 2, 31.8369522, 2, 323256020.00, 4.0165191, 9.428860664, 5.8283544, 381.8328247, false, 105);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (6, 'Red Brook Harbor', -70.662388699999994, 41.661195800000002, -70.632819909999995, 41.68116405, '2018-10-22 14:15:13.673', '2018-10-22 14:15:13.673', 0, 73, false, 1, 9.7079134, 271.3979797, 2, 0.0, 0, 217658870.00, 3.7567761, 4.952525139, 2.6752608, 486.3106384, false, 106);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (7, 'Megansett Harbor', -70.654831160000001, 41.637446850000003, -70.619869120000004, 41.664003110000003, '2018-10-22 14:15:13.675', '2018-10-22 14:15:13.675', 4, 191, true, 3, 21.2656403, 283.9780273, 3, 3.3487511, 1, 683448500.00, 4.5419111, 12.91113758, 24.9014893, 459.4194336, false, 107);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (8, 'Old Silver Beach', -70.654231940000003, 41.606726719999997, -70.639767680000006, 41.641907660000001, '2018-10-22 14:15:13.677', '2018-10-22 14:15:13.677', 2, 109, false, 6, 31.3422775, 175.4341583, 11, 2.9746351, 0, 635004300.00, 3.843195, 16.91975403, 30.8582382, 236.6368408, false, 108);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (9, 'Sippewissett', -70.664161329999999, 41.541302250000001, -70.641495169999999, 41.606903799999998, '2018-10-22 14:15:13.679', '2018-10-22 14:15:13.679', 0, 72, false, 0, 95.0317993, 431.8627625, 9, 6.4433169, 0, 582787000.00, 5.3717442, 8.564338684, 66.9046783, 737.499939, false, 109);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (10, 'Woods Hole', -70.688690660000006, 41.51665019, -70.663074300000005, 41.541812219999997, '2018-10-22 14:15:13.681', '2018-10-22 14:15:13.681', 7, 102, true, 110, 3.9876704, 284.7936707, 3, 22.3431664, 1, 626611700.00, 4.9520388, 10.31838799, 0.4507518, 825.6036987, false, 110);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (11, 'Nobska', -70.668310849999997, 41.514311480000003, -70.655190000000005, 41.523292429999998, '2018-10-22 14:15:13.683', '2018-10-22 14:15:13.683', 6, 43, true, 89, 0.4663978, 87.6272888, 1, 4.3100624, 0, 251606300.00, 1.395851, 18.66693115, 3.2719717, 237.9641266, false, 111);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (12, 'South Falmouth', -70.655516890000001, 41.514329189999998, -70.528065830000003, 41.552341149999997, '2018-10-22 14:15:13.685', '2018-10-22 14:15:13.685', 3, 185, true, 28, 38.2330894, 975.5437622, 17, 175.8104095, 0, 1025546449.00, 7.9527521, 13.50438404, 67.3718033, 1746.2563477, false, 112);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (13, 'New Seabury', -70.528079640000001, 41.546571610000001, -70.449744679999995, 41.588077400000003, '2018-10-22 14:15:13.687', '2018-10-22 14:15:13.687', 0, 39, false, 0, 61.836483, 19.7484436, 5, 298.637207, 0, 894116100.00, 5.3732042, 11.50544548, 26.8142071, 1490.3686523, false, 113);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (14, 'Cotuit', -70.45280941, 41.58731796, -70.400938479999994, 41.609039250000002, '2018-10-22 14:15:13.689', '2018-10-22 14:15:13.689', 0, 89, true, 4, 25.401474, 54.628727, 4, 0.8072858, 0, 435699300.00, 3.7948329, 6.853813171, 89.3615646, 1101.5426025, false, 114);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (15, 'Wianno', -70.400956260000001, 41.605766500000001, -70.364380179999998, 41.6221806, '2018-10-22 14:15:13.691', '2018-10-22 14:15:13.691', 0, 104, false, 2, 3.102915, 322.4924316, 2, 33.4862099, 0, 513900700.00, 2.2582591, 11.87512684, 16.1339588, 551.7070923, false, 115);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (16, 'Centerville Harbor', -70.365510999999998, 41.621756320000003, -70.316909589999995, 41.636301510000003, '2018-10-22 14:15:13.692', '2018-10-22 14:15:13.692', 1, 79, false, 4, 99.109169, 191.6327057, 7, 40.852684, 1, 523927500.00, 3.4090099, 11.96304893, 39.8272591, 909.6130371, false, 116);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (17, 'Lewis Bay', -70.317261599999995, 41.60842778, -70.240108090000007, 41.651744409999999, '2018-10-22 14:15:13.694', '2018-10-22 14:15:13.694', 38, 294, true, 115, 137.3874664, 466.7622681, 17, 131.2438965, 2, 1428641000.00, 11.5430002, 18.56052208, 106.2389297, 1913.0593262, false, 117);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (18, 'Nantucket Sound', -70.26578859, 41.608446469999997, -69.981908079999997, 41.67233469, '2018-10-22 14:15:13.697', '2018-10-22 14:15:13.697', 9, 518, true, 70, 380.8373108, 2486.3562012, 51, 490.1095581, 0, 2537257400.00, 17.3015995, 15.66193962, 340.8415222, 4085.7602539, false, 118);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (19, 'Monomoy', -70.015497060000001, 41.539490399999998, -69.941678929999995, 41.672420250000002, '2018-10-22 14:15:13.698', '2018-10-22 14:15:13.698', 1, 10, false, 5, 105.3767395, 560.2143555, 2, 213.083374, 0, 271926400.00, 20.9548302, 0.722238481, 1051.571167, 6738.7255859, true, 119);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (20, 'Chatham Harbor', -69.951523249999994, 41.672034500000002, -69.944336519999993, 41.704417540000001, '2018-10-22 14:15:13.7', '2018-10-22 14:15:13.7', 2, 33, true, 11, 31.2736931, 78.3087082, 5, 21.3441048, 0, 865465800.00, 2.5425341, 17.18111992, 24.9601288, 569.944397, true, 120);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (21, 'Bassing Harbor', -69.973979110000002, 41.703868069999999, -69.944624430000005, 41.721852800000001, '2018-10-22 14:15:13.701', '2018-10-22 14:15:13.701', 0, 32, false, 4, 34.5506363, 361.5568237, 3, 37.4128647, 0, 481869100.00, 3.182462, 9.980096817, 11.1119413, 619.3502197, false, 121);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (22, 'Wequassett', -69.996575980000003, 41.712730710000002, -69.973599469999996, 41.73643113, '2018-10-22 14:15:13.703', '2018-10-22 14:15:13.703', 1, 45, true, 8, 22.9759789, 71.4209671, 9, 152.7987518, 1, 310864000.00, 3.073679, 11.93692398, 8.8877954, 674.5410156, false, 122);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (23, 'Little Pleasant Bay', -69.987729540000004, 41.704136910000003, -69.927629839999994, 41.774281960000003, '2018-10-22 14:15:13.704', '2018-10-22 14:15:13.704', 1, 66, true, 12, 511.4660339, 821.8519897, 7, 470.2912292, 2, 592666250.00, 12.0422802, 5.15602541, 261.1954651, 2852.9833984, true, 123);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (24, 'Nauset', -69.940282339999996, 41.707687249999999, -69.926347719999995, 41.826331490000001, '2018-10-22 14:15:13.706', '2018-10-22 14:15:13.706', 0, 0, false, 22, 243.6255646, 22.5867462, 1, 762.0858154, 0, 130701200.00, 8.6657391, 1.425156593, 487.9051819, 3070.623291, true, 124);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (25, 'Coast Guard Beach', -69.950752940000001, 41.826219999999999, -69.938187580000005, 41.861484259999997, '2018-10-22 14:15:13.708', '2018-10-22 14:15:13.708', 1, 0, false, 9, 23.6465569, 0.0, 3, 0.0, 0, 30923200.00, 2.540206, 2.573147058, 14.4632149, 1053.2125244, true, 125);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (26, 'Marconi', -69.961485589999995, 41.861381649999998, -69.949541749999995, 41.893570339999997, '2018-10-22 14:15:13.709', '2018-10-22 14:15:13.709', 0, 0, false, 6, 0.0, 0.0, 2, 171.526062, 0, 17981400.00, 2.2889249, 2.897997141, 0.0, 967.5145874, true, 126);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (27, 'Outer Cape', -70.248582010000007, 41.893468759999998, -69.960287199999996, 42.083433970000002, '2018-10-22 14:15:13.711', '2018-10-22 14:15:13.711', 0, 8, false, 75, 118.0019379, 12.9466887, 15, 3932.9230957, 0, 171293000.00, 28.6761799, 1.655546427, 1095.5489502, 9952.5556641, true, 127);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (28, 'Provincetown Harbor', -70.198700819999999, 42.023928810000001, -70.166441160000005, 42.046558920000003, '2018-10-22 14:15:13.713', '2018-10-22 14:15:13.713', 4, 50, true, 25, 133.3305054, 140.2750092, 8, 292.7267151, 0, 726006200.00, 3.480684, 11.96743774, 53.2006798, 991.5595093, true, 128);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (29, 'Truro', -70.189771570000005, 41.968132099999998, -70.077125319999993, 42.06217857, '2018-10-22 14:15:13.714', '2018-10-22 14:15:13.714', 15, 144, true, 79, 39.6284142, 1121.4608154, 30, 168.9987946, 0, 2369225100.00, 10.7964802, 17.23412132, 103.8385391, 2721.8625488, true, 129);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (30, 'Bound Brook', -70.078962009999998, 41.943333180000003, -70.076689000000002, 41.968212999999999, '2018-10-22 14:15:13.716', '2018-10-22 14:15:13.716', 0, 0, false, 5, 0.0, 325.9089966, 2, 240.3492889, 0, 70897100.00, 1.72536, 2.774612904, 47.3282356, 755.8833008, true, 130);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (31, 'Great Island', -70.078264610000005, 41.883896399999998, -70.066949750000006, 41.943421489999999, '2018-10-22 14:15:13.718', '2018-10-22 14:15:13.718', 0, 0, false, 0, 106.9666061, 425.5777283, 2, 489.5529175, 0, 15374700.00, 4.1978979, 8.03567028, 68.1362839, 1622.809082, true, 131);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (32, 'Wellfleet Harbor', -70.070769490000004, 41.884116990000003, -70.022969829999994, 41.931489489999997, '2018-10-22 14:15:13.719', '2018-10-22 14:15:13.719', 4, 97, true, 6, 222.3549652, 70.8523407, 10, 624.2570801, 0, 455847300.00, 10.5048399, 6.293058395, 70.2663345, 2528.1630859, true, 132);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (33, 'Blackfish Creek', -70.025521650000002, 41.892498170000003, -70.005875160000002, 41.909796900000003, '2018-10-22 14:15:13.721', '2018-10-22 14:15:13.721', 0, 35, false, 0, 177.3943939, 0.0, 0, 0.6491886, 0, 149123700.00, 2.860405, 4.120303631, 28.9642696, 922.3416748, false, 133);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (34, 'Cape Cod Bay', -70.108763749999994, 41.763042489999997, -70.001422550000001, 41.893207269999998, '2018-10-22 14:15:13.723', '2018-10-22 14:15:13.723', 4, 143, true, 96, 608.8064575, 189.9243622, 41, 201.6305389, 2, 1542971500.00, 13.96208, 10.03118896, 143.90625, 3427.4592285, false, 134);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (35, 'Quivett', -70.181354369999994, 41.751327770000003, -70.108532909999994, 41.764202789999999, '2018-10-22 14:15:13.724', '2018-10-22 14:15:13.724', 4, 36, true, 3, 89.2759476, 9.3302622, 8, 43.7184067, 0, 446347420.00, 4.1774969, 8.187264442, 79.331604, 673.1985474, false, 135);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (36, 'Barnstable Harbor', -70.352559889999995, 41.708378570000001, -70.181124679999996, 41.753029830000003, '2018-10-22 14:15:13.726', '2018-10-22 14:15:13.726', 8, 98, true, 27, 1256.4754639, 37.4771461, 11, 87.6455841, 3, 974675740.00, 16.4632301, 5.641637325, 319.9433594, 4614.3808594, false, 136);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (37, 'Sagamore', -70.537776390000005, 41.776631440000003, -70.493277500000005, 41.811147099999999, '2018-10-22 14:15:13.728', '2018-10-22 14:15:13.728', 0, 33, false, 8, 0.0, 5.9798193, 2, 138.4368439, 0, 255135300.00, 3.3053861, 10.14210987, 58.2020454, 960.220459, false, 137);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627200200, '2018-10-22 14:15:11.055');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627200743, '2018-10-22 14:15:11.114');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627201108, '2018-10-22 14:15:11.172');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627203452, '2018-10-22 14:15:11.238');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627211906, '2018-10-22 14:15:11.273');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627212047, '2018-10-22 14:15:11.309');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627212147, '2018-10-22 14:15:11.343');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180703202705, '2018-10-22 14:15:11.369');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180703204221, '2018-10-22 14:15:11.393');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180703204303, '2018-10-22 14:15:11.417');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180703205219, '2018-10-22 14:15:11.438');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180705210332, '2018-10-22 14:15:11.521');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180718180304, '2018-10-22 14:15:11.569');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180726173204, '2018-10-22 14:15:11.593');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180727193446, '2018-10-22 14:15:11.624');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180727194146, '2018-10-22 14:15:11.645');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807203920, '2018-10-22 14:15:11.666');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807203940, '2018-10-22 14:15:11.688');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807203956, '2018-10-22 14:15:11.71');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807204011, '2018-10-22 14:15:11.729');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807204026, '2018-10-22 14:15:11.751');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807204040, '2018-10-22 14:15:11.771');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807204054, '2018-10-22 14:15:11.792');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807204115, '2018-10-22 14:15:11.816');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807204132, '2018-10-22 14:15:11.834');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807204145, '2018-10-22 14:15:11.86');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180808140524, '2018-10-22 14:15:11.883');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180808140539, '2018-10-22 14:15:11.901');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180820140003, '2018-10-22 14:15:11.947');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180820140128, '2018-10-22 14:15:11.975');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180823192847, '2018-10-22 14:15:11.996');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180823192901, '2018-10-22 14:15:12.017');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180823192913, '2018-10-22 14:15:12.046');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180919153922, '2018-10-22 14:15:12.093');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180919154827, '2018-10-22 14:15:12.205');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180920142818, '2018-10-22 14:15:12.241');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180920145129, '2018-10-22 14:15:12.278');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180920213425, '2018-10-22 14:15:12.305');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180921142315, '2018-10-22 14:15:12.341');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180921143254, '2018-10-22 14:15:12.364');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180926153705, '2018-10-22 14:15:12.385');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20181021224755, '2018-10-22 14:15:12.408');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20181021230621, '2018-10-22 14:15:12.43');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20181021230849, '2018-10-22 14:15:12.453');


--
-- Data for Name: strategies_benefits; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (1, 1);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (1, 4);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (1, 6);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (3, 1);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (3, 2);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (3, 3);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (3, 4);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (3, 5);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (3, 6);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (4, 1);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (4, 2);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (4, 3);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (4, 4);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (4, 5);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (4, 6);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (5, 1);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (5, 2);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (5, 3);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (5, 4);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (5, 5);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (5, 6);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (6, 1);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (6, 2);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (6, 3);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (6, 4);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (6, 5);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (7, 1);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (7, 6);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (8, 1);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (8, 4);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (8, 5);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (8, 6);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (11, 1);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (11, 5);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (13, 1);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (13, 4);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (13, 5);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (14, 1);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (14, 3);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (14, 5);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (17, 1);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (17, 2);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (17, 3);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (17, 4);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (17, 5);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (17, 6);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (19, 1);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (19, 4);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (19, 5);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (19, 6);


--
-- Data for Name: strategies_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (1, 3);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (2, 3);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (3, 3);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (4, 3);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (5, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (5, 2);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (6, 3);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (7, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (8, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (9, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (9, 3);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (10, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (11, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (12, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (13, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (13, 2);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (14, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (15, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (16, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (17, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (18, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (19, 1);
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (19, 2);


--
-- Data for Name: strategies_hazards; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (1, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (1, 2);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (1, 3);
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
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (5, 2);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (5, 3);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (6, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (6, 2);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (6, 3);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (7, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (8, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (9, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (9, 2);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (9, 3);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (10, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (10, 2);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (10, 3);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (11, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (11, 2);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (12, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (13, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (13, 2);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (13, 3);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (14, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (14, 2);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (15, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (15, 2);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (16, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (16, 2);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (17, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (17, 2);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (18, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (18, 2);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (19, 1);
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (19, 3);


--
-- Data for Name: strategies_scales; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (1, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (1, 3);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (1, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (1, 4);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (2, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (3, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (3, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (3, 3);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (3, 4);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (4, 3);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (5, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (5, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (6, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (6, 3);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (7, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (7, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (8, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (9, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (9, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (9, 3);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (9, 4);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (10, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (10, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (11, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (11, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (12, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (12, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (13, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (14, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (14, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (15, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (15, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (16, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (16, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (17, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (17, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (18, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (18, 2);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (19, 1);
INSERT INTO public.strategies_scales (strategy_id, scale_id) VALUES (19, 2);


--
-- Name: adaptation_advantages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adaptation_advantages_id_seq', 37, true);


--
-- Name: adaptation_benefits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adaptation_benefits_id_seq', 6, true);


--
-- Name: adaptation_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adaptation_categories_id_seq', 3, true);


--
-- Name: adaptation_disadvantages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adaptation_disadvantages_id_seq', 42, true);


--
-- Name: adaptation_strategies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adaptation_strategies_id_seq', 19, true);


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

