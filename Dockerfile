FROM maven:3-eclipse-temurin-17-alpine

RUN apk update && apk add unzip

RUN curl -L https://github.com/jeremylong/DependencyCheck/releases/download/v8.0.0/dependency-check-8.0.0-release.zip --output dependency-checker.zip  \
    && unzip dependency-checker.zip

RUN dependency-check/bin/dependency-check.sh --updateonly

ENTRYPOINT ["mvn", "org.owasp:dependency-check-maven:check", "-DdataDirectory=/dependency-check/data"]
