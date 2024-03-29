# prepare base image
FROM mcr.microsoft.com/dotnet/runtime:7.0 AS base
WORKDIR /app

# get build image
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# run dotnet restore
COPY ["buildscript/buildscript.csproj", "buildscript/"]
RUN dotnet restore "buildscript/buildscript.csproj"

# copy source and build
COPY . .
WORKDIR "/src/buildscript"
RUN dotnet build "buildscript.csproj" -c Release -o /app/build

# create publish image
FROM build AS publish
RUN dotnet publish "buildscript.csproj" -c Release -o /app/publish

# copy published app to final
FROM base AS final
WORKDIR /app

# Bring in metadata via --build-arg
ARG BRANCH=unknown
ARG IMAGE_CREATED=unknown
ARG IMAGE_REVISION=unknown
ARG IMAGE_VERSION=unknown

# Configure image labels
LABEL branch=$branch \
maintainer="Maricopa County Library District developers <development@mcldaz.org>" \
org.opencontainers.image.authors="Maricopa County Library District developers <development@mcldaz.org>" \
org.opencontainers.image.created=$IMAGE_CREATED \
org.opencontainers.image.description="Build script test project" \
org.opencontainers.image.licenses="MIT" \
org.opencontainers.image.revision=$IMAGE_REVISION \
org.opencontainers.image.source="https://github.com/MCLD/buildscript" \
org.opencontainers.image.title="Build script test project" \
org.opencontainers.image.vendor="Maricopa County Library District" \
org.opencontainers.image.version=$IMAGE_VERSION

# Default image environment variable settings
ENV org.opencontainers.image.created=$IMAGE_CREATED \
org.opencontainers.image.revision=$IMAGE_REVISION \
org.opencontainers.image.version=$IMAGE_VERSION

COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "buildscript.dll"]
