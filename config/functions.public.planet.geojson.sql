/* EXAMPLE Postgraphql query
 - return first 2 results
 - With total count
 - Nextpage convience method
 
{
  allPlanetOsmPolygons(first:2)
  {
    pageInfo {
      hasNextPage
    }
    totalCount
    edges {
      cursor
      node {
        geojson
      }
    }
  }
}*/

drop function if exists planet_osm_make_feature_geojson;
CREATE FUNCTION planet_osm_make_feature_geojson (geometry json, properties json)
  RETURNS json
AS $$
  from json import loads, dumps
  feature = {
    "type":"Feature",
    "geometry":loads(geometry),
    "properties":loads(properties)
  }
  return dumps(feature)
$$ LANGUAGE plpython3u;

drop function if exists planet_osm_polygon_geojson;
create or replace function planet_osm_polygon_geojson(feature planet_osm_polygon) 
  returns json as $$
    select planet_osm_make_feature_geojson(
      planet_osm_polygon_geometry(feature),
      planet_osm_polygon_properties(feature)
    )
  $$ language sql stable;

drop function if exists planet_osm_point_geojson;
create or replace function planet_osm_point_geojson(feature planet_osm_point) 
  returns json as $$
    select planet_osm_make_feature_geojson(
      planet_osm_point_geometry(feature),
      planet_osm_point_properties(feature)
    )
  $$ language sql stable;

drop function if exists planet_osm_line_geojson;
create or replace function planet_osm_line_geojson(feature planet_osm_line) 
  returns json as $$
    select planet_osm_make_feature_geojson(
      planet_osm_line_geometry(feature),
      planet_osm_line_properties(feature)
    )
  $$ language sql stable;

drop function if exists planet_osm_roads_geojson;
create or replace function planet_osm_roads_geojson(feature planet_osm_roads)
  returns json as $$
    select planet_osm_make_feature_geojson(
      planet_osm_roads_geometry(feature),
      planet_osm_roads_properties(feature)
    )
  $$ language sql stable;
