--
-- PostgreSQL database dump
--

-- Dumped from database version 10.6 (Ubuntu 10.6-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.6 (Ubuntu 10.6-0ubuntu0.18.04.1)

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

INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement, beach_width_impact_m, applicability) VALUES (1, 'No Action', 'Take no action to address changes in the coast. Effects of erosion, SLR, and flooding will continue or intensify. Depending on conditions, coastal resources may not migrate naturally where steep topography or preexisting coastal erosion control structures are present. Structures or facilities may be threatened or undermined.', '2019-04-02 14:27:16.36346', '2019-04-02 14:27:16.363468', NULL, true, NULL, 'anywhere', NULL, 'test1');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement, beach_width_impact_m, applicability) VALUES (2, 'Undevelopment', 'Removing development from an existing location by land purchase or land donation, flood insurance buy-out programs, or other means. In the case of managed relocation, development and infrastructure are moved away from the coastline and out of harms way.', '2019-04-02 14:27:16.438838', '2019-04-02 14:27:16.43886', NULL, true, 'MEPA, Chapter 91, DEP Water quality, MESA, CZM consistency review, USACE, local Conservation Commission review, others', 'anywhere', 9.14400000000000013, 'test2');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement, beach_width_impact_m, applicability) VALUES (3, 'Managed Relocation', 'Gradually moving development and infrastructure away from the coastline and areas of projected loss due to flooding and sea level rise.', '2019-04-02 14:27:16.471863', '2019-04-02 14:27:16.471928', NULL, false, 'Various local and state permits may be required.', NULL, NULL, 'test3');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement, beach_width_impact_m, applicability) VALUES (4, 'Transfer of Development Credit/Transferable Development Rights', 'Land use mechanism that encourages the permanent removal of development rights in defined “sending” districts, and allows those rights to be transferred to defined “receiving” districts.', '2019-04-02 14:27:16.505477', '2019-04-02 14:27:16.505488', NULL, false, 'Local bylaws allowing for Transfer of Development Rights must be in place.', NULL, NULL, 'test4');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement, beach_width_impact_m, applicability) VALUES (5, 'Tidal Wetland and Floodplain Restoration or Creation', 'Protecting, restoring, and creating coastal habitats within the floodplain as a buffer to storm surges and sea level rise to provide natural flood protection.', '2019-04-02 14:27:16.530748', '2019-04-02 14:27:16.530762', NULL, false, 'Various local, state, and federal permits required depending on scope and location of project.', NULL, NULL, 'test5');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement, beach_width_impact_m, applicability) VALUES (6, 'Rolling Conservation Easements', 'Private property owners sell or otherwise transfer rights in these portions of their land abutting an eroding coastline.  Rolling easements allow for limited development of upland areas of the property, and restrict development and/or the construction of erosion control structures along the shoreline.', '2019-04-02 14:27:16.55567', '2019-04-02 14:27:16.555683', NULL, false, 'Local Conservation Commission approval; Conservation easements must be approved by the municipality involved.', NULL, NULL, 'test6');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement, beach_width_impact_m, applicability) VALUES (7, 'Groin', 'A hard structure projecting perpendicular from the shoreline. Designed to intercept water flow and sand moving parallel to the shoreline to prevent beach erosion, retain beach sand, and break waves.', '2019-04-02 14:27:16.580637', '2019-04-02 14:27:16.580649', NULL, false, 'Various local, state, and federal permits required.  New groins are infrequently permitted due to impacts.', NULL, NULL, 'test7');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement, beach_width_impact_m, applicability) VALUES (8, 'Sand Bypass System', 'Where a jetty or groin has interrupted the flow of sediment along the beach, sand may be moved hydraulically or mechanically from the accreting updrift side of an inlet to the eroding down-drift side.', '2019-04-02 14:27:16.605626', '2019-04-02 14:27:16.605636', NULL, false, 'Various local, state, and federal permits required depending on scope and location of project.', NULL, NULL, 'test8');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement, beach_width_impact_m, applicability) VALUES (9, 'Open Space Protection', 'Town, land trust or private entity purchasing or donating land to limit or prevent development at that site to maintain open space and preserve the natural defense system.', '2019-04-02 14:27:16.630788', '2019-04-02 14:27:16.6308', NULL, true, 'Typically, there are no permitting requirements.', 'undeveloped_only', 1, 'test9');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement, beach_width_impact_m, applicability) VALUES (10, 'Salt Marsh Restoration', 'Protecting, restoring, and creating salt marsh as a buffer to storm surges and sea level rise to provide natural flood protection.', '2019-04-02 14:27:16.664061', '2019-04-02 14:27:16.664071', NULL, true, 'Various local, state, and federal permits required depending on scope and location of project.', 'anywhere', 9.14400000000000013, 'test10');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement, beach_width_impact_m, applicability) VALUES (11, 'Revetment', 'Sloped piles of boulders constructed along eroding coastal banks designed to intercept wave energy and decrease erosion.', '2019-04-02 14:27:16.697222', '2019-04-02 14:27:16.697234', NULL, true, 'Various local, state, and federal permits required.', 'coastal_bank_only', 3.04800000000000004, 'test11');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement, beach_width_impact_m, applicability) VALUES (12, 'Seawalls', 'Structures built parallel to the shore with vertical or sloped walls (typically smooth) to reinforce the shoreline against forces of wave action and erosion.', '2019-04-02 14:27:16.714113', '2019-04-02 14:27:16.714136', NULL, false, NULL, 'coastal_bank_only', 3.04800000000000004, 'test12');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement, beach_width_impact_m, applicability) VALUES (13, 'Dune Creation', 'Creating additional or new dunes to protect the shoreline against erosion and flooding.', '2019-04-02 14:27:16.722243', '2019-04-02 14:27:16.722252', NULL, true, 'Various local and state permits may be required.', 'anywhere_but_salt_marsh', 9.14400000000000013, 'test13');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement, beach_width_impact_m, applicability) VALUES (14, 'Bank Stabilization', 'Cylindrical rolls, 12-20 inches in diameter & 10-20 feet long, made of coir (coconut) fiber held together by a fiber mesh, covered with sand, and are planted with salt-tolerant vegetation with extensive root systems. These reinforced banks act as physical barriers to waves, tides, and currents. They typically disintegrate over 5-7 years to allow plants time to grow their root systems to keep sand and soil in place.', '2019-04-02 14:27:16.738859', '2019-04-02 14:27:16.738868', NULL, true, 'Local and state permits required, potentially federal permits depending on location.', 'coastal_bank_only', 3.04800000000000004, 'test14');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement, beach_width_impact_m, applicability) VALUES (15, 'Bank Stabilization: Coir Envelopes', 'Envelopes are constructed of coir (coconut fiber) fabric and are filled with local sand. The envelopes are placed in terraces along the beach, are typically covered with sand, and may also be planted with native vegetation to hold sand together and absorb water.', '2019-04-02 14:27:16.755465', '2019-04-02 14:27:16.755473', NULL, false, NULL, 'coastal_bank_only', 3.04800000000000004, 'test15');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement, beach_width_impact_m, applicability) VALUES (16, 'Living Shoreline: Vegetation Only', 'Shoreline stabilization techniques along estuarine coasts, bays, sheltered coastlines, and tributaries. A living shoreline has a footprint that is made up mostly of native material. It incorporates vegetation or other living, natural "soft" elements alone or in combination with some other type of harder shoreline structures (e.g. oyster reefs or rock sills) for added stability. Using vegetation alone is one approach. Roots hold soil in place to reduce erosion. Provides a buffer to upload areas and breaks small waves.', '2019-04-02 14:27:16.763831', '2019-04-02 14:27:16.763839', NULL, false, NULL, 'anywhere_but_salt_marsh', 9.14400000000000013, 'test16');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement, beach_width_impact_m, applicability) VALUES (17, 'Living Shoreline', 'A living shoreline has a footprint that is made up mostly of native material.  It incorporates vegetation or other living, natural “soft” elements alone or in combination with some other type of harder shoreline structure (e.g. oyster reefs or rock sills) for added stability. A combined approach integrates living components, such as plantings, with strategically placed structural elements, such as sills, revetments, and breakwaters.', '2019-04-02 14:27:16.772454', '2019-04-02 14:27:16.772465', NULL, true, 'Various local, state, and federal permits required depending on scope and location of project.', 'anywhere_but_salt_marsh', 9.14400000000000013, 'test17');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement, beach_width_impact_m, applicability) VALUES (18, 'Living Shoreline: Living Breakwater/Oyster Reefs', 'Shoreline stabilization techniques along estuarine coasts, bays, sheltered coastlines, and tributaries. A living shoreline has a footprint that is made
            up mostly of native material. It incorporates vegetation or other living, natural "soft" elements alone or in combination with some other type of harder shoreline structures (e.g. oyster reefs or rock sills) for added stability. Restoring or creating oyster reefs or reef balls to serve as natural breakwaters, attenuate wave energy, and slow inland water transfer.', '2019-04-02 14:27:16.797547', '2019-04-02 14:27:16.797559', NULL, false, NULL, 'anywhere_but_salt_marsh', 9.14400000000000013, 'test18');
INSERT INTO public.adaptation_strategies (id, name, description, inserted_at, updated_at, display_order, is_active, currently_permittable, strategy_placement, beach_width_impact_m, applicability) VALUES (19, 'Beach Nourishment', 'The process of adding sediment to an eroding beach to widen the beach and advance the shoreline seaward. Sources for sediment include inland mining, nearshore dredging including for navigation projects, and offshore mining.', '2019-04-02 14:27:16.814211', '2019-04-02 14:27:16.814226', NULL, true, 'Various local, state, and federal permits required depending on scope and location of project.', 'anywhere_but_salt_marsh', 9.14400000000000013, 'test19');


--
-- Data for Name: adaptation_advantages; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (1, 'Allows natural erosion and sediment processes to occur.', 0, '2019-04-02 14:27:16.374111', '2019-04-02 14:27:16.374123', 1);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (2, 'Natural migration of resource areas and landforms may occur providing benefits to the environment and humans.', 1, '2019-04-02 14:27:16.375822', '2019-04-02 14:27:16.375834', 1);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (3, 'Continued recreational access (depending on conditions).', 2, '2019-04-02 14:27:16.377205', '2019-04-02 14:27:16.377214', 1);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (4, 'Land donation can provide a tax benefit to the private property owner.', 0, '2019-04-02 14:27:16.449989', '2019-04-02 14:27:16.45', 2);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (5, 'Reduces danger and potential economic effects of erosion or flooding events.', 1, '2019-04-02 14:27:16.451221', '2019-04-02 14:27:16.451232', 2);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (6, 'Reduces use and maintenance costs of coastal defense structures.', 2, '2019-04-02 14:27:16.452333', '2019-04-02 14:27:16.452344', 2);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (7, 'Spares existing development that is moved from the effects of erosion and flooding.', 3, '2019-04-02 14:27:16.453398', '2019-04-02 14:27:16.453408', 2);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (8, 'Protects future development from risks of flooding.', 4, '2019-04-02 14:27:16.454472', '2019-04-02 14:27:16.454484', 2);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (9, 'Relieves impacts of structural measures on adjacent unarmored areas.', 5, '2019-04-02 14:27:16.455453', '2019-04-02 14:27:16.455464', 2);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (10, 'Allows for the maintenance or restoration of intertidal or upland habitat providing carbon storage, recreation and ecostourism and improved water quality benefits to the community.', 6, '2019-04-02 14:27:16.456401', '2019-04-02 14:27:16.456413', 2);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (11, 'Spares existing development from the effects of erosion and flooding.', 0, '2019-04-02 14:27:16.477014', '2019-04-02 14:27:16.477025', 3);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (12, 'Protects future development from flooding.', 1, '2019-04-02 14:27:16.478215', '2019-04-02 14:27:16.478226', 3);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (13, 'Allows for the maintenance or restoration of intertidal habitat.', 2, '2019-04-02 14:27:16.479063', '2019-04-02 14:27:16.479072', 3);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (14, 'Conserves undisturbed areas that may serve as habitat or flood buffers.', 0, '2019-04-02 14:27:16.510543', '2019-04-02 14:27:16.510554', 4);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (15, 'Prevents development in areas likely to become inundated or hazard areas.', 1, '2019-04-02 14:27:16.511502', '2019-04-02 14:27:16.511513', 4);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (16, 'Allows for the same development potential in a community, redirecting development to revitalize urban and mixed-use centers.', 2, '2019-04-02 14:27:16.512286', '2019-04-02 14:27:16.512297', 4);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (17, 'Serve as  buffers for coastal areas against storm and wave damage.', 0, '2019-04-02 14:27:16.536084', '2019-04-02 14:27:16.536096', 5);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (18, 'Wave attenuation and/or dissipation.', 1, '2019-04-02 14:27:16.537534', '2019-04-02 14:27:16.537547', 5);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (19, 'Stabilize coastal shorelines to reduce or prevent erosion. Reduces or eliminates the need for hard engineered structures.', 2, '2019-04-02 14:27:16.538593', '2019-04-02 14:27:16.538602', 5);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (20, 'Improve water quality through filtering, storing, and breaking down pollutants.', 3, '2019-04-02 14:27:16.539411', '2019-04-02 14:27:16.53942', 5);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (21, 'Reduce flooding of upland areas and nearby infrastructure by reducing duration and extent of floodwater.', 4, '2019-04-02 14:27:16.540195', '2019-04-02 14:27:16.540204', 5);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (22, 'Conserves undisturbed areas that may serve as habitat or flood buffers.', 0, '2019-04-02 14:27:16.560781', '2019-04-02 14:27:16.560791', 6);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (23, 'Prevents development in areas likely to become inundated or hazard areas.', 1, '2019-04-02 14:27:16.561876', '2019-04-02 14:27:16.561888', 6);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (24, 'Allows for the same development potential in a community, redirecting development to revitalize urban and mixed-use centers.', 2, '2019-04-02 14:27:16.562841', '2019-04-02 14:27:16.562852', 6);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (25, 'Protection from wave forces.', 0, '2019-04-02 14:27:16.587329', '2019-04-02 14:27:16.587341', 7);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (26, 'Can be combined with beach nourishment projects to extend their lifespan.', 1, '2019-04-02 14:27:16.588602', '2019-04-02 14:27:16.588613', 7);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (27, 'Can be useful to the updrift side of the beach by providing extra sediment through the blockage of longshore sediment transport.', 2, '2019-04-02 14:27:16.589533', '2019-04-02 14:27:16.589544', 7);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (28, 'Mitigates the harmful effects of jetties and groins on longshore sediment transport by enabling sand to bypass these structures in order to nourish downdrift beaches.', 0, '2019-04-02 14:27:16.611324', '2019-04-02 14:27:16.611337', 8);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (29, 'Restores sediment supply to coastal resources.', 1, '2019-04-02 14:27:16.6128', '2019-04-02 14:27:16.612822', 8);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (30, 'Land donation can provide a tax benefit to the private property owner.', 0, '2019-04-02 14:27:16.639714', '2019-04-02 14:27:16.639724', 9);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (31, 'Infrastructure won''t need to be relocated/removed when the sea rises and threatens low-lying infrastructure located in the floodplain.', 1, '2019-04-02 14:27:16.641434', '2019-04-02 14:27:16.641444', 9);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (32, 'Sellers still get to own their property when they sell their development rights.', 2, '2019-04-02 14:27:16.642301', '2019-04-02 14:27:16.64231', 9);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (33, 'Reduced opportunity for damages (costs) and repetitive losses from flooding.', 3, '2019-04-02 14:27:16.643004', '2019-04-02 14:27:16.643012', 9);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (34, 'Can be used to prohibit shoreline armoring on private property.', 4, '2019-04-02 14:27:16.643836', '2019-04-02 14:27:16.643845', 9);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (35, 'Neighboring property can receive an increase in value due to abutting open space.', 5, '2019-04-02 14:27:16.64467', '2019-04-02 14:27:16.64468', 9);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (36, 'Improves habitat, carbon storage, recreation and ecotourism, and water quality.', 6, '2019-04-02 14:27:16.645538', '2019-04-02 14:27:16.645547', 9);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (37, 'Stabilize coastal shorelines to reduce or prevent erosion. Reduces or eliminates the need for hard engineered structures.', 0, '2019-04-02 14:27:16.669426', '2019-04-02 14:27:16.669437', 10);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (38, 'Serve as buffers for coastal areas against storm and wave damage.', 1, '2019-04-02 14:27:16.670648', '2019-04-02 14:27:16.670659', 10);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (39, 'Wave attenuation and/or dissipation.', 2, '2019-04-02 14:27:16.671611', '2019-04-02 14:27:16.671622', 10);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (40, 'Improve water quality through filtering, storing, and breaking down pollutants.', 3, '2019-04-02 14:27:16.672538', '2019-04-02 14:27:16.672549', 10);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (41, 'Reduce flooding of upland areas and nearby infrastructure by reducing duration and extent of floodwater.', 4, '2019-04-02 14:27:16.673595', '2019-04-02 14:27:16.673606', 10);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (42, 'Mitigates wave action.', 0, '2019-04-02 14:27:16.702242', '2019-04-02 14:27:16.70225', 11);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (43, 'Low maintenance.', 1, '2019-04-02 14:27:16.702981', '2019-04-02 14:27:16.70299', 11);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (44, 'Longterm lifespan.', 2, '2019-04-02 14:27:16.703684', '2019-04-02 14:27:16.703693', 11);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (45, 'Creates hard structure for non-mobile marine life.', 3, '2019-04-02 14:27:16.7044', '2019-04-02 14:27:16.704409', 11);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (46, 'Dunes can provide additional habitats, sediment sources, and prevent flooding.', 0, '2019-04-02 14:27:16.725061', '2019-04-02 14:27:16.725071', 13);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (47, 'Direct physical protection from erosion, but allows continued natural erosion to supply down-drift beaches.', 0, '2019-04-02 14:27:16.742077', '2019-04-02 14:27:16.742085', 14);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (48, 'Made of biodegradable materials and planted with vegetation, allowing for increased wave energy absorption and preservation of natural habitat value.', 1, '2019-04-02 14:27:16.742749', '2019-04-02 14:27:16.742756', 14);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (49, 'If planted with a variety of native species, rolls can provide valuable habitat.', 2, '2019-04-02 14:27:16.743623', '2019-04-02 14:27:16.743636', 14);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (50, 'Provides habitat, ecosystem services and recreational uses. Recreation and tourism benefits through increased fish habitat and shellfish productivity.', 0, '2019-04-02 14:27:16.776851', '2019-04-02 14:27:16.776872', 17);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (51, 'Dissipates wave energy thus reducing storm surge, erosion and flooding. Slows inland water transfer.', 1, '2019-04-02 14:27:16.777835', '2019-04-02 14:27:16.777847', 17);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (52, 'Toe protection by structural measure helps prevent wetland edge loss. Becomes more stable over time as plants, roots, and reefs grow.', 2, '2019-04-02 14:27:16.778714', '2019-04-02 14:27:16.778768', 17);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (53, 'Little post-construction disruption to the surrounding natural environment.', 0, '2019-04-02 14:27:16.822575', '2019-04-02 14:27:16.822587', 19);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (54, 'Lower environmental impact than structural measures. Can be redesigned with relative ease.', 1, '2019-04-02 14:27:16.823441', '2019-04-02 14:27:16.823453', 19);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (55, 'Create, restore or bolster habitat for some shorebirds, sea turtles and other flora/fauna.  Preserve beaches for recreational use.', 2, '2019-04-02 14:27:16.824303', '2019-04-02 14:27:16.824316', 19);
INSERT INTO public.adaptation_advantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (56, 'In Barnstable County, the County Dredge program provides dredging of municipal waterways at a reduced cost, providing a source of beach compatible sand.', 3, '2019-04-02 14:27:16.825381', '2019-04-02 14:27:16.825393', 19);


--
-- Data for Name: adaptation_benefits; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.adaptation_benefits (id, name, display_order, inserted_at, updated_at) VALUES (1, 'Habitat', 0, '2019-04-02 14:27:16.313436', '2019-04-02 14:27:16.313444');
INSERT INTO public.adaptation_benefits (id, name, display_order, inserted_at, updated_at) VALUES (2, 'Water Quality', 1, '2019-04-02 14:27:16.321857', '2019-04-02 14:27:16.321865');
INSERT INTO public.adaptation_benefits (id, name, display_order, inserted_at, updated_at) VALUES (3, 'Carbon Storage', 2, '2019-04-02 14:27:16.330386', '2019-04-02 14:27:16.330394');
INSERT INTO public.adaptation_benefits (id, name, display_order, inserted_at, updated_at) VALUES (4, 'Aesthetics', 3, '2019-04-02 14:27:16.33872', '2019-04-02 14:27:16.338731');
INSERT INTO public.adaptation_benefits (id, name, display_order, inserted_at, updated_at) VALUES (5, 'Flood Mgt.', 4, '2019-04-02 14:27:16.346948', '2019-04-02 14:27:16.346959');
INSERT INTO public.adaptation_benefits (id, name, display_order, inserted_at, updated_at) VALUES (6, 'Recreation / Tourism', 5, '2019-04-02 14:27:16.355478', '2019-04-02 14:27:16.355492');


--
-- Data for Name: adaptation_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.adaptation_categories (id, name, description, inserted_at, updated_at, display_order) VALUES (1, 'Protect', NULL, '2019-04-02 14:27:16.288493', '2019-04-02 14:27:16.2885', 10);
INSERT INTO public.adaptation_categories (id, name, description, inserted_at, updated_at, display_order) VALUES (2, 'Accommodate', NULL, '2019-04-02 14:27:16.296749', '2019-04-02 14:27:16.296756', 20);
INSERT INTO public.adaptation_categories (id, name, description, inserted_at, updated_at, display_order) VALUES (3, 'Retreat', NULL, '2019-04-02 14:27:16.305108', '2019-04-02 14:27:16.305115', 30);


--
-- Data for Name: adaptation_disadvantages; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (1, 'Does not address coastal threats.', 0, '2019-04-02 14:27:16.367748', '2019-04-02 14:27:16.367759', 1);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (2, 'Can result in loss of upland property or changes in habitat type.', 1, '2019-04-02 14:27:16.370214', '2019-04-02 14:27:16.370228', 1);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (3, 'Dune, beach, or saltmarsh that may be present may be lost if there are structures or topography present that prevent migration with erosion and SLR.', 2, '2019-04-02 14:27:16.371462', '2019-04-02 14:27:16.371476', 1);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (4, 'Cost to maintain existing infrastructure that may be threatened by hazards.', 2, '2019-04-02 14:27:16.37282', '2019-04-02 14:27:16.372834', 1);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (5, 'Fee simple acquisition of coastal properties is expensive.', 0, '2019-04-02 14:27:16.440706', '2019-04-02 14:27:16.440726', 2);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (6, 'Requires advance planning and technical studies to evaluate potential impacts on adjacent areas.', 1, '2019-04-02 14:27:16.442956', '2019-04-02 14:27:16.442963', 2);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (7, 'May require large scale planning to relocate whole area impacted by erosion or flooding.', 2, '2019-04-02 14:27:16.444086', '2019-04-02 14:27:16.444106', 2);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (8, 'Environmental and/or economic effects of losing valuable land to the sea, including loss or transfer of coastal property values and tax income for the community.', 3, '2019-04-02 14:27:16.445259', '2019-04-02 14:27:16.445273', 2);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (9, 'Cost of relocating or removing defense structures and any existing infrastructure.', 4, '2019-04-02 14:27:16.446592', '2019-04-02 14:27:16.446616', 2);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (10, 'Can expose neighboring infrastructure and inland communities to flooding or erosion.', 5, '2019-04-02 14:27:16.447657', '2019-04-02 14:27:16.447669', 2);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (11, 'May create the need to build new inland coastal defense structures.', 6, '2019-04-02 14:27:16.448982', '2019-04-02 14:27:16.448994', 2);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (12, 'Cost of moving development.', 0, '2019-04-02 14:27:16.473357', '2019-04-02 14:27:16.473369', 3);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (13, 'Acquisition of land for new development.', 1, '2019-04-02 14:27:16.475059', '2019-04-02 14:27:16.475072', 3);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (14, 'Loss of coastal property values.', 2, '2019-04-02 14:27:16.476087', '2019-04-02 14:27:16.476098', 3);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (15, 'TDR may be difficult to set up and administer so it functions as intended.', 0, '2019-04-02 14:27:16.506791', '2019-04-02 14:27:16.506799', 4);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (16, 'May encourage the development of previously undeveloped inland lands.', 1, '2019-04-02 14:27:16.508387', '2019-04-02 14:27:16.508395', 4);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (17, 'Limits development along coastline where higher returns on investment are possible.', 2, '2019-04-02 14:27:16.509629', '2019-04-02 14:27:16.509641', 4);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (18, 'Potential for increased mosquito populations. Potential of increased “salt marsh” smell impacting neighboring properties.', 0, '2019-04-02 14:27:16.532167', '2019-04-02 14:27:16.53218', 5);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (19, 'Loss of upland as the marsh expands with restored tidal flow. At minimum, short term loss of plants at site immediately after tidal restoration.', 1, '2019-04-02 14:27:16.533942', '2019-04-02 14:27:16.533955', 5);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (20, 'Potential impacts on coastal public access to water. Potentially higher cost than hard engineering structures.', 2, '2019-04-02 14:27:16.535031', '2019-04-02 14:27:16.535043', 5);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (21, 'The environmental benefits only apply to the parcel that the rolling conservation easement is on.', 0, '2019-04-02 14:27:16.557286', '2019-04-02 14:27:16.557296', 6);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (22, 'Perpetual conservation of the land may cause issues regarding development scenarios in the future.', 1, '2019-04-02 14:27:16.55891', '2019-04-02 14:27:16.55892', 6);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (23, 'Limits ability of property owner to make changes on land.', 2, '2019-04-02 14:27:16.559934', '2019-04-02 14:27:16.559943', 6);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (24, 'Erosion of adjacent downdrift beaches.', 0, '2019-04-02 14:27:16.582241', '2019-04-02 14:27:16.582254', 7);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (25, 'Can be detrimental to existing shoreline ecosystem (replaces native substrate with rock and reduces natural habitat availability).', 1, '2019-04-02 14:27:16.583989', '2019-04-02 14:27:16.584002', 7);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (26, 'No high water protection.', 2, '2019-04-02 14:27:16.585257', '2019-04-02 14:27:16.58527', 7);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (27, 'Reduces sediment and nutrient input into estuary.', 3, '2019-04-02 14:27:16.58627', '2019-04-02 14:27:16.586282', 7);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (28, 'Cost of constructing system.', 0, '2019-04-02 14:27:16.607171', '2019-04-02 14:27:16.607184', 8);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (29, 'Impacts to existing habitat resources associated with beach nourishment.', 1, '2019-04-02 14:27:16.608989', '2019-04-02 14:27:16.609013', 8);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (30, 'Long term annual costs to construct and maintain system.', 2, '2019-04-02 14:27:16.610188', '2019-04-02 14:27:16.610212', 8);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (31, 'Fee simple acquisition of coastal properties is expensive.', 0, '2019-04-02 14:27:16.632377', '2019-04-02 14:27:16.63239', 9);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (32, 'The property will lose value as the "highest and best use" of the property (developed) is lost.', 1, '2019-04-02 14:27:16.634352', '2019-04-02 14:27:16.634363', 9);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (33, 'Loss of tax income for town/state.', 2, '2019-04-02 14:27:16.635657', '2019-04-02 14:27:16.635669', 9);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (34, 'Perpetual conservation of the land may cause issues regarding development scenarios in the distant future.', 3, '2019-04-02 14:27:16.636984', '2019-04-02 14:27:16.637007', 9);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (35, 'May encourage the development of previously undeveloped inland lands, instead of encouraging more dense development in previously-developed inland lands.', 4, '2019-04-02 14:27:16.638351', '2019-04-02 14:27:16.638361', 9);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (36, 'Potential for increased mosquito populations. Potential of increased “salt marsh” smell impacting neighboring properties.', 0, '2019-04-02 14:27:16.665681', '2019-04-02 14:27:16.665694', 10);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (37, 'Loss of upland as the marsh expands with restored tidal flow. At minimum, short term loss of plants at site immediately after tidal restoration.', 1, '2019-04-02 14:27:16.667396', '2019-04-02 14:27:16.667408', 10);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (38, 'Potential impacts on coastal public access to water. Potentially higher cost than hard engineering structures.', 2, '2019-04-02 14:27:16.668463', '2019-04-02 14:27:16.668475', 10);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (39, 'Loss and fragmentation of intertidal habitat.', 0, '2019-04-02 14:27:16.698002', '2019-04-02 14:27:16.69801', 11);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (40, 'Erosion of adjacent unreinforced sites.', 1, '2019-04-02 14:27:16.698647', '2019-04-02 14:27:16.698654', 11);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (41, 'No high water protection.', 2, '2019-04-02 14:27:16.699583', '2019-04-02 14:27:16.699592', 11);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (42, 'Aesthetic impacts.', 3, '2019-04-02 14:27:16.700306', '2019-04-02 14:27:16.700315', 11);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (43, 'Reduces longshore sediment transport.', 4, '2019-04-02 14:27:16.700959', '2019-04-02 14:27:16.700967', 11);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (44, 'Can eliminate dry beach over time if beach nourishment is not required.', 5, '2019-04-02 14:27:16.701624', '2019-04-02 14:27:16.701633', 11);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (45, 'Can result in changes in habitat type.', 0, '2019-04-02 14:27:16.72305', '2019-04-02 14:27:16.723061', 13);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (46, 'May have limited recreational value due to limited access.', 1, '2019-04-02 14:27:16.7241', '2019-04-02 14:27:16.72411', 13);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (47, 'Use of wire and synthetic mesh rolls can be harmful to coastal/marine environments.', 0, '2019-04-02 14:27:16.739795', '2019-04-02 14:27:16.739803', 14);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (48, 'Potential end scour within 10-feet of the terminus of a fiber roll array should be managed on subject property.', 1, '2019-04-02 14:27:16.740596', '2019-04-02 14:27:16.740604', 14);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (49, 'Reduces available sediment source for down-drift beaches.', 2, '2019-04-02 14:27:16.741405', '2019-04-02 14:27:16.741414', 14);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (50, 'No high water protection.', 0, '2019-04-02 14:27:16.77381', '2019-04-02 14:27:16.773821', 17);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (51, 'Often includes installation of structural elements, which may have negative impacts on sediment supply, boating, recreation, etc. May reduce the commercial/recreational viability of the beach.', 1, '2019-04-02 14:27:16.774847', '2019-04-02 14:27:16.774857', 17);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (52, 'May be more difficult to permit than more conventional strategies.', 2, '2019-04-02 14:27:16.775917', '2019-04-02 14:27:16.775928', 17);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (53, 'Requires continual sand resources for renourishment.', 0, '2019-04-02 14:27:16.815345', '2019-04-02 14:27:16.815365', 19);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (54, 'No high water protection.', 1, '2019-04-02 14:27:16.816098', '2019-04-02 14:27:16.816106', 19);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (55, 'Can have negative impacts on marine life, beach life, and endangered species (piping plover) during construction and due to higher erosion rates (changing habitat).', 2, '2019-04-02 14:27:16.818998', '2019-04-02 14:27:16.819013', 19);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (56, 'Expensive (several million dollars depending on the scale).', 3, '2019-04-02 14:27:16.820078', '2019-04-02 14:27:16.82009', 19);
INSERT INTO public.adaptation_disadvantages (id, name, display_order, inserted_at, updated_at, strategy_id) VALUES (57, 'Sediment sources, whether from inland mining, nearshore dredging, or offshore mining, may have adverse environmental effects.', 4, '2019-04-02 14:27:16.821298', '2019-04-02 14:27:16.821312', 19);


--
-- Data for Name: coastal_hazards; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.coastal_hazards (id, name, description, inserted_at, updated_at, display_order, duration) VALUES (1, 'Erosion', NULL, '2019-04-02 14:27:16.263483', '2019-04-02 14:27:16.263491', NULL, '40 years');
INSERT INTO public.coastal_hazards (id, name, description, inserted_at, updated_at, display_order, duration) VALUES (2, 'Storm Surge', NULL, '2019-04-02 14:27:16.271648', '2019-04-02 14:27:16.271656', NULL, '1-time event');
INSERT INTO public.coastal_hazards (id, name, description, inserted_at, updated_at, display_order, duration) VALUES (3, 'Sea Level Rise', NULL, '2019-04-02 14:27:16.280075', '2019-04-02 14:27:16.280088', NULL, '40  years');


--
-- Data for Name: impact_costs; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.impact_costs (id, name, name_linear_foot, description, cost, inserted_at, updated_at, display_order) VALUES (1, 'Low (<$200)', NULL, NULL, 1, '2019-04-02 14:27:16.196645', '2019-04-02 14:27:16.196678', NULL);
INSERT INTO public.impact_costs (id, name, name_linear_foot, description, cost, inserted_at, updated_at, display_order) VALUES (2, 'Medium ($201-$500)', NULL, NULL, 2, '2019-04-02 14:27:16.205136', '2019-04-02 14:27:16.205147', NULL);
INSERT INTO public.impact_costs (id, name, name_linear_foot, description, cost, inserted_at, updated_at, display_order) VALUES (3, 'High ($501-$1,000)', NULL, NULL, 3, '2019-04-02 14:27:16.213371', '2019-04-02 14:27:16.213379', NULL);
INSERT INTO public.impact_costs (id, name, name_linear_foot, description, cost, inserted_at, updated_at, display_order) VALUES (4, 'Very High (>$1,001)', NULL, NULL, 4, '2019-04-02 14:27:16.221908', '2019-04-02 14:27:16.221922', NULL);


--
-- Data for Name: impact_life_spans; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.impact_life_spans (id, name, description, life_span, inserted_at, updated_at, display_order) VALUES (1, 'Short', NULL, 1, '2019-04-02 14:27:16.230104', '2019-04-02 14:27:16.230116', NULL);
INSERT INTO public.impact_life_spans (id, name, description, life_span, inserted_at, updated_at, display_order) VALUES (2, 'Medium', NULL, 2, '2019-04-02 14:27:16.238492', '2019-04-02 14:27:16.238499', NULL);
INSERT INTO public.impact_life_spans (id, name, description, life_span, inserted_at, updated_at, display_order) VALUES (3, 'Long', NULL, 3, '2019-04-02 14:27:16.246701', '2019-04-02 14:27:16.246708', NULL);
INSERT INTO public.impact_life_spans (id, name, description, life_span, inserted_at, updated_at, display_order) VALUES (4, 'Permanent', NULL, 4, '2019-04-02 14:27:16.255256', '2019-04-02 14:27:16.255269', NULL);


--
-- Data for Name: impact_scales; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.impact_scales (id, name, description, impact, inserted_at, updated_at, display_order) VALUES (1, 'Site', NULL, 1, '2019-04-02 14:27:16.132802', '2019-04-02 14:27:16.132818', NULL);
INSERT INTO public.impact_scales (id, name, description, impact, inserted_at, updated_at, display_order) VALUES (2, 'Neighborhood', NULL, 2, '2019-04-02 14:27:16.171774', '2019-04-02 14:27:16.171786', NULL);
INSERT INTO public.impact_scales (id, name, description, impact, inserted_at, updated_at, display_order) VALUES (3, 'Community', NULL, 3, '2019-04-02 14:27:16.180042', '2019-04-02 14:27:16.18005', NULL);
INSERT INTO public.impact_scales (id, name, description, impact, inserted_at, updated_at, display_order) VALUES (4, 'Regional', NULL, 4, '2019-04-02 14:27:16.188471', '2019-04-02 14:27:16.188478', NULL);


--
-- Data for Name: littoral_cells; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (1, 'Sandy Neck', -70.4951953199999934, 41.7244352900000024, -70.271945340000002, 41.7770718399999978, '2019-04-02 14:27:16.880849', '2019-04-02 14:27:16.880864', 1, 52, false, 8, 204.0055084, 5.9798193, 7, 130.4343719, 1, 461244800.00, 12.8821297, 4.404603481, 650.0172119, 4021.1875, false, 101);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (2, 'Buttermilk Bay', -70.6335272299999986, 41.7365394699999968, -70.6092781100000053, 41.7652900140000014, '2019-04-02 14:27:16.912242', '2019-04-02 14:27:16.912254', 5, 106, true, 218, 34.2522774, 171.8101501, 4, 55.6946297, 1, 393422600.00, 4.9664421, 25.71430588, 5.9395294, 657.7874146, false, 102);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (3, 'Mashnee', -70.6405389800000023, 41.7146127800000031, -70.6208710199999956, 41.7370688700000017, '2019-04-02 14:27:16.935835', '2019-04-02 14:27:16.935852', 0, 63, false, 21, 20.3502502, 179.1102753, 2, 20.6207943, 0, 301794700.00, 2.939918, 13.06014061, 61.0107536, 476.4459839, false, 103);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (4, 'Monument Beach', -70.6372851600000047, 41.70796773, -70.6149776000000031, 41.7370688700000017, '2019-04-02 14:27:16.955951', '2019-04-02 14:27:16.955959', 2, 89, true, 8, 26.915144, 95.0147705, 1, 12.8510218, 1, 290605160.00, 3.889698, 11.41208649, 63.1204758, 597.7488403, false, 104);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (5, 'Wings Neck', -70.6630569999999949, 41.6796427000000023, -70.6166759700000028, 41.7079786799999965, '2019-04-02 14:27:16.964123', '2019-04-02 14:27:16.964138', 0, 113, false, 3, 64.2526627, 74.3793411, 2, 31.8369522, 2, 323256020.00, 4.0165191, 9.428860664, 5.8283544, 381.8328247, false, 105);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (6, 'Red Brook Harbor', -70.6623886999999939, 41.6611958000000016, -70.6328199099999949, 41.6811640499999996, '2019-04-02 14:27:16.972224', '2019-04-02 14:27:16.972232', 0, 73, false, 1, 9.7079134, 271.3979797, 2, 0.0, 0, 217658870.00, 3.7567761, 4.952525139, 2.6752608, 486.3106384, false, 106);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (7, 'Megansett Harbor', -70.6548311600000005, 41.6374468500000035, -70.6198691200000042, 41.664003110000003, '2019-04-02 14:27:16.980627', '2019-04-02 14:27:16.980638', 4, 191, true, 3, 21.2656403, 283.9780273, 3, 3.3487511, 1, 683448500.00, 4.5419111, 12.91113758, 24.9014893, 459.4194336, false, 107);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (8, 'Old Silver Beach', -70.6542319400000025, 41.6067267199999975, -70.6397676800000056, 41.6419076600000011, '2019-04-02 14:27:16.989133', '2019-04-02 14:27:16.989144', 2, 109, false, 6, 31.3422775, 175.4341583, 11, 2.9746351, 0, 635004300.00, 3.843195, 16.91975403, 30.8582382, 236.6368408, false, 108);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (9, 'Sippewissett', -70.6641613299999989, 41.5413022500000011, -70.6414951699999989, 41.6069037999999978, '2019-04-02 14:27:16.997585', '2019-04-02 14:27:16.9976', 0, 72, false, 0, 95.0317993, 431.8627625, 9, 6.4433169, 0, 582787000.00, 5.3717442, 8.564338684, 66.9046783, 737.499939, false, 109);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (10, 'Woods Hole', -70.688690660000006, 41.51665019, -70.6630743000000052, 41.5418122199999971, '2019-04-02 14:27:17.006031', '2019-04-02 14:27:17.006057', 7, 102, true, 110, 3.9876704, 284.7936707, 3, 22.3431664, 1, 626611700.00, 4.9520388, 10.31838799, 0.4507518, 825.6036987, false, 110);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (11, 'Nobska', -70.6683108499999975, 41.5143114800000035, -70.6551900000000046, 41.5232924299999979, '2019-04-02 14:27:17.014221', '2019-04-02 14:27:17.014238', 6, 43, true, 89, 0.4663978, 87.6272888, 1, 4.3100624, 0, 251606300.00, 1.395851, 18.66693115, 3.2719717, 237.9641266, false, 111);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (12, 'South Falmouth', -70.6555168900000012, 41.514329189999998, -70.5280658300000027, 41.5523411499999966, '2019-04-02 14:27:17.022626', '2019-04-02 14:27:17.022642', 3, 185, true, 28, 38.2330894, 975.5437622, 17, 175.8104095, 0, 1025546449.00, 7.9527521, 13.50438404, 67.3718033, 1746.2563477, false, 112);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (13, 'New Seabury', -70.5280796400000014, 41.5465716100000009, -70.4497446799999949, 41.5880774000000031, '2019-04-02 14:27:17.030926', '2019-04-02 14:27:17.030942', 0, 39, false, 0, 61.836483, 19.7484436, 5, 298.637207, 0, 894116100.00, 5.3732042, 11.50544548, 26.8142071, 1490.3686523, false, 113);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (14, 'Cotuit', -70.4528094100000004, 41.58731796, -70.4009384799999935, 41.6090392500000021, '2019-04-02 14:27:17.039151', '2019-04-02 14:27:17.039163', 0, 89, true, 4, 25.401474, 54.628727, 4, 0.8072858, 0, 435699300.00, 3.7948329, 6.853813171, 89.3615646, 1101.5426025, false, 114);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (15, 'Wianno', -70.400956260000001, 41.6057665000000014, -70.3643801799999977, 41.6221806000000001, '2019-04-02 14:27:17.047572', '2019-04-02 14:27:17.04759', 0, 104, false, 2, 3.102915, 322.4924316, 2, 33.4862099, 0, 513900700.00, 2.2582591, 11.87512684, 16.1339588, 551.7070923, false, 115);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (16, 'Centerville Harbor', -70.3655109999999979, 41.6217563200000029, -70.3169095899999945, 41.6363015100000027, '2019-04-02 14:27:17.055823', '2019-04-02 14:27:17.055835', 1, 79, false, 4, 99.109169, 191.6327057, 7, 40.852684, 1, 523927500.00, 3.4090099, 11.96304893, 39.8272591, 909.6130371, false, 116);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (17, 'Lewis Bay', -70.3172615999999948, 41.6084277799999995, -70.2401080900000068, 41.6517444099999992, '2019-04-02 14:27:17.064112', '2019-04-02 14:27:17.064134', 38, 294, true, 115, 137.3874664, 466.7622681, 17, 131.2438965, 2, 1428641000.00, 11.5430002, 18.56052208, 106.2389297, 1913.0593262, false, 117);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (18, 'Nantucket Sound', -70.2657885899999997, 41.608446469999997, -69.9819080799999966, 41.6723346899999996, '2019-04-02 14:27:17.072493', '2019-04-02 14:27:17.072513', 9, 518, true, 70, 380.8373108, 2486.3562012, 51, 490.1095581, 0, 2537257400.00, 17.3015995, 15.66193962, 340.8415222, 4085.7602539, false, 118);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (19, 'Monomoy', -70.0154970600000013, 41.5394903999999983, -69.9416789299999948, 41.6724202500000018, '2019-04-02 14:27:17.08078', '2019-04-02 14:27:17.080788', 1, 10, false, 5, 105.3767395, 560.2143555, 2, 213.083374, 0, 271926400.00, 20.9548302, 0.722238481, 1051.571167, 6738.7255859, true, 119);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (20, 'Chatham Harbor', -69.9515232499999939, 41.6720345000000023, -69.9443365199999931, 41.7044175400000015, '2019-04-02 14:27:17.089147', '2019-04-02 14:27:17.089157', 2, 33, true, 11, 31.2736931, 78.3087082, 5, 21.3441048, 0, 865465800.00, 2.5425341, 17.18111992, 24.9601288, 569.944397, true, 120);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (21, 'Bassing Harbor', -69.9739791100000019, 41.7038680699999986, -69.9446244300000046, 41.7218528000000006, '2019-04-02 14:27:17.097376', '2019-04-02 14:27:17.097384', 0, 32, false, 4, 34.5506363, 361.5568237, 3, 37.4128647, 0, 481869100.00, 3.182462, 9.980096817, 11.1119413, 619.3502197, false, 121);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (22, 'Wequassett', -69.9965759800000029, 41.7127307100000024, -69.9735994699999964, 41.7364311299999997, '2019-04-02 14:27:17.105551', '2019-04-02 14:27:17.105582', 1, 45, true, 8, 22.9759789, 71.4209671, 9, 152.7987518, 1, 310864000.00, 3.073679, 11.93692398, 8.8877954, 674.5410156, false, 122);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (23, 'Little Pleasant Bay', -69.9877295400000037, 41.7041369100000026, -69.9276298399999945, 41.7742819600000033, '2019-04-02 14:27:17.11428', '2019-04-02 14:27:17.114292', 1, 66, true, 12, 511.4660339, 821.8519897, 7, 470.2912292, 2, 592666250.00, 12.0422802, 5.15602541, 261.1954651, 2852.9833984, true, 123);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (24, 'Nauset', -69.940282339999996, 41.7076872499999993, -69.9263477199999954, 41.8263314900000012, '2019-04-02 14:27:17.122644', '2019-04-02 14:27:17.122656', 0, 0, false, 22, 243.6255646, 22.5867462, 1, 762.0858154, 0, 130701200.00, 8.6657391, 1.425156593, 487.9051819, 3070.623291, true, 124);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (25, 'Coast Guard Beach', -69.950752940000001, 41.8262199999999993, -69.9381875800000046, 41.8614842599999974, '2019-04-02 14:27:17.130894', '2019-04-02 14:27:17.130907', 1, 0, false, 9, 23.6465569, 0.0, 3, 0.0, 0, 30923200.00, 2.540206, 2.573147058, 14.4632149, 1053.2125244, true, 125);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (26, 'Marconi', -69.9614855899999952, 41.8613816499999984, -69.9495417499999945, 41.8935703399999966, '2019-04-02 14:27:17.139289', '2019-04-02 14:27:17.139314', 0, 0, false, 6, 0.0, 0.0, 2, 171.526062, 0, 17981400.00, 2.2889249, 2.897997141, 0.0, 967.5145874, true, 126);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (27, 'Outer Cape', -70.2485820100000069, 41.8934687599999975, -69.9602871999999962, 42.0834339700000015, '2019-04-02 14:27:17.147636', '2019-04-02 14:27:17.147654', 0, 8, false, 75, 118.0019379, 12.9466887, 15, 3932.9230957, 0, 171293000.00, 28.6761799, 1.655546427, 1095.5489502, 9952.5556641, true, 127);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (28, 'Provincetown Harbor', -70.1987008199999991, 42.023928810000001, -70.1664411600000051, 42.0465589200000025, '2019-04-02 14:27:17.155657', '2019-04-02 14:27:17.155666', 4, 50, true, 25, 133.3305054, 140.2750092, 8, 292.7267151, 0, 726006200.00, 3.480684, 11.96743774, 53.2006798, 991.5595093, true, 128);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (29, 'Truro', -70.1897715700000049, 41.9681320999999983, -70.0771253199999933, 42.0621785700000004, '2019-04-02 14:27:17.164273', '2019-04-02 14:27:17.164286', 15, 144, true, 79, 39.6284142, 1121.4608154, 30, 168.9987946, 0, 2369225100.00, 10.7964802, 17.23412132, 103.8385391, 2721.8625488, true, 129);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (30, 'Bound Brook', -70.0789620099999979, 41.9433331800000033, -70.0766890000000018, 41.9682129999999987, '2019-04-02 14:27:17.17231', '2019-04-02 14:27:17.172319', 0, 0, false, 5, 0.0, 325.9089966, 2, 240.3492889, 0, 70897100.00, 1.72536, 2.774612904, 47.3282356, 755.8833008, true, 130);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (31, 'Great Island', -70.0782646100000051, 41.8838963999999976, -70.0669497500000062, 41.9434214899999986, '2019-04-02 14:27:17.180955', '2019-04-02 14:27:17.180967', 0, 0, false, 0, 106.9666061, 425.5777283, 2, 489.5529175, 0, 15374700.00, 4.1978979, 8.03567028, 68.1362839, 1622.809082, true, 131);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (32, 'Wellfleet Harbor', -70.0707694900000035, 41.8841169900000025, -70.0229698299999939, 41.931489489999997, '2019-04-02 14:27:17.189215', '2019-04-02 14:27:17.189227', 4, 97, true, 6, 222.3549652, 70.8523407, 10, 624.2570801, 0, 455847300.00, 10.5048399, 6.293058395, 70.2663345, 2528.1630859, true, 132);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (33, 'Blackfish Creek', -70.0255216500000017, 41.8924981700000032, -70.0058751600000022, 41.9097969000000035, '2019-04-02 14:27:17.197496', '2019-04-02 14:27:17.197521', 0, 35, false, 0, 177.3943939, 0.0, 0, 0.6491886, 0, 149123700.00, 2.860405, 4.120303631, 28.9642696, 922.3416748, false, 133);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (34, 'Cape Cod Bay', -70.1087637499999943, 41.7630424899999966, -70.0014225500000009, 41.8932072699999978, '2019-04-02 14:27:17.206048', '2019-04-02 14:27:17.206065', 4, 143, true, 96, 608.8064575, 189.9243622, 41, 201.6305389, 2, 1542971500.00, 13.96208, 10.03118896, 143.90625, 3427.4592285, false, 134);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (35, 'Quivett', -70.181354369999994, 41.7513277700000032, -70.1085329099999939, 41.7642027899999988, '2019-04-02 14:27:17.214018', '2019-04-02 14:27:17.214026', 4, 36, true, 3, 89.2759476, 9.3302622, 8, 43.7184067, 0, 446347420.00, 4.1774969, 8.187264442, 79.331604, 673.1985474, false, 135);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (36, 'Barnstable Harbor', -70.3525598899999949, 41.7083785700000007, -70.1811246799999964, 41.7530298300000027, '2019-04-02 14:27:17.222566', '2019-04-02 14:27:17.222577', 8, 98, true, 27, 1256.4754639, 37.4771461, 11, 87.6455841, 3, 974675740.00, 16.4632301, 5.641637325, 319.9433594, 4614.3808594, false, 136);
INSERT INTO public.littoral_cells (id, name, min_x, min_y, max_x, max_y, inserted_at, updated_at, critical_facilities_count, coastal_structures_count, working_harbor, public_buildings_count, salt_marsh_acres, eelgrass_acres, public_beach_count, recreation_open_space_acres, town_ways_to_water, total_assessed_value, length_miles, imperv_percent, coastal_dune_acres, rare_species_acres, national_seashore, littoral_cell_id) VALUES (37, 'Sagamore', -70.5377763900000048, 41.7766314400000027, -70.4932775000000049, 41.8111470999999995, '2019-04-02 14:27:17.230655', '2019-04-02 14:27:17.230663', 0, 33, false, 8, 0.0, 5.9798193, 2, 138.4368439, 0, 255135300.00, 3.3053861, 10.14210987, 58.2020454, 960.220459, false, 137);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627200200, '2019-04-02 14:26:39.999173');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627200743, '2019-04-02 14:26:40.162395');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627201108, '2019-04-02 14:26:40.296708');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627203452, '2019-04-02 14:26:40.423866');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627211906, '2019-04-02 14:26:40.460192');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627212047, '2019-04-02 14:26:40.497132');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180627212147, '2019-04-02 14:26:40.523512');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180703202705, '2019-04-02 14:26:40.544385');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180703204221, '2019-04-02 14:26:40.571161');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180703204303, '2019-04-02 14:26:40.595003');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180703205219, '2019-04-02 14:26:40.621369');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180705210332, '2019-04-02 14:26:40.646181');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180718180304, '2019-04-02 14:26:40.749471');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180726173204, '2019-04-02 14:26:40.785178');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180727193446, '2019-04-02 14:26:40.849839');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180727194146, '2019-04-02 14:26:40.903629');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807203920, '2019-04-02 14:26:40.933514');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807203940, '2019-04-02 14:26:40.955325');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807203956, '2019-04-02 14:26:40.980024');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807204011, '2019-04-02 14:26:41.004642');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807204026, '2019-04-02 14:26:41.029467');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807204040, '2019-04-02 14:26:41.054875');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807204054, '2019-04-02 14:26:41.08031');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807204115, '2019-04-02 14:26:41.103203');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807204132, '2019-04-02 14:26:41.130528');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180807204145, '2019-04-02 14:26:41.156377');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180808140524, '2019-04-02 14:26:41.18131');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180808140539, '2019-04-02 14:26:41.204858');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180820140003, '2019-04-02 14:26:41.301483');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180820140128, '2019-04-02 14:26:41.33722');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180823192847, '2019-04-02 14:26:41.366291');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180823192901, '2019-04-02 14:26:41.386229');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180823192913, '2019-04-02 14:26:41.41355');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180919153922, '2019-04-02 14:26:41.502411');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180919154827, '2019-04-02 14:26:41.543581');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180920142818, '2019-04-02 14:26:41.570501');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180920145129, '2019-04-02 14:26:41.635849');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180920213425, '2019-04-02 14:26:41.669867');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180921142315, '2019-04-02 14:26:41.738951');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180921143254, '2019-04-02 14:26:41.768189');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20180926153705, '2019-04-02 14:26:41.785561');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20181018144049, '2019-04-02 14:26:41.895286');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20181018144150, '2019-04-02 14:26:42.013053');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20181021224755, '2019-04-02 14:26:42.046445');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20181021230621, '2019-04-02 14:26:42.072432');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20181021230849, '2019-04-02 14:26:42.100045');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20181022155130, '2019-04-02 14:26:42.128731');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20181022200330, '2019-04-02 14:26:42.163282');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20181024174434, '2019-04-02 14:26:42.200197');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20181024174453, '2019-04-02 14:26:42.222838');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20181026142619, '2019-04-02 14:26:42.248552');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20181031141750, '2019-04-02 14:26:42.273934');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20181102021407, '2019-04-02 14:26:42.299265');
INSERT INTO public.schema_migrations (version, inserted_at) VALUES (20190402125014, '2019-04-02 14:27:15.700556');


--
-- Data for Name: strategies_benefits; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (1, 1);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (1, 4);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (1, 6);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (2, 1);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (2, 2);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (2, 3);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (2, 4);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (2, 5);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (2, 6);
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
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (9, 1);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (9, 2);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (9, 3);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (9, 4);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (9, 5);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (9, 6);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (10, 1);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (10, 2);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (10, 3);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (10, 4);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (10, 5);
INSERT INTO public.strategies_benefits (strategy_id, benefit_id) VALUES (10, 6);
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
INSERT INTO public.strategies_categories (strategy_id, category_id) VALUES (10, 2);
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
-- Data for Name: strategies_costs; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.strategies_costs (strategy_id, cost_range_id) VALUES (1, 1);
INSERT INTO public.strategies_costs (strategy_id, cost_range_id) VALUES (1, 2);
INSERT INTO public.strategies_costs (strategy_id, cost_range_id) VALUES (1, 3);
INSERT INTO public.strategies_costs (strategy_id, cost_range_id) VALUES (1, 4);
INSERT INTO public.strategies_costs (strategy_id, cost_range_id) VALUES (2, 3);
INSERT INTO public.strategies_costs (strategy_id, cost_range_id) VALUES (3, 3);
INSERT INTO public.strategies_costs (strategy_id, cost_range_id) VALUES (9, 3);
INSERT INTO public.strategies_costs (strategy_id, cost_range_id) VALUES (10, 2);
INSERT INTO public.strategies_costs (strategy_id, cost_range_id) VALUES (11, 4);
INSERT INTO public.strategies_costs (strategy_id, cost_range_id) VALUES (12, 4);
INSERT INTO public.strategies_costs (strategy_id, cost_range_id) VALUES (13, 1);
INSERT INTO public.strategies_costs (strategy_id, cost_range_id) VALUES (14, 3);
INSERT INTO public.strategies_costs (strategy_id, cost_range_id) VALUES (17, 3);
INSERT INTO public.strategies_costs (strategy_id, cost_range_id) VALUES (19, 2);


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
INSERT INTO public.strategies_hazards (strategy_id, hazard_id) VALUES (19, 2);


--
-- Data for Name: strategies_life_spans; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.strategies_life_spans (strategy_id, life_span_range_id) VALUES (1, 1);
INSERT INTO public.strategies_life_spans (strategy_id, life_span_range_id) VALUES (1, 2);
INSERT INTO public.strategies_life_spans (strategy_id, life_span_range_id) VALUES (1, 3);
INSERT INTO public.strategies_life_spans (strategy_id, life_span_range_id) VALUES (1, 4);
INSERT INTO public.strategies_life_spans (strategy_id, life_span_range_id) VALUES (2, 4);
INSERT INTO public.strategies_life_spans (strategy_id, life_span_range_id) VALUES (3, 4);
INSERT INTO public.strategies_life_spans (strategy_id, life_span_range_id) VALUES (9, 4);
INSERT INTO public.strategies_life_spans (strategy_id, life_span_range_id) VALUES (10, 3);
INSERT INTO public.strategies_life_spans (strategy_id, life_span_range_id) VALUES (11, 3);
INSERT INTO public.strategies_life_spans (strategy_id, life_span_range_id) VALUES (12, 3);
INSERT INTO public.strategies_life_spans (strategy_id, life_span_range_id) VALUES (13, 2);
INSERT INTO public.strategies_life_spans (strategy_id, life_span_range_id) VALUES (14, 1);
INSERT INTO public.strategies_life_spans (strategy_id, life_span_range_id) VALUES (17, 3);
INSERT INTO public.strategies_life_spans (strategy_id, life_span_range_id) VALUES (19, 1);


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

SELECT pg_catalog.setval('public.adaptation_advantages_id_seq', 56, true);


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

SELECT pg_catalog.setval('public.adaptation_disadvantages_id_seq', 57, true);


--
-- Name: adaptation_strategies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adaptation_strategies_id_seq', 19, true);


--
-- Name: coastal_hazards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.coastal_hazards_id_seq', 3, true);


--
-- Name: impact_costs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.impact_costs_id_seq', 4, true);


--
-- Name: impact_life_spans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.impact_life_spans_id_seq', 4, true);


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

