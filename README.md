Preamble
===
osm2postgresauto is an *** Experimental *** development environment that combines the following technologies:
	- Postgres w/PostGIS for database backend & spatial data management
	
	- qBittorrent for massive data transfer/automation
	
	- pgAdmin for database management
	
	- graphql via Postgraphql (postgraphql/postgraphql)

The hope is to allow rapid development of a graphql api and management engine for postgres & postgis.

* * *

Installation
---
```
git clone --depth=1 https://github.com/disarticulate/osm2pgsqlauto
cd osm2pgsqlauto
docker-compose up
```

### Docker & Docker-compose installation:
- https://docs.docker.com/engine/installation/
- https://docs.docker.com/compose/install/

Development Organization
---
- /
  - *.Dockerfile
    - postgres (https://hub.docker.com/r/mdillon/postgis/)
    - pgadmin (https://hub.docker.com/r/dpage/pgadmin4/)
    - qtorrent (https://hub.docker.com/r/linuxserver/qbittorrent/)
    - postgraphql (https://github.com/postgraphql/postgraphql)
  - *.env * Environment files for dockers
  - docker-compose.yml * primary control
- bin/
    - postgres entrypoint
    - hotreload agents
        - watcher_config.sh for postgres/postgraphsql development
        - watcher_imports.sh for automated torrents & OSM file import
- config/ ## Hotreloading (watcher_config)
    - postgres init scripts (0.* on first postgres start)
    - postgres / graphql functions (functions.*)
- imports/
    - active (automated recursive OSM data import via watcher_imports.sh)
    - archive (finished files from active & torrents)
    - downloading (torrent service places unfinished downloads)
    - torrents (qtorrent watches for ttorrents and automates downloads, finished files get placed in active)
- data/ 
	- (postgres data persistence location)
- .pgadmin/ 
	- (pgadmin data persistence location)
- .graphql/ 
	- entrypoint
- .qtorrent/config 
	- (config files for qtorrent)

Usage
---
### qtorrent webui
	- http://localhost:5051
	- user: osm
	- password: osm2postgresql-auto

	Documentation: https://github.com/qbittorrent/qBittorrent/wiki

### pgadmin webui
	- http://localhost:5050
	- user: admin@osm2pgsqlauto.com
	- password: agoodpassword

	Documentation: https://www.pgadmin.org/

### graphql dev webui

#### dev webui
	- http://localhost:5052/graphiql

	Documentation: https://github.com/graphql/graphiql

#### endpoint
	- http://localhost:5052/graphql
	
	Documentation: 

### OpenStreetMap Torrents:
- https://archive.org/details/osmdata

Known issues
---
### qtorrent 

* Uses inotify, need to set higher if you receive the following:

> inotify_add_watch("/torrents") failed "No space left on device"

* qtorrent (or elsewhere), it means your kernel (outside of docker) requires more inotify watchers.

Run outside of docker: `echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p`
