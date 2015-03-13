# Map tile server on Centos

Instructions for setting up a [map tile](https://msdn.microsoft.com/en-us/library/bb259689.aspx) server using [mod_tile](http://wiki.openstreetmap.org/wiki/Mod_tile) on Centos.

This is cobbled together from various sources across the internet. The best of which being [this guide for Ubuntu (12.04)](https://switch2osm.org/serving-tiles/manually-building-a-tile-server-12-04/).

## Host development set up steps

- Ensure you have at least Ansible 1.8 installed on your host `brew update && brew install ansible`.
- Ensure you have at least Vagrant 1.7 installed on your host https://www.vagrantup.com/downloads.html.
- Install the [vagrant-cachier plugin](https://github.com/fgrehm/vagrant-cachier) to save download time while developing `vagrant plugin install vagrant-cachier`.
- Install the [vagrant-vbox-snapshot](https://github.com/dergachev/vagrant-vbox-snapshot) plugin so you can `vagrant snapshot take` and `vagrant snapshot back`.

## Map tile server build steps

Set up the guest VM with Vagrant by running `vagrant up` on host.

The remaining steps are manually carried out on the guest OS. So `vagrant ssh` in and go through the steps below. **NOTE** The steps below should be added into Ansible playbooks.

### Build mod_tile

```sh
# All build dependencies should be installed via the Ansible playbooks
cd tmp
git clone https://github.com/openstreetmap/mod_tile.git
cd mod_tile
git checkout 774fc7a4470f655393ad6dd76c5c8bf3efe7923d
./autogen.sh
./configure
make
sudo make install
sudo make install-mod_tile
sudo ldconfig
```

## Install mapnik

```sh
cd /tmp
git clone git://github.com/mapnik/mapnik
cd mapnik
git checkout origin/2.3.x
python scons/scons.py configure INPUT_PLUGINS=all OPTIMIZATION=3 SYSTEM_FONTS=/usr/share/fonts/ PG_CONFIG=/usr/pgsql-9.4/bin/pg_config BOOST_INCLUDES=/usr/local/include/boost/
python scons/scons.py
sudo python scons/scons.py install
sudo ldconfig
sudo cp -R /tmp/mapnik/fonts /usr/local/lib/mapnik/fonts
```


### Build osm2pqsql

```sh
sudo yum install gcc-c++ libxml2-devel geos-devel bzip2-devel proj-devel protobuf-compiler postgresql94-devel postgresql94-contrib protobuf-c-devel
cd /tmp
git clone https://github.com/openstreetmap/osm2pgsql.git
cd osm2pgsql
git checkout 0.87.2
./autogen.sh
./configure --with-postgresql=/usr/pgsql-9.4/bin/pg_config
make
sudo make install
```

### Create a database and Enable GIS on it

```sh
createdb -E UTF8 gis
psql -f /usr/pgsql-9.4/share/contrib/postgis-2.1/postgis.sql -d gis
psql -f /usr/local/share/osm2pgsql/900913.sql -d gis
```

### Download and load the OpenStreetMap data

**NOTE** this is flaky. I get a killed message at the end of the import so I'm not 100% sure this is working correctly even though I am seeing a top level tile rendered.

```sh
cd ~
curl -O http://download.geofabrik.de/australia-oceania-latest.osm.pbf
# This will take a while and can be flaky at times...
osm2pgsql --slim -d gis -C 2048 --number-processes=2 --cache-strategy=dense australia-oceania-latest.osm.pbf
```

### Install map styles

```sh
sudo yum install svn bzip2
mkdir -p ~/src
cd ~/src
svn co http://svn.openstreetmap.org/applications/rendering/mapnik mapnik-style
cd ~/src/mapnik-style
sudo ln -s /usr/bin/bunzip2 /bin
sudo ./get-coastlines.sh /usr/local/share
```

### Configure mapnik style-sheet

```sh
cd ~/src/mapnik-style/inc
cp /vagrant/fontset-settings.xml.inc .
cp /vagrant/datasource-settings.xml.inc .
cp /vagrant/settings.xml.inc .
```

### Configure renderd

```sh
sudo cp /vagrant/renderd.conf /usr/local/etc/
sudo mkdir /var/run/renderd
sudo mkdir /var/lib/mod_tile
```

**Note** renderd is working fine with mod_tile when run manually via the vagrant account.

```sh
renderd -f -c /usr/local/etc/renderd.conf`
```

#### TODO: Add renderd service startup script

A startup script needs to be added for renderd. We will need to ensure the `/etc/init.d/renderd` script runs as the correct user and has access to`/var/run/renderd` and `/var/lib/mod_tile` (via chown if necessary). This user will also need to access the `gis` database.

An Ubuntu startup script is included at `/vagrant/renderd.init`. It does not work on Centos.

Likely setup steps will be:

```sh
sudo cp /vagrant/renderd.init /etc/init.d/renderd
sudo chmod u+x /etc/init.d/renderd
sudo ln -s /etc/init.d/renderd /etc/rc2.d/S20renderd
```

### Configure mod_tile

Assuming you are running renderd manually above open a new terminal and `vagrant ssh`. Then:

```sh
sudo cp /vagrant/mod_tile.conf /etc/httpd/conf.d
sudo cp /vagrant/httpd.conf /etc/httpd/conf
sudo /etc/init.d/httpd restart
```

## Access the webserver to see tiles etc

Check out tiles on your host at http://localhost:8192/osm_tiles/0/0/0.png

Check out mod_tiles stats on your host at http://localhost:8192/mod_tile


## Links

- [Manually building a tile server on Ubuntu (12.04)](https://switch2osm.org/serving-tiles/manually-building-a-tile-server-12-04/)
- [Loading OSM data](https://switch2osm.org/loading-osm-data/)
- [Build your own open map server on Ubuntu](http://weait.com/content/build-your-own-openstreetmap-server-lucid)
- [Install an openstreetmap server on Centos](http://duemafoss.blogspot.com.au/2014/02/installation-of-openstreetmap-server-on.html)
- [Mapnik Centos Installation](https://github.com/mapnik/mapnik/wiki/CentOS_RHEL)
- [The mod_tile wiki page](http://wiki.openstreetmap.org/wiki/Mod_tile)
- [The mod_tile repo](https://github.com/openstreetmap/mod_tile)
- [mapnik install instructions for Centos](https://github.com/mapnik/mapnik/wiki/CentOS_RHEL)

