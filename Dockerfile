# Use a base image with curl and OpenSSH client installed
FROM ubuntu:20.04

# Set environment variables
ENV NEXUS_URL=http://ec2-3-7-73-181.ap-south-1.compute.amazonaws.com:8081/repository/maven-releases/com/example/myapp/1.0.0/myapp-1.0.0.war
ENV WAR_FILE=myapp-1.0.0.war
ENV TOMCAT_USER=ubuntu
ENV TOMCAT_HOST=ec2-3-7-73-181.ap-south-1.compute.amazonaws.com
ENV TOMCAT_WEBAPPS_DIR=/var/lib/tomcat9/webapps
ENV SSH_KEY_PATH=/root/.ssh/id_rsa

# Install necessary tools
RUN apt-get update && \
    apt-get install -y curl openssh-client

# Copy the SSH private key into the container
COPY id_rsa ${SSH_KEY_PATH}
RUN chmod 600 ${SSH_KEY_PATH}

# Add the remote host to known hosts to avoid host key verification errors
RUN ssh-keyscan -H ${TOMCAT_HOST} >> /root/.ssh/known_hosts

# Download the WAR file from Nexus
RUN curl -o /tmp/${WAR_FILE} ${NEXUS_URL}

# Copy the WAR file to the Tomcat webapps directory on the remote server
RUN scp -i ${SSH_KEY_PATH} /tmp/${WAR_FILE} ${TOMCAT_USER}@${TOMCAT_HOST}:${TOMCAT_WEBAPPS_DIR}

# Clean up
RUN rm /tmp/${WAR_FILE}

# Entry point (this could be a simple command or nothing if not needed)
ENTRYPOINT ["echo", "WAR file deployed to Tomcat server."]
