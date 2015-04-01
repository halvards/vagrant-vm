# Map tile server on Ubuntu

Instructions for setting up a [map tile](https://msdn.microsoft.com/en-us/library/bb259689.aspx) server using [mod_tile](http://wiki.openstreetmap.org/wiki/Mod_tile) on Ubuntu 14.04 (Trusty Tahr).

This is cobbled together from various sources across the internet. The best of which being [this guide for Ubuntu 12.04](https://switch2osm.org/serving-tiles/manually-building-a-tile-server-12-04/).

## Host development set up steps

- Ensure you have at least Ansible 1.8 installed on your host `brew update && brew install ansible`.
- Ensure you have at least Vagrant 1.7 installed on your host https://www.vagrantup.com/downloads.html.
- Optional: Install the [vagrant-cachier plugin](https://github.com/fgrehm/vagrant-cachier) to save download time while developing `vagrant plugin install vagrant-cachier`.
- Optional: Install the [vagrant-vbox-snapshot](https://github.com/dergachev/vagrant-vbox-snapshot) plugin so you can `vagrant snapshot take` and `vagrant snapshot back`.

This process only works for Mac or Linux hosts. If you want to use this on a Windows host, the Vagrantfile must be modified. See `nodejs-ubuntu64/Vagrantfile` for an example of how to achieve this.

## Map tile server build steps

Set up the guest VM with Vagrant by running `vagrant up` on host.

That's it! It'll take a while (easily an hour, more if you have a slow internet connection), but you'll be left with a working map tile server that can serve tiles for Australia.

Update the scripts if you want to serve tiles for other countries or regions (see `modules/gis/playbooks/osm-australia.yml`)

## Access the webserver to see tiles

Check out tiles on your host at <http://localhost:8194/osm_tiles/0/0/0.png> or <http://localhost:8194/osm_tiles/17/118373/80321.png>

Check out mod_tiles stats on your host at <http://localhost:8194/mod_tile>

## Access the PostGIS database

Here are the connection details if you want to explore the raw data:

- Host: `localhost`
- Port: `8195` (from the host OS, or `5432` from the Ubuntu guest OS)
- Database: `osm`
- Username: `vagrant`
- Password: `vagrant`

## Links

- [Manually building a tile server on Ubuntu (12.04)](https://switch2osm.org/serving-tiles/manually-building-a-tile-server-12-04/)
- [Loading OSM data](https://switch2osm.org/loading-osm-data/)
- [Build your own open map server on Ubuntu](http://weait.com/content/build-your-own-openstreetmap-server-lucid)
- [The mod_tile wiki page](http://wiki.openstreetmap.org/wiki/Mod_tile)
- [The mod_tile repo](https://github.com/openstreetmap/mod_tile)

