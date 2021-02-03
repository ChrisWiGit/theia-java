FROM maven:3-openjdk-14-slim as maven-base
FROM gradle:6.7.1-jre as gradle-base
FROM node:12.20.1-slim

# Metadata
LABEL org.label-schema.schema-version = "1.0" \
      org.label-schema.name="theia-java" \
      org.label-schema.description="A Docker image containing the theia-ide for Java development" \
      org.label-schema.vcs-url="https://github.com/ChrisWiGit/theia-java" \
      org.label-schema.version="1.0.2"

# remember to set change openjdk-14 if you have changed the jdk version
COPY --from=maven-base /usr/local/openjdk-14 /usr/local/openjdk
COPY --from=maven-base /usr/share/maven /usr/share/maven
COPY --from=gradle-base /opt/gradle /opt/gradle

ENV DEBIAN_FRONTEND=noninteractive \
    JAVA_HOME=/usr/local/openjdk \
    MAVEN_HOME=/usr/share/maven \
    GRADLE_HOME=/opt/gradle \
    PATH=/usr/local/openjdk/bin:$PATH

RUN ln -s "${MAVEN_HOME}/bin/mvn" /usr/bin/mvn && \
    ln -s "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle && \
    apt-get update && \
    apt-get install -y python build-essential gnupg git nano curl apt-transport-https unzip wget dos2unix sudo procps mc && \
    rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-password --gecos '' theia && \
    adduser theia sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers; \
    echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf && sysctl -p || true

# Default known locations
ENV USER_HOME=/home/theia \
    WORKSPACE_HOME=/home/workspace

# set permissions
# set maximum watchers for theia
RUN chmod g+rw /home && \
    mkdir -p $WORKSPACE_HOME && \
    mkdir -p $USER_HOME/.theia && \
    chown -R theia:theia $USER_HOME && \
    chown -R theia:theia $WORKSPACE_HOME
    
USER theia
WORKDIR /home/theia

# use specific 1.9 version of theia modules
#ADD next.package.json ./package.json
ADD 1.9.package.json ./package.json
# add all vsix files. don't forget to unzip them below!
ADD plugins/*.vsix .

RUN yarn --cache-folder ./ycache && rm -rf ./ycache && \
    NODE_OPTIONS="--max_old_space_size=4096" yarn theia build && \
    yarn theia download:plugins

# special handling of this vsix file.
RUN unzip -q vscode-gradle-3.5.2_vsixhub.com.vsix -d plugins && \
    dos2unix $USER_HOME/plugins/vscode-java-redhat/extension/schemas/package.schema.json

# init entry point
USER root    
ADD entrypoint.sh /
RUN rm -rf /tmp/* && \
    chmod ugo+x /entrypoint.sh

USER theia
EXPOSE 3000

WORKDIR /home/theia
ENV SHELL=/bin/bash \
    THEIA_CONFIG_DIR=$USER_HOME/.theia \
    THEIA_DEFAULT_PLUGINS=$USER_HOME/plugins
ENTRYPOINT [ "/entrypoint.sh" ]