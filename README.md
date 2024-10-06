# Hadoop on Docker
## Linux/WSL
### Installation
if you're using WSL make sure to update it
```powershell
wsl.exe --update
```
Installation Script
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
This command copies ```path/to/file``` from host to ```/home``` on your docker container
#### Running multiple instances
```bash
hadock_again
```
Use this command to open another shell in the same docker instance
### Uninstallation
```bash
hadock --uninstall
```

Check the [wiki](https://github.com/silicoflare/docker-hadoop/wiki) for a full guide to use this docker image.
