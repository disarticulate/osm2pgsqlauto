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
-- Name: postgraphql_watch; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA postgraphql_watch;


ALTER SCHEMA postgraphql_watch OWNER TO postgres;

--
-- Name: test2; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA test2;


ALTER SCHEMA test2 OWNER TO postgres;

--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO postgres;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO postgres;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: plpython3u; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpython3u WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpython3u; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpython3u IS 'PL/Python3U untrusted procedural language';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


SET search_path = public, pg_catalog;

--
-- Name: planet_osm_line_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE planet_osm_line_type AS (
	osm_id bigint,
	access text,
	"addr:housename" text,
	"addr:housenumber" text,
	"addr:interpolation" text,
	admin_level text,
	aerialway text,
	aeroway text,
	amenity text,
	area text,
	barrier text,
	bicycle text,
	brand text,
	bridge text,
	boundary text,
	building text,
	construction text,
	covered text,
	culvert text,
	cutting text,
	denomination text,
	disused text,
	embankment text,
	foot text,
	"generator:source" text,
	harbour text,
	highway text,
	historic text,
	horse text,
	intermittent text,
	junction text,
	landuse text,
	layer text,
	leisure text,
	lock text,
	man_made text,
	military text,
	motorcar text,
	name text,
	"natural" text,
	office text,
	oneway text,
	operator text,
	place text,
	population text,
	power text,
	power_source text,
	public_transport text,
	railway text,
	ref text,
	religion text,
	route text,
	service text,
	shop text,
	sport text,
	surface text,
	toll text,
	tourism text,
	"tower:type" text,
	tracktype text,
	tunnel text,
	water text,
	waterway text,
	wetland text,
	width text,
	wood text,
	z_order integer,
	way_area real,
	way geometry(LineString,3857)
);


ALTER TYPE planet_osm_line_type OWNER TO postgres;

--
-- Name: TYPE planet_osm_line_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE planet_osm_line_type IS 'planet_osm_line';


SET search_path = postgraphql_watch, pg_catalog;

--
-- Name: notify_watchers_ddl(); Type: FUNCTION; Schema: postgraphql_watch; Owner: postgres
--

CREATE FUNCTION notify_watchers_ddl() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
begin
  perform pg_notify(
    'postgraphql_watch',
    json_build_object(
      'type',
      'ddl',
      'payload',
      (select json_agg(json_build_object('schema', schema_name, 'command', command_tag)) from pg_event_trigger_ddl_commands() as x)
    )::text
  );
end;
$$;


ALTER FUNCTION postgraphql_watch.notify_watchers_ddl() OWNER TO postgres;

--
-- Name: notify_watchers_drop(); Type: FUNCTION; Schema: postgraphql_watch; Owner: postgres
--

CREATE FUNCTION notify_watchers_drop() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
begin
  perform pg_notify(
    'postgraphql_watch',
    json_build_object(
      'type',
      'drop',
      'payload',
      (select json_agg(distinct x.schema_name) from pg_event_trigger_dropped_objects() as x)
    )::text
  );
end;
$$;


ALTER FUNCTION postgraphql_watch.notify_watchers_drop() OWNER TO postgres;

SET search_path = public, pg_catalog;

--
-- Name: copy_planet_table_to_schema_by_geohash(text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION copy_planet_table_to_schema_by_geohash(schema text, oldtable text, newtable text, geohash text) RETURNS json
    LANGUAGE plpython3u
    AS $$
    from json import dumps
    query = """
      CREATE TABLE IF NOT EXISTS {schema}.{newtable} 
        AS SELECT * FROM {oldtable}
        WHERE ST_Contains(
          ST_GeomFromGeoHash('{geohash}', 8), 
          {oldtable}.way
        )
    """.format(schema=schema,oldtable=oldtable,newtable=newtable,geohash=geohash)
    results = plpy.execute(query)
    return dumps({
      "row_count":results.nrows(),
    })
  $$;


ALTER FUNCTION public.copy_planet_table_to_schema_by_geohash(schema text, oldtable text, newtable text, geohash text) OWNER TO postgres;

--
-- Name: create_planet_schema(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION create_planet_schema(name text) RETURNS json
    LANGUAGE plpython3u
    AS $$
    from json import dumps
    query = "CREATE SCHEMA {name}".format(**locals())
    plpy.execute(query)
    return dumps({"schema":name})
  $$;


ALTER FUNCTION public.create_planet_schema(name text) OWNER TO postgres;

--
-- Name: geometry_as_json(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometry_as_json(g geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  SELECT ST_AsGeoJSON(g)
$$;


ALTER FUNCTION public.geometry_as_json(g geometry) OWNER TO postgres;

--
-- Name: planet_osm_create_properties(anyelement); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION planet_osm_create_properties(anyelement) RETURNS json
    LANGUAGE sql STABLE
    AS $_$
    select json_strip_nulls(to_json(to_jsonb($1) - 'way'))
  $_$;


ALTER FUNCTION public.planet_osm_create_properties(anyelement) OWNER TO postgres;

--
-- Name: planet_osm_make_feature_geojson(json, json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION planet_osm_make_feature_geojson(geometry json, properties json) RETURNS json
    LANGUAGE plpython3u
    AS $$
  from json import loads, dumps
  feature = {
    "type":"Feature",
    "geometry":loads(geometry),
    "properties":loads(properties)
  }
  return dumps(feature)
$$;


ALTER FUNCTION public.planet_osm_make_feature_geojson(geometry json, properties json) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: planet_osm_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE planet_osm_line (
    osm_id bigint,
    access text,
    "addr:housename" text,
    "addr:housenumber" text,
    "addr:interpolation" text,
    admin_level text,
    aerialway text,
    aeroway text,
    amenity text,
    area text,
    barrier text,
    bicycle text,
    brand text,
    bridge text,
    boundary text,
    building text,
    construction text,
    covered text,
    culvert text,
    cutting text,
    denomination text,
    disused text,
    embankment text,
    foot text,
    "generator:source" text,
    harbour text,
    highway text,
    historic text,
    horse text,
    intermittent text,
    junction text,
    landuse text,
    layer text,
    leisure text,
    lock text,
    man_made text,
    military text,
    motorcar text,
    name text,
    "natural" text,
    office text,
    oneway text,
    operator text,
    place text,
    population text,
    power text,
    power_source text,
    public_transport text,
    railway text,
    ref text,
    religion text,
    route text,
    service text,
    shop text,
    sport text,
    surface text,
    toll text,
    tourism text,
    "tower:type" text,
    tracktype text,
    tunnel text,
    water text,
    waterway text,
    wetland text,
    width text,
    wood text,
    z_order integer,
    way_area real,
    way geometry(LineString,3857)
);


ALTER TABLE planet_osm_line OWNER TO postgres;

--
-- Name: planet_osm_nodes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE planet_osm_nodes (
    id bigint NOT NULL,
    lat integer NOT NULL,
    lon integer NOT NULL,
    tags text[]
);


ALTER TABLE planet_osm_nodes OWNER TO postgres;

--
-- Name: planet_osm_point; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE planet_osm_point (
    osm_id bigint,
    access text,
    "addr:housename" text,
    "addr:housenumber" text,
    "addr:interpolation" text,
    admin_level text,
    aerialway text,
    aeroway text,
    amenity text,
    area text,
    barrier text,
    bicycle text,
    brand text,
    bridge text,
    boundary text,
    building text,
    capital text,
    construction text,
    covered text,
    culvert text,
    cutting text,
    denomination text,
    disused text,
    ele text,
    embankment text,
    foot text,
    "generator:source" text,
    harbour text,
    highway text,
    historic text,
    horse text,
    intermittent text,
    junction text,
    landuse text,
    layer text,
    leisure text,
    lock text,
    man_made text,
    military text,
    motorcar text,
    name text,
    "natural" text,
    office text,
    oneway text,
    operator text,
    place text,
    population text,
    power text,
    power_source text,
    public_transport text,
    railway text,
    ref text,
    religion text,
    route text,
    service text,
    shop text,
    sport text,
    surface text,
    toll text,
    tourism text,
    "tower:type" text,
    tunnel text,
    water text,
    waterway text,
    wetland text,
    width text,
    wood text,
    z_order integer,
    way geometry(Point,3857)
);


ALTER TABLE planet_osm_point OWNER TO postgres;

--
-- Name: planet_osm_polygon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE planet_osm_polygon (
    osm_id bigint,
    access text,
    "addr:housename" text,
    "addr:housenumber" text,
    "addr:interpolation" text,
    admin_level text,
    aerialway text,
    aeroway text,
    amenity text,
    area text,
    barrier text,
    bicycle text,
    brand text,
    bridge text,
    boundary text,
    building text,
    construction text,
    covered text,
    culvert text,
    cutting text,
    denomination text,
    disused text,
    embankment text,
    foot text,
    "generator:source" text,
    harbour text,
    highway text,
    historic text,
    horse text,
    intermittent text,
    junction text,
    landuse text,
    layer text,
    leisure text,
    lock text,
    man_made text,
    military text,
    motorcar text,
    name text,
    "natural" text,
    office text,
    oneway text,
    operator text,
    place text,
    population text,
    power text,
    power_source text,
    public_transport text,
    railway text,
    ref text,
    religion text,
    route text,
    service text,
    shop text,
    sport text,
    surface text,
    toll text,
    tourism text,
    "tower:type" text,
    tracktype text,
    tunnel text,
    water text,
    waterway text,
    wetland text,
    width text,
    wood text,
    z_order integer,
    way_area real,
    way geometry(Geometry,3857)
);


ALTER TABLE planet_osm_polygon OWNER TO postgres;

--
-- Name: planet_osm_rels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE planet_osm_rels (
    id bigint NOT NULL,
    way_off smallint,
    rel_off smallint,
    parts bigint[],
    members text[],
    tags text[]
);


ALTER TABLE planet_osm_rels OWNER TO postgres;

--
-- Name: planet_osm_roads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE planet_osm_roads (
    osm_id bigint,
    access text,
    "addr:housename" text,
    "addr:housenumber" text,
    "addr:interpolation" text,
    admin_level text,
    aerialway text,
    aeroway text,
    amenity text,
    area text,
    barrier text,
    bicycle text,
    brand text,
    bridge text,
    boundary text,
    building text,
    construction text,
    covered text,
    culvert text,
    cutting text,
    denomination text,
    disused text,
    embankment text,
    foot text,
    "generator:source" text,
    harbour text,
    highway text,
    historic text,
    horse text,
    intermittent text,
    junction text,
    landuse text,
    layer text,
    leisure text,
    lock text,
    man_made text,
    military text,
    motorcar text,
    name text,
    "natural" text,
    office text,
    oneway text,
    operator text,
    place text,
    population text,
    power text,
    power_source text,
    public_transport text,
    railway text,
    ref text,
    religion text,
    route text,
    service text,
    shop text,
    sport text,
    surface text,
    toll text,
    tourism text,
    "tower:type" text,
    tracktype text,
    tunnel text,
    water text,
    waterway text,
    wetland text,
    width text,
    wood text,
    z_order integer,
    way_area real,
    way geometry(LineString,3857)
);


ALTER TABLE planet_osm_roads OWNER TO postgres;

--
-- Name: planet_osm_ways; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE planet_osm_ways (
    id bigint NOT NULL,
    nodes bigint[] NOT NULL,
    tags text[]
);


ALTER TABLE planet_osm_ways OWNER TO postgres;

SET search_path = test2, pg_catalog;

--
-- Name: planet_osm_polygon; Type: TABLE; Schema: test2; Owner: postgres
--

CREATE TABLE planet_osm_polygon (
    osm_id bigint,
    access text,
    "addr:housename" text,
    "addr:housenumber" text,
    "addr:interpolation" text,
    admin_level text,
    aerialway text,
    aeroway text,
    amenity text,
    area text,
    barrier text,
    bicycle text,
    brand text,
    bridge text,
    boundary text,
    building text,
    construction text,
    covered text,
    culvert text,
    cutting text,
    denomination text,
    disused text,
    embankment text,
    foot text,
    "generator:source" text,
    harbour text,
    highway text,
    historic text,
    horse text,
    intermittent text,
    junction text,
    landuse text,
    layer text,
    leisure text,
    lock text,
    man_made text,
    military text,
    motorcar text,
    name text,
    "natural" text,
    office text,
    oneway text,
    operator text,
    place text,
    population text,
    power text,
    power_source text,
    public_transport text,
    railway text,
    ref text,
    religion text,
    route text,
    service text,
    shop text,
    sport text,
    surface text,
    toll text,
    tourism text,
    "tower:type" text,
    tracktype text,
    tunnel text,
    water text,
    waterway text,
    wetland text,
    width text,
    wood text,
    z_order integer,
    way_area real,
    way public.geometry(Geometry,3857)
);


ALTER TABLE planet_osm_polygon OWNER TO postgres;

SET search_path = public, pg_catalog;

--
-- Name: planet_osm_nodes planet_osm_nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY planet_osm_nodes
    ADD CONSTRAINT planet_osm_nodes_pkey PRIMARY KEY (id);


--
-- Name: planet_osm_rels planet_osm_rels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY planet_osm_rels
    ADD CONSTRAINT planet_osm_rels_pkey PRIMARY KEY (id);


--
-- Name: planet_osm_ways planet_osm_ways_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY planet_osm_ways
    ADD CONSTRAINT planet_osm_ways_pkey PRIMARY KEY (id);


--
-- Name: planet_osm_line_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX planet_osm_line_index ON planet_osm_line USING gist (way);


--
-- Name: planet_osm_line_pkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX planet_osm_line_pkey ON planet_osm_line USING btree (osm_id);


--
-- Name: planet_osm_point_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX planet_osm_point_index ON planet_osm_point USING gist (way);


--
-- Name: planet_osm_point_pkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX planet_osm_point_pkey ON planet_osm_point USING btree (osm_id);


--
-- Name: planet_osm_polygon_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX planet_osm_polygon_index ON planet_osm_polygon USING gist (way);


--
-- Name: planet_osm_polygon_pkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX planet_osm_polygon_pkey ON planet_osm_polygon USING btree (osm_id);


--
-- Name: planet_osm_rels_parts; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX planet_osm_rels_parts ON planet_osm_rels USING gin (parts) WITH (fastupdate=off);


--
-- Name: planet_osm_roads_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX planet_osm_roads_index ON planet_osm_roads USING gist (way);


--
-- Name: planet_osm_roads_pkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX planet_osm_roads_pkey ON planet_osm_roads USING btree (osm_id);


--
-- Name: planet_osm_ways_nodes; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX planet_osm_ways_nodes ON planet_osm_ways USING gin (nodes) WITH (fastupdate=off);


--
-- Name: postgraphql_watch_ddl; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER postgraphql_watch_ddl ON ddl_command_end
         WHEN TAG IN ('ALTER DOMAIN', 'ALTER FOREIGN TABLE', 'ALTER FUNCTION', 'ALTER SCHEMA', 'ALTER TABLE', 'ALTER TYPE', 'ALTER VIEW', 'COMMENT', 'CREATE DOMAIN', 'CREATE FOREIGN TABLE', 'CREATE FUNCTION', 'CREATE SCHEMA', 'CREATE TABLE', 'CREATE TABLE AS', 'CREATE VIEW', 'DROP DOMAIN', 'DROP FOREIGN TABLE', 'DROP FUNCTION', 'DROP SCHEMA', 'DROP TABLE', 'DROP VIEW', 'GRANT', 'REVOKE', 'SELECT INTO')
   EXECUTE PROCEDURE postgraphql_watch.notify_watchers_ddl();


ALTER EVENT TRIGGER postgraphql_watch_ddl OWNER TO postgres;

--
-- Name: postgraphql_watch_drop; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER postgraphql_watch_drop ON sql_drop
   EXECUTE PROCEDURE postgraphql_watch.notify_watchers_drop();


ALTER EVENT TRIGGER postgraphql_watch_drop OWNER TO postgres;

--
-- Name: planet_osm_line; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE planet_osm_line TO PUBLIC;


--
-- Name: planet_osm_point; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE planet_osm_point TO PUBLIC;


--
-- Name: planet_osm_polygon; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE planet_osm_polygon TO PUBLIC;


--
-- Name: planet_osm_roads; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE planet_osm_roads TO PUBLIC;


--
-- PostgreSQL database dump complete
--

