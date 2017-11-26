FROM mdillon/postgis

RUN apt-get update && apt-get install -y osm2pgsql inotify-tools postgresql-plpython3-10
RUN mkdir /var/log/opsm2pgsqlauto \ 
	&& mkdir /var/log/osm2pgsqlauto \
	&& mkdir -p /downloads/partial

RUN usermod -u 1000 postgres && groupmod -g 1000 postgres

RUN mkdir -p /imports/active \
	&&  mkdir /imports/torrents \
	&& mkdir /imports/downloading \
	&& mkdir /imports/archive

COPY ./bin /var/lib/osm2pgsqlauto

RUN chown -R postgres:postgres /var/lib/osm2pgsqlauto
RUN chown -R postgres:postgres /imports

WORKDIR /var/lib/osm2pgsqlauto

ENTRYPOINT /var/lib/osm2pgsqlauto/entrypoint