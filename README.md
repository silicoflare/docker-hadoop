# Hadoop on Docker
## Linux/WSL
### Installation
```bash
curl -fsSL https://bit.ly/hadock-install -o bin/hadock && chmod +x bin/hadock
```
if you're using WSL make sure to update it
```powershell
wsl.exe --update
```
### Usage
```bash
hadock
```
### Update
```bash
hadock --uninstall
curl -fsSL https://bit.ly/hadock-install | bash
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
