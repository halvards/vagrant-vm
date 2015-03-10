# Map tile server on Centos

Instructions for setting up a [map tile](https://msdn.microsoft.com/en-us/library/bb259689.aspx) server using [mod_tile](http://wiki.openstreetmap.org/wiki/Mod_tile) on Centos.

## Host development set up steps

- Ensure you have at least Ansible 1.8 installed on your host `brew update && brew install ansible`.
- Ensure you have at least Vagrant 1.7 installed on your host https://www.vagrantup.com/downloads.html.
- Install the [vagrant-cachier plugin](https://github.com/fgrehm/vagrant-cachier) to save download time while developing `vagrant plugin install vagrant-cachier`.
- Install the [vagrant-vbox-snapshot](vagrant plugin install vagrant-vbox-snapshot) plugin so you can `vagrant snapshot take` and `vagrant snapshot back`.

## Map tile server build steps

- Set up the guest VM with Vagrant: `vagrant up`

## Manual steps

**NOTE** These steps should be added into Ansible playbooks

Build osm2pqsql

```sh
$ sudo yum install gcc-c++ libxml2-devel geos-devel bzip2-devel proj-devel protobuf-compiler postgresql94-devel postgresql94-contrib protobuf-c-devel
$ cd /tmp
$ git clone https://github.com/openstreetmap/osm2pgsql.git
$ cd osm2pgsql
$ git checkout 0.87.2
$ ./autogen.sh
$ ./configure --with-postgresql=/usr/pgsql-9.4/bin/pg_config
$ make
$ sudo make install
```

Create a database and Enable GIS on it

```sh
$ createdb gis
$ psql -d gis -c 'CREATE EXTENSION postgis; CREATE EXTENSION hstore;'
```

Download and load the OpenStreetMap data

```sh
$ curl  -O -J http://download.geofabrik.de/australia-oceania-latest.osm.pbf
$ osm2pgsql --slim -d gis -C 2048 --number-processes=1 --cache-strategy=dense australia-oceania-latest.osm.pbf
```

## Links

- [Build your own open map server on Ubuntu](http://weait.com/content/build-your-own-openstreetmap-server-lucid)
- [Install an openstreetmap server on Centos](http://duemafoss.blogspot.com.au/2014/02/installation-of-openstreetmap-server-on.html)
- [The mod_tile wiki page](http://wiki.openstreetmap.org/wiki/Mod_tile)
- [The mod_tile repo](https://github.com/openstreetmap/mod_tile)
- [mapnik install instructions for Centos](https://github.com/mapnik/mapnik/wiki/CentOS_RHEL)

