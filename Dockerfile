# Dockerfile for SWE645 HW2 - Student Survey Web Application
# This file containerizes the StudentSurvey WAR file using Tomcat as the base image.
# Author: Sai Nishitha Muraharisetty | Course: SWE645

FROM tomcat:9.0-jdk11

# Remove default Tomcat webapps to keep the image clean
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the compiled WAR file into Tomcat's webapps directory
COPY StudentSurvey.war /usr/local/tomcat/webapps/

# Expose port 8080 for HTTP traffic
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]
