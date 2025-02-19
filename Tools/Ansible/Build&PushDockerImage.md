git url : https://github.com/ashokitschool/maven-web-app.git


```yaml
---
- name: Dockerisation
  hosts: docker
  remote_user: ec2-user
  become: true
  gather_facts: true

  tasks:
  - name: Git Checkout
    git:
      repo: https://github.com/ashokitschool/maven-web-app.git
      dest: ~/app

  - name: Build image from Dockerfile
    docker_image:
      name: <name-of-image>
      tag: <tag>
      build:
        path: <path-to-dockerfile>
      source: build
- name: Log into DockerHub
    docker_login:
      username: falcon646
      password: 9669131425

  - name: Tag and push to docker hub
    docker_image:
      name: testdockerimage:v1
      repository: falcon646/myimage:7.56
      push: yes
      source: local


