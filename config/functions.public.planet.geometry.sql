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
drop function if exists planet_osm_polygon_geometry;
create or replace function planet_osm_polygon_geometry(feature planet_osm_polygon) 
  returns json as $$
    select ST_AsGeoJSON(feature.way)::json
  $$ language sql stable;

drop function if exists planet_osm_point_geometry;
create or replace function planet_osm_point_geometry(feature planet_osm_point) 
  returns json as $$
    select tST_AsGeoJSON(feature.way)::json
  $$ language sql stable;

drop function if exists planet_osm_line_geometry;
create or replace function planet_osm_line_geometry(feature planet_osm_line) 
  returns json as $$
    select ST_AsGeoJSON(feature.way)::json
  $$ language sql stable;

drop function if exists planet_osm_roads_geometry;
create or replace function planet_osm_roads_geometry(feature planet_osm_roads)
  returns json as $$
    select ST_AsGeoJSON(feature.way)::json
  $$ language sql stable;