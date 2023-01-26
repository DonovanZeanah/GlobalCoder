# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY SimpleDN7ContainerizedWeb/*.csproj .
RUN dotnet restore 

# copy everything else and build app
COPY SimpleDN7ContainerizedWeb/. .
RUN dotnet publish -c Release -o /app 

EXPOSE 80

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
EXPOSE 80
COPY --from=build /app .
ENTRYPOINT ["dotnet", "SimpleDN7ContainerizedWeb.dll"]
