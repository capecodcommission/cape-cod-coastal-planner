--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5
-- Dumped by pg_dump version 10.5

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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: adaptation_advantages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.adaptation_advantages (
    id bigint NOT NULL,
    name character varying(255),
    display_order integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    strategy_id bigint
);


--
-- Name: adaptation_advantages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.adaptation_advantages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: adaptation_advantages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.adaptation_advantages_id_seq OWNED BY public.adaptation_advantages.id;


--
-- Name: adaptation_benefits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.adaptation_benefits (
    id bigint NOT NULL,
    name character varying(255),
    display_order integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: adaptation_benefits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.adaptation_benefits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: adaptation_benefits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.adaptation_benefits_id_seq OWNED BY public.adaptation_benefits.id;


--
-- Name: adaptation_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.adaptation_categories (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    display_order integer
);


--
-- Name: adaptation_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.adaptation_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: adaptation_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.adaptation_categories_id_seq OWNED BY public.adaptation_categories.id;


--
-- Name: adaptation_disadvantages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.adaptation_disadvantages (
    id bigint NOT NULL,
    name character varying(255),
    display_order integer,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    strategy_id bigint
);


--
-- Name: adaptation_disadvantages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.adaptation_disadvantages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: adaptation_disadvantages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.adaptation_disadvantages_id_seq OWNED BY public.adaptation_disadvantages.id;


--
-- Name: adaptation_strategies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.adaptation_strategies (
    id bigint NOT NULL,
    name character varying(255),
    description text,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    display_order integer,
    is_active boolean,
    currently_permittable character varying(255),
    strategy_placement character varying(255)
);


--
-- Name: adaptation_strategies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.adaptation_strategies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: adaptation_strategies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.adaptation_strategies_id_seq OWNED BY public.adaptation_strategies.id;


--
-- Name: coastal_hazards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.coastal_hazards (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    display_order integer,
    duration character varying(255)
);


--
-- Name: coastal_hazards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.coastal_hazards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: coastal_hazards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.coastal_hazards_id_seq OWNED BY public.coastal_hazards.id;


--
-- Name: impact_costs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.impact_costs (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    name_linear_foot character varying(255),
    description text,
    cost integer NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    display_order integer
);


--
-- Name: impact_costs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.impact_costs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: impact_costs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.impact_costs_id_seq OWNED BY public.impact_costs.id;


--
-- Name: impact_life_spans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.impact_life_spans (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    life_span integer NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    display_order integer
);


--
-- Name: impact_life_spans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.impact_life_spans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: impact_life_spans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.impact_life_spans_id_seq OWNED BY public.impact_life_spans.id;


--
-- Name: impact_scales; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.impact_scales (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    impact integer NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    display_order integer
);


--
-- Name: impact_scales_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.impact_scales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: impact_scales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.impact_scales_id_seq OWNED BY public.impact_scales.id;


--
-- Name: littoral_cells; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.littoral_cells (
    id bigint NOT NULL,
    name character varying(255),
    min_x double precision,
    min_y double precision,
    max_x double precision,
    max_y double precision,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    critical_facilities_count integer NOT NULL,
    coastal_structures_count integer NOT NULL,
    working_harbor boolean NOT NULL,
    public_buildings_count integer NOT NULL,
    salt_marsh_acres numeric NOT NULL,
    eelgrass_acres numeric NOT NULL,
    public_beach_count integer NOT NULL,
    recreation_open_space_acres numeric NOT NULL,
    town_ways_to_water integer NOT NULL,
    total_assessed_value numeric NOT NULL,
    length_miles numeric NOT NULL,
    imperv_percent numeric NOT NULL,
    coastal_dune_acres numeric NOT NULL,
    rare_species_acres numeric NOT NULL,
    national_seashore boolean NOT NULL,
    littoral_cell_id integer
);


--
-- Name: littoral_cells_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.littoral_cells_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: littoral_cells_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.littoral_cells_id_seq OWNED BY public.littoral_cells.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp without time zone
);


--
-- Name: strategies_benefits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.strategies_benefits (
    strategy_id bigint NOT NULL,
    benefit_id bigint NOT NULL
);


--
-- Name: strategies_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.strategies_categories (
    strategy_id bigint NOT NULL,
    category_id bigint NOT NULL
);


--
-- Name: strategies_costs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.strategies_costs (
    strategy_id bigint NOT NULL,
    cost_range_id bigint NOT NULL
);


--
-- Name: strategies_hazards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.strategies_hazards (
    strategy_id bigint NOT NULL,
    hazard_id bigint NOT NULL
);


--
-- Name: strategies_life_spans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.strategies_life_spans (
    strategy_id bigint NOT NULL,
    life_span_range_id bigint NOT NULL
);


--
-- Name: strategies_placements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.strategies_placements (
    strategy_id bigint NOT NULL,
    placement_id bigint NOT NULL
);


--
-- Name: strategies_scales; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.strategies_scales (
    strategy_id bigint NOT NULL,
    scale_id bigint NOT NULL
);


--
-- Name: adaptation_advantages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptation_advantages ALTER COLUMN id SET DEFAULT nextval('public.adaptation_advantages_id_seq'::regclass);


--
-- Name: adaptation_benefits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptation_benefits ALTER COLUMN id SET DEFAULT nextval('public.adaptation_benefits_id_seq'::regclass);


--
-- Name: adaptation_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptation_categories ALTER COLUMN id SET DEFAULT nextval('public.adaptation_categories_id_seq'::regclass);


--
-- Name: adaptation_disadvantages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptation_disadvantages ALTER COLUMN id SET DEFAULT nextval('public.adaptation_disadvantages_id_seq'::regclass);


--
-- Name: adaptation_strategies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptation_strategies ALTER COLUMN id SET DEFAULT nextval('public.adaptation_strategies_id_seq'::regclass);


--
-- Name: coastal_hazards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coastal_hazards ALTER COLUMN id SET DEFAULT nextval('public.coastal_hazards_id_seq'::regclass);


--
-- Name: impact_costs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.impact_costs ALTER COLUMN id SET DEFAULT nextval('public.impact_costs_id_seq'::regclass);


--
-- Name: impact_life_spans id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.impact_life_spans ALTER COLUMN id SET DEFAULT nextval('public.impact_life_spans_id_seq'::regclass);


--
-- Name: impact_scales id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.impact_scales ALTER COLUMN id SET DEFAULT nextval('public.impact_scales_id_seq'::regclass);


--
-- Name: littoral_cells id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.littoral_cells ALTER COLUMN id SET DEFAULT nextval('public.littoral_cells_id_seq'::regclass);


--
-- Name: adaptation_advantages adaptation_advantages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptation_advantages
    ADD CONSTRAINT adaptation_advantages_pkey PRIMARY KEY (id);


--
-- Name: adaptation_benefits adaptation_benefits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptation_benefits
    ADD CONSTRAINT adaptation_benefits_pkey PRIMARY KEY (id);


--
-- Name: adaptation_categories adaptation_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptation_categories
    ADD CONSTRAINT adaptation_categories_pkey PRIMARY KEY (id);


--
-- Name: adaptation_disadvantages adaptation_disadvantages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptation_disadvantages
    ADD CONSTRAINT adaptation_disadvantages_pkey PRIMARY KEY (id);


--
-- Name: adaptation_strategies adaptation_strategies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptation_strategies
    ADD CONSTRAINT adaptation_strategies_pkey PRIMARY KEY (id);


--
-- Name: coastal_hazards coastal_hazards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coastal_hazards
    ADD CONSTRAINT coastal_hazards_pkey PRIMARY KEY (id);


--
-- Name: impact_costs impact_costs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.impact_costs
    ADD CONSTRAINT impact_costs_pkey PRIMARY KEY (id);


--
-- Name: impact_life_spans impact_life_spans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.impact_life_spans
    ADD CONSTRAINT impact_life_spans_pkey PRIMARY KEY (id);


--
-- Name: impact_scales impact_scales_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.impact_scales
    ADD CONSTRAINT impact_scales_pkey PRIMARY KEY (id);


--
-- Name: littoral_cells littoral_cells_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.littoral_cells
    ADD CONSTRAINT littoral_cells_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: adaptation_benefits_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX adaptation_benefits_name_index ON public.adaptation_benefits USING btree (name);


--
-- Name: adaptation_categories_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX adaptation_categories_name_index ON public.adaptation_categories USING btree (name);


--
-- Name: adaptation_strategies_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX adaptation_strategies_name_index ON public.adaptation_strategies USING btree (name);


--
-- Name: coastal_hazards_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX coastal_hazards_name_index ON public.coastal_hazards USING btree (name);


--
-- Name: impact_costs_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impact_costs_name_index ON public.impact_costs USING btree (name);


--
-- Name: impact_life_spans_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impact_life_spans_name_index ON public.impact_life_spans USING btree (name);


--
-- Name: impact_scales_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impact_scales_name_index ON public.impact_scales USING btree (name);


--
-- Name: littoral_cells_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX littoral_cells_name_index ON public.littoral_cells USING btree (name);


--
-- Name: adaptation_advantages adaptation_advantages_strategy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptation_advantages
    ADD CONSTRAINT adaptation_advantages_strategy_id_fkey FOREIGN KEY (strategy_id) REFERENCES public.adaptation_strategies(id);


--
-- Name: adaptation_disadvantages adaptation_disadvantages_strategy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptation_disadvantages
    ADD CONSTRAINT adaptation_disadvantages_strategy_id_fkey FOREIGN KEY (strategy_id) REFERENCES public.adaptation_strategies(id);


--
-- Name: strategies_benefits strategies_benefits_benefit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.strategies_benefits
    ADD CONSTRAINT strategies_benefits_benefit_id_fkey FOREIGN KEY (benefit_id) REFERENCES public.adaptation_benefits(id);


--
-- Name: strategies_benefits strategies_benefits_strategy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.strategies_benefits
    ADD CONSTRAINT strategies_benefits_strategy_id_fkey FOREIGN KEY (strategy_id) REFERENCES public.adaptation_strategies(id);


--
-- Name: strategies_categories strategies_categories_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.strategies_categories
    ADD CONSTRAINT strategies_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.adaptation_categories(id);


--
-- Name: strategies_categories strategies_categories_strategy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.strategies_categories
    ADD CONSTRAINT strategies_categories_strategy_id_fkey FOREIGN KEY (strategy_id) REFERENCES public.adaptation_strategies(id);


--
-- Name: strategies_costs strategies_costs_cost_range_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.strategies_costs
    ADD CONSTRAINT strategies_costs_cost_range_id_fkey FOREIGN KEY (cost_range_id) REFERENCES public.impact_costs(id);


--
-- Name: strategies_costs strategies_costs_strategy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.strategies_costs
    ADD CONSTRAINT strategies_costs_strategy_id_fkey FOREIGN KEY (strategy_id) REFERENCES public.adaptation_strategies(id);


--
-- Name: strategies_hazards strategies_hazards_hazard_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.strategies_hazards
    ADD CONSTRAINT strategies_hazards_hazard_id_fkey FOREIGN KEY (hazard_id) REFERENCES public.coastal_hazards(id);


--
-- Name: strategies_hazards strategies_hazards_strategy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.strategies_hazards
    ADD CONSTRAINT strategies_hazards_strategy_id_fkey FOREIGN KEY (strategy_id) REFERENCES public.adaptation_strategies(id);


--
-- Name: strategies_life_spans strategies_life_spans_life_span_range_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.strategies_life_spans
    ADD CONSTRAINT strategies_life_spans_life_span_range_id_fkey FOREIGN KEY (life_span_range_id) REFERENCES public.impact_life_spans(id);


--
-- Name: strategies_life_spans strategies_life_spans_strategy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.strategies_life_spans
    ADD CONSTRAINT strategies_life_spans_strategy_id_fkey FOREIGN KEY (strategy_id) REFERENCES public.adaptation_strategies(id);


--
-- Name: strategies_placements strategies_placements_placement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.strategies_placements
    ADD CONSTRAINT strategies_placements_placement_id_fkey FOREIGN KEY (placement_id) REFERENCES public.strategy_placements(id);


--
-- Name: strategies_placements strategies_placements_strategy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.strategies_placements
    ADD CONSTRAINT strategies_placements_strategy_id_fkey FOREIGN KEY (strategy_id) REFERENCES public.adaptation_strategies(id);


--
-- Name: strategies_scales strategies_scales_scale_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.strategies_scales
    ADD CONSTRAINT strategies_scales_scale_id_fkey FOREIGN KEY (scale_id) REFERENCES public.impact_scales(id);


--
-- Name: strategies_scales strategies_scales_strategy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.strategies_scales
    ADD CONSTRAINT strategies_scales_strategy_id_fkey FOREIGN KEY (strategy_id) REFERENCES public.adaptation_strategies(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20180627200200), (20180627200743), (20180627201108), (20180627203452), (20180627211906), (20180627212047), (20180627212147), (20180703202705), (20180703204221), (20180703204303), (20180703205219), (20180705210332), (20180718180304), (20180726173204), (20180727193446), (20180727194146), (20180807203920), (20180807203940), (20180807203956), (20180807204011), (20180807204026), (20180807204040), (20180807204054), (20180807204115), (20180807204132), (20180807204145), (20180808140524), (20180808140539), (20180820140003), (20180820140128), (20180823192847), (20180823192901), (20180823192913), (20180919153922), (20180919154827), (20180920142818), (20180920145129), (20180920213425), (20180921142315), (20180921143254), (20180926153705), (20181018144049), (20181018144150), (20181022155130), (20181022200330), (20181024174434), (20181024174453), (20181026142619);

