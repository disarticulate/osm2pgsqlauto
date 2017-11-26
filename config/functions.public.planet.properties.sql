/* EXAMPLE Postgraphql query
 - return first 2 results
 - who match the condition building="yes"
 - With total count
 - Nextpage convience method
 - building property
{
  allPlanetOsmPolygons(first:2,
    condition:{
      building:"yes"
    }
  )
  {
    pageInfo {
      hasNextPage
    }
    totalCount
    edges {
      cursor
      node {
        building
        geojson
      }
    }
  }
}*/

drop function if exists planet_osm_create_properties;
create or replace function public.planet_osm_create_properties(anyelement)
  returns json as $$
    select json_strip_nulls(to_json(to_jsonb($1) - 'way'))
  $$ language sql stable;

drop function if exists planet_osm_polygon_properties;
create or replace function planet_osm_polygon_properties(feature planet_osm_polygon) 
  returns json as $$
    select planet_osm_create_properties(feature)
  $$ language sql stable;

drop function if exists planet_osm_point_properties;
create or replace function planet_osm_point_properties(feature planet_osm_point) 
  returns json as $$
    select planet_osm_create_properties(feature)
  $$ language sql stable;

drop function if exists planet_osm_line_properties;
create or replace function planet_osm_line_properties(feature planet_osm_line) 
  returns json as $$
    select planet_osm_create_properties(feature)
  $$ language sql stable;

drop function if exists planet_osm_roads_properties;
create or replace function planet_osm_roads_properties(feature planet_osm_roads)
  returns json as $$
    select planet_osm_create_properties(feature)
  $$ language sql stable;