# Map tile server on Centos

Instructions for setting up a [map tile](https://msdn.microsoft.com/en-us/library/bb259689.aspx) server using [mod_tile](http://wiki.openstreetmap.org/wiki/Mod_tile) on Centos.

This is cobbled together from various sources across the internet. The best of which being [this guide for Ubuntu (12.04)](https://switch2osm.org/serving-tiles/manually-building-a-tile-server-12-04/).

Big thanks to [Ray Grasso](https://github.com/grassdog) for working out all the necessary steps.

## Host development set up steps

- Ensure you have at least Ansible 1.8 installed on your host `brew update && brew install ansible`.
- Ensure you have at least Vagrant 1.7 installed on your host https://www.vagrantup.com/downloads.html.
- Install the [vagrant-cachier plugin](https://github.com/fgrehm/vagrant-cachier) to save download time while developing `vagrant plugin install vagrant-cachier`.
- Install the [vagrant-vbox-snapshot](https://github.com/dergachev/vagrant-vbox-snapshot) plugin so you can `vagrant snapshot take` and `vagrant snapshot back`.

## Map tile server build steps

Set up the guest VM with Vagrant by running `vagrant up` on host.

That's it! It'll take a while (easily an hour, more if you have a slow
internet connection), but you'll be left with
a working map tile server that can serve tiles for Australia.

Update the scripts if you want to serve tiles for other countries or
regions (see `modules/gis-el/playbooks/osm-australia.yml`)

## Access the webserver to see tiles

Check out tiles on your host at http://localhost:8192/osm_tiles/0/0/0.png or http://localhost:8192/osm_tiles/17/118373/80321.png

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

