## Installation
```
git clone --depth=1 https://...
cd osm2pgsqlauto
docker-compose up
```

## Usage

### qtorrent webui
More details at https://hub.docker.com/r/linuxserver/qbittorrent/
http://localhost:8080
user: osm
password: osm2postgresql-auto

### OpenStreetMap Torrents:
https://archive.org/details/osmdata

## Known issues

---
* qtorrent requires inotify, need to set higher if you receive the following:
- inotify_add_watch("/torrents") failed: "No space left on device"

in qtorrent, it means your kernel (outside of docker) requires more inotify watchers.

Run outside of docker:
```
sysctl -w fs.inotify.max_user_watches=16384
```