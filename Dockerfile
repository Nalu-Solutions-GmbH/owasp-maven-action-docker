FROM maven:3-eclipse-temurin-17-alpine

RUN apk update && apk add unzip

RUN curl -L https://github.com/dependency-check/DependencyCheck/releases/download/v12.1.3/dependency-check-12.1.3-release.zip --output dependency-checker.zip  \
    && unzip dependency-checker.zip

RUN --mount=type=secret,id=NVD_API_KEY \
                              export NVD_API_KEY=$(cat /run/secrets/NVD_API_KEY) && \
    dependency-check/bin/dependency-check.sh --nvdApiKey $NVD_API_KEY --updateonly --nvdApiDelay 3200

ENTRYPOINT ["mvn", "org.owasp:dependency-check-maven:12.1.3:check", "-DdataDirectory=/dependency-check/data"]
