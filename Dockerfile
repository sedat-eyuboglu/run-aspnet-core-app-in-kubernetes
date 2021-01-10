FROM mcr.microsoft.com/dotnet/aspnet:5.0.1 AS runtime
WORKDIR /app
COPY publish/ ./
ENTRYPOINT ["dotnet", "SampleWebApp.dll"]