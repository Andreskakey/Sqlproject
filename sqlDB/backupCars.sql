--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: cars; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE cars (
    model text,
    mpg double precision,
    cylinders integer,
    displacement double precision,
    horsepower double precision,
    weight double precision,
    accel double precision,
    year integer,
    origin text
);


ALTER TABLE cars OWNER TO postgres;

--
-- Data for Name: cars; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY cars (model, mpg, cylinders, displacement, horsepower, weight, accel, year, origin) FROM stdin;
\.


--
-- PostgreSQL database dump complete
--

