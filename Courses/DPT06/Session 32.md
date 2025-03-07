```bash
# to copy file fro local machine inside container
docker cp <source_file/folder> <containerid>:<destinationpath>
docker cp . 070asdgk:usr/local/apach2/htdocs/

# create a docker image out of running container
docker commit <cont_id> <image_name>:<tag>

# retag existing image
docker tag <img:tag> <imge:new-tag>

# push image to docker hub
docker push <repo_name>:<tag>
docker push ashwin/webapp:v6

# repo name : <username>/<app-name> eg ashwin/frontendapp
```

**Building Docker images using Dockerfile**

Dockerfile images specifications
1. Sourceimage
2. pcakages
3. application containerid
4. entry point
5. other customisation


**Sample Dockerfile syntax**
```Dockerfile
FROM <base-img>
COPY <path-to-file> <destiation-path>
```
```bash
# create an image from Dockerfile
docker build -t <imag-name:tag> <path-to-Dockerfile>
```
