## Nginx  as reverse proxy

```bash
## instal nginx in AmazonLinux 2022**
amazon-linux-extras install nginx1
```
- ngnx home dir : `/etc/nginx`
- conf file : `/etc/nginx/nginx.conf`
- to add a proxy rule to direct request to backend machine add the below line in server block in nginx.conf
    ```conf
    location /some/path/ {
        proxy_pass http://www.example.com/link/;
    }
    
    ### example

    location / {
        proxy_pass http://www.<ip>.com:8080/context/;
    }
    ```

- for conatinerzing , you can prepare this conf file locally and copy it in dockerfile

### Conatinerising

**Dockerfile for nginx**
```Dockerfile
FROM amazonlinux:2

RUN amazon-linux-extras install nginx1 -y
COPY nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g" , "daemon off;"]
CMD ["nginx" "-g" "daemon off;"]
```

- now we need to create the application continer as well , use the dockerfile from lesson 34
- by default containers cannot communicate with each other . to establish comms between conatiners you need a docker network and attach the conatiners to the network created
- containers in docker network can communicate with each other by just the name of the containers. example `ping <container-name>` will work as well as  `telnet <container-name> <port>` will work
- so , add the below proxy pass directive in nginx conf
```conf
    location / {
        proxy_pass http://<conatiner-name>:8080/context/;
    }
```
example
```
    location / {
        proxy_pass http://<conainer-name>:8080/dptweb-1.0/;
    }
```
- Now create a docker netwiork and attach th containers to it
- you need to attach this network to all container that need to be part of the network
```bash
# ceate docker network
docker network create <name>`

# list docker network
docker network ls

# run a container by attaching it to a network
docker run --name <container-name> -d -p 8080:8080 --network <network-name> <image-name>
```

