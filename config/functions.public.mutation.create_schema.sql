/*

- input maps to function imputs as object
- output maps to returns json
mutation createProject{
  createPlanetSchema(
    input:{
      name:"test2"
    }
  )
  {#output
    clientMutationId
    json
  }
}
*/
drop function if exists create_planet_schema;
create or replace function create_planet_schema(name text) 
  returns json 
  AS $$
    from json import dumps
    query = "CREATE SCHEMA {name}".format(**locals())
    plpy.execute(query)
    return dumps({"schema":name})
  $$ LANGUAGE plpython3u volatile;
/*

*/
drop function if exists copy_planet_table_to_schema_by_geohash;
create or replace function copy_planet_table_to_schema_by_geohash(schema text, oldtable text, newtable text, geohash text) 
  returns json 
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
  $$ LANGUAGE plpython3u volatile;