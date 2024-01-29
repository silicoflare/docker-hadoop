# Hadoop on Docker
Use this to get a quick version of Hadoop to run on Docker.

1. Install Docker
<br>

2. Clone this repository
```bash
git clone https://github.com/silicoflare/docker-hadoop
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
docker run -it -p 9870:3000 --name anyname hadoop bash
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