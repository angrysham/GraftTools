# Scripts to manage GraftProject Build using AWS infrastructure/locally.

[`build.sh`] --- Sript to build Graft Project(https://github.com/graft-project/graft-ng) branch:master using CMake. Can be used both locally and remotely(as an argument to runRemote.sh).
[`deb_graftnode.sh`] -- Script to prepare graftnode-\$version.deb package.
[`deb_supernode.sh`] -- Script to prepare graft-supernode-\$version.deb package.
[`runRemote.sh`] -- Script to run build, deb packaging any other custom script remotely.  
[`spot.sh`] -- Script to create, view and terminate AWS spot requests using `spot_fleet.json` config file.
[`spot_fleet_template.json`] -- Template used to create spot_fleet.json.
[`upload.sh`] -- Script to upload any `*.deb` package to `APT` repository. 
