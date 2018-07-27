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
-- Name: adaptation_strategies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.adaptation_strategies (
    id bigint NOT NULL,
    name character varying(255),
    description text,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    display_order integer,
    is_active boolean
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
    display_order integer
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
    updated_at timestamp without time zone NOT NULL
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
-- Name: strategies_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.strategies_categories (
    strategy_id bigint NOT NULL,
    category_id bigint NOT NULL
);


--
-- Name: strategies_hazards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.strategies_hazards (
    strategy_id bigint NOT NULL,
    hazard_id bigint NOT NULL
);


--
-- Name: strategies_scales; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.strategies_scales (
    strategy_id bigint NOT NULL,
    scale_id bigint NOT NULL
);


--
-- Name: adaptation_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptation_categories ALTER COLUMN id SET DEFAULT nextval('public.adaptation_categories_id_seq'::regclass);


--
-- Name: adaptation_strategies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptation_strategies ALTER COLUMN id SET DEFAULT nextval('public.adaptation_strategies_id_seq'::regclass);


--
-- Name: coastal_hazards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coastal_hazards ALTER COLUMN id SET DEFAULT nextval('public.coastal_hazards_id_seq'::regclass);


--
-- Name: impact_scales id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.impact_scales ALTER COLUMN id SET DEFAULT nextval('public.impact_scales_id_seq'::regclass);


--
-- Name: littoral_cells id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.littoral_cells ALTER COLUMN id SET DEFAULT nextval('public.littoral_cells_id_seq'::regclass);


--
-- Name: adaptation_categories adaptation_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adaptation_categories
    ADD CONSTRAINT adaptation_categories_pkey PRIMARY KEY (id);


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
-- Name: impact_scales_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX impact_scales_name_index ON public.impact_scales USING btree (name);


--
-- Name: littoral_cells_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX littoral_cells_name_index ON public.littoral_cells USING btree (name);


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

INSERT INTO public."schema_migrations" (version) VALUES (20180627200200), (20180627200743), (20180627201108), (20180627203452), (20180627211906), (20180627212047), (20180627212147), (20180703202705), (20180703204221), (20180703204303), (20180703205219), (20180705210332), (20180718180304), (20180726173204);

