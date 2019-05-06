# Graft tools
## Folders and files

### [`aws_build`] -- Scripts to manage GraftProject Build using AWS infrastructure.
### [`packer`] -- Configuration to register custom AMI using packer.
### [`terraform`] -- Set of files to provision Graft network using terraform and debpoy latest versions of Debian packages from *APT* repo

  ##
  ## [`aws_build`]
Scripts used to build GraftNG project using CMake locally or @AWS resources

### Steps to perform build localy
- Check for Environment variables
- Run ./build.sh which performs project compillation. One can change variables declared in the header to customize build folder, sources location etc.
- Run deb_graftnode.sh to register graftnode-\$version.deb package
- Run deb_supernode.sh to register graft-supernode-\$version.deb package
- Run upload.sh to upload all `*.deb` packages to `APT` repository (Check env variables used)

### Steps to perform build using AWS resources
- Check for Environment variables
- Run `spot.sh status` to check current spot status i.e.
```console
$ ./spot.sh status
You have active: 1 spot request(s)
```
One can change AMI ID which is used when build host is initially provisioned:
```console
$ ./spot.sh modify_json ami-06a557a564d73800b
```
Command should generate file named `spot_fleet.json` which is used for spot request placing.

- Once you have `spot_fleet.json` and 0 active spot requests(returned by status subcommand) new request can be placed:
```console
$ ./spot.sh create
```
Once instance is Running steps performed for local build are executed in the same order but this time it should be invoked using `runremote.sh` script i.e.
```console
$ runRemote.sh build.sh
$ runRemote.sh deb_graftnode.sh
$ runRemote.sh deb_supernode.sh
$ runRemote.sh upload.sh
```
