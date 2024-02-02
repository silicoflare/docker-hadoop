# Hadoop on Docker
Use this to get a quick version of Hadoop to run on Docker.

1. Install Docker on your host PC
<br>

2. Clone your platform specific branch of this repository
```bash
# Windows
git clone -b windows --single-branch https://github.com/silicoflare/docker-hadoop

# Mac
git clone -b mac --single-branch https://github.com/silicoflare/docker-hadoop

# Linux
git clone -b linux --single-branch https://github.com/silicoflare/docker-hadoop
```
<br>

3. Navigate to the directory
```bash
cd docker-hadoop
```
<br>

4. Build the docker image (you may need to use sudo)
```bash
docker build -t hadoop .
```
<br>

5. Wait for the build to finish
<br>

6. Create a new container using the newly created image
```bash
docker run -it -p 9870:9870 -p 8088:8088 -p 9864:9864 --name anyname hadoop bash
```
<br>

7. Once the prompt appears, execute the following command to initialize everything:
```bash
init
```
<br>

8. From the next time, just run this to open the prompt. Use the same name that you used to create the container.
```bash
docker start anyname
docker exec -it anyname bash
```

Once in, execute:
```bash
restart
```
