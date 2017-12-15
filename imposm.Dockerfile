FROM python:3.6

RUN apt-get update && \
	apt-get install -y \
		build-essential \
		python-dev \
		protobuf-compiler \
		libprotobuf-dev \
		libtokyocabinet-dev \
		python-psycopg2 \
		libgeos-c1 \
		libgdal1-dev \
		libspatialindex-dev \
		inotify-tools \
		bzip2

#python2 dependencies

RUN apt-get install -y python-pip && pip2 install rtree imposm 

#python3 entrypoint dependency
RUN pip install psycopg2

RUN useradd osm -u 1000

RUN mkdir -p /imports/active \
	&&  mkdir /imports/torrents \
	&& mkdir /imports/downloading \
	&& mkdir /imports/archive

COPY ./bin /var/lib/osm2pgsqlauto

RUN chown -R osm:osm /var/lib/osm2pgsqlauto
RUN chown -R osm:osm /imports

WORKDIR /var/lib/osm2pgsqlauto

USER osm

ENTRYPOINT /var/lib/osm2pgsqlauto/imposm_entrypoint