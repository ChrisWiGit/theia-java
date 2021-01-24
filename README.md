# theia-java
A custom Docker image containing the theia-ide for Java development

# Fork
> This fork is not available on docker hub. Check the Usage chapter.

This fork has been updated to
* Java OpenJDK 14
* Gradle 6.7.1
* Node 12.20.1 (latest supported version < 13 by Theia)

Due to problems with _latest_ Theia version I decided to use version 1.9 (`1.9.package.json` contains 1.9 Theia modules)

In addition, the following convenience additions have been applied:
* sudo (`sudo su` to root) without password
* ps
* Midnight commander
* Run gradle beforehand to start deamon
* Theia extension _richardwillis.vscode-gradle_ (https://open-vsx.org/extension/richardwillis/vscode-gradle)
  
Some _fixes_ were also applied
* delete `/temp` contents
* increased `max_user_watches`for system file watchers on large projects
* JavaJDK resides in `/usr/local/openjdk` instead of with added version postfix.

## Features
* Based on https://github.com/theia-ide/theia-apps/tree/master/theia-java-docker (link broken)
* The Java used is OpenJDK version instead of IBM one.
* Java, Maven and Gradle are copied over from another Docker images instead of using the distro version.
* Project dir is "/home/workspaces" instead of "/home/project"
* Small footprint: about 1.62 GB instead of 2.2GB

## Usage
```
$ docker volume create theia_workspaces
$ docker build -t theia-java:custom .
$ docker run -d --name theia-java --restart=unless-stopped --init -p 3000:3000 -v theia_data:/home/workspaces theia-java:custom
```
