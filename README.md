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

### Current drawbacks

* The release version `0.29.0` or newer of the Theia extenension Java Debug does not work with remote debugging (i.e. attach configuration in launch.js). Version `0.28.0` works for me. This version is set within the `1.9.package.json` file.

```
root ERROR Error starting the debug session Error: It is not possible to provide debug adapter executable.        
    at DebugExtImpl.<anonymous> (/home/theia/node_modules/@theia/plugin-ext/lib/plugin/node/debug/debug.js:709:39)
    at step (/home/theia/node_modules/@theia/plugin-ext/lib/plugin/node/debug/debug.js:33:23)
    at Object.next (/home/theia/node_modules/@theia/plugin-ext/lib/plugin/node/debug/debug.js:14:53)
    at fulfilled (/home/theia/node_modules/@theia/plugin-ext/lib/plugin/node/debug/debug.js:5:58)
    at processTicksAndRejections (internal/process/task_queues.js:97:5)
```

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
