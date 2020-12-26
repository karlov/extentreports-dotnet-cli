FROM mcr.microsoft.com/dotnet/sdk:3.1 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:3.1 as build
WORKDIR /src
COPY . .
COPY ["ExtentReportsDotNetCLI/ExtentReportsDotNetCLI/ExtentReportsDotNetCLI.csproj", "/src"]
RUN dotnet restore "/src/ExtentReportsDotNetCLI/ExtentReportsDotNetCLI/ExtentReportsDotNetCLI.csproj"

RUN dotnet build "/src/ExtentReportsDotNetCLI/ExtentReportsDotNetCLI/ExtentReportsDotNetCLI.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "/src/ExtentReportsDotNetCLI/ExtentReportsDotNetCLI/ExtentReportsDotNetCLI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "/app/ExtentReportsDotNetCLI.dll"]

VOLUME [ "/test" ]
