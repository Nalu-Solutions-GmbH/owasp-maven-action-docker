FROM maven:3-eclipse-temurin-17-alpine

RUN apk update && apk add unzip

RUN curl -L https://github.com/jeremylong/DependencyCheck/releases/download/v11.1.0/dependency-check-11.1.0-release.zip --output dependency-checker.zip  \
    && unzip dependency-checker.zip

RUN --mount=type=secret,id=NVD_API_KEY \
                              export NVD_API_KEY=$(cat /run/secrets/NVD_API_KEY) && \
    dependency-check/bin/dependency-check.sh --nvdApiKey $NVD_API_KEY --updateonly --nvdApiDelay 16000

ENTRYPOINT ["mvn", "org.owasp:dependency-check-maven:11.1.0:check", "-DdataDirectory=/dependency-check/data"]
