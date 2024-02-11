
**configuring apache web server manually**
- create linux server
- install httpd  -> yum intsall httpd -y
- intall git  -> yum install 
- generate ssh keys
    - `ssh-keygen -t rsa`
- update permissions
    - chmod -R root:root .ssh
    - 700 for .ssh folder -> chmod 700 .ssh
    - 600 for id_rsa -> chmod 600 id_rsa
- configure ssh public key in bitbucket
    - bitbucket -> repo -> repo settings -> access keys -> add public key
- add the repo domain to the knownhost files to avoid prompt when runing git clone
    - `ssh-keyscan bitbucket.org >> /home/.ssh/known_hosts`
- clone repo on using ssh 
    - `git clone <url>`
- copy the code to the web server root path
    - `cd <code dir>`
    - `cp . pr ./* /var/www/html`
- restart web server
    - `systemcl restart httpd`


**Converting the manual steps above to Dockerfile**

```Dockerfile
FROM amazonlinux

RUN yum install httpd -y
RUN yum install git -y

RUN mkdir /root/.ssh
COPY .id_rsa /root/.ssh (keys will not be created in dockerfile , its created locally and copied to the container )
RUN chown -R root:root /root/.ssh 
RUN chmod 700 /root/.ssh
RUN chmod 600 /root/.ssh/id_rsa
RUN ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts

RUN git clone <url>
RUN cp -pr <code-dir>/* /var/www/html/
RUN systemcl start httpd
```

**Customizations**
```Dockerfile
FROM amazonlinux

RUN yum install httpd -y && \
    yum install git -y

RUN mkdir /root/.ssh
COPY .id_rsa /root/.ssh

RUN chown -R root:root /root/.ssh && \
    chmod 700 /root/.ssh && \
    chmod 600 /root/.ssh/id_rsa && \
    ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts

RUN git clone <url> /var/www/html

CMD ["/usr/sbin/httpd","-D","FOREGROUND"]
```