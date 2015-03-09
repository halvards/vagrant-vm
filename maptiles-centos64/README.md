# Map tile server on Centos

Instructions for setting up a [map tile](https://msdn.microsoft.com/en-us/library/bb259689.aspx) server using [mod_tile](http://wiki.openstreetmap.org/wiki/Mod_tile) on Centos.

## Host development set up steps

- Ensure you have at least Ansible 1.8 installed on your host `brew update && brew install ansible`.
- Ensure you have at least Vagrant 1.7 installed on your host https://www.vagrantup.com/downloads.html.
- Install the [vagrant-cachier plugin](https://github.com/fgrehm/vagrant-cachier) to save download time while developing `vagrant plugin install vagrant-cachier`.
- Install the [vagrant-vbox-snapshot](vagrant plugin install vagrant-vbox-snapshot) plugin so you can `vagrant snapshot take` and `vagrant snapshot back`.

## Map tile server build steps

**NOTE** These steps should be added into Ansible play books

- Download the OpenStreetMap data from: `curl  -O -J http://download.geofabrik.de/australia-oceania-latest.osm.pbf`.

- Set up the guest VM with Vagrant: `vagrant up`

## Links

- [The mod_tile wiki page](http://wiki.openstreetmap.org/wiki/Mod_tile)
- [The mod_tile repo](https://github.com/openstreetmap/mod_tile)
- [Build your own open map server on Ubuntu](http://weait.com/content/build-your-own-openstreetmap-server-lucid)
- [mapnik install instructions for Centos](https://github.com/mapnik/mapnik/wiki/CentOS_RHEL)

