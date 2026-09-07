FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

COPY ["backend/LocalServices.Api/LocalServices.Api.csproj", "backend/LocalServices.Api/"]

RUN dotnet restore "backend/LocalServices.Api/LocalServices.Api.csproj"

COPY . .

RUN dotnet publish "backend/LocalServices.Api/LocalServices.Api.csproj" \
    -c Release \
    -o /app/publish \
    --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final

WORKDIR /app

ENV ASPNETCORE_URLS=http://+:10000

EXPOSE 10000

COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "LocalServices.Api.dll"]
