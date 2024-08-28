# Hadoop on Docker
## Linux/WSL
### Installation
```bash
sudo curl -o /usr/bin/hadock https://gist.githubusercontent.com/aryan-212/57261fabb2d106c1e2214dc8681099f3/raw/HadoopInstall.sh && sudo chmod +x /usr/bin/hadock && hadock
```
### Usage
```bash
hadock
```
#### Copying from host
```bash
dockcp /path/to/file
```
This command copies the file or directory from host to ```/Mounted``` in your docker container
### Uninstallation
```bash
hadock --uninstall
```

Check the [wiki](https://github.com/silicoflare/docker-hadoop/wiki) for a full guide to use this docker image.
