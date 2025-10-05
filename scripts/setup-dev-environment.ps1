# Setup Development Environment for Advanced Memory Charlie15
# This script sets up the local development environment

param(
    [switch]$SkipDocker,
    [switch]$SkipDotnetRestore
)

Write-Host "Advanced Memory Charlie15 - Development Environment Setup" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# Check prerequisites
Write-Host "`nChecking prerequisites..." -ForegroundColor Yellow

# Check .NET SDK
try {
    $dotnetVersion = dotnet --version
    Write-Host "✓ .NET SDK installed: $dotnetVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ .NET SDK not found. Please install .NET 9.0 SDK." -ForegroundColor Red
    exit 1
}

# Check Docker
if (-not $SkipDocker) {
    try {
        $dockerVersion = docker --version
        Write-Host "✓ Docker installed: $dockerVersion" -ForegroundColor Green
    } catch {
        Write-Host "✗ Docker not found. Please install Docker Desktop." -ForegroundColor Red
        exit 1
    }
}

# Check Python
try {
    $pythonVersion = python --version
    Write-Host "✓ Python installed: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "⚠ Python not found. Python services will not be available." -ForegroundColor Yellow
}

# Create .env file if it doesn't exist
Write-Host "`nSetting up environment configuration..." -ForegroundColor Yellow
if (-not (Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    Write-Host "✓ Created .env file from .env.example" -ForegroundColor Green
    Write-Host "  Please edit .env and add your OpenAI API key!" -ForegroundColor Yellow
} else {
    Write-Host "✓ .env file already exists" -ForegroundColor Green
}

# Restore .NET dependencies
if (-not $SkipDotnetRestore) {
    Write-Host "`nRestoring .NET dependencies..." -ForegroundColor Yellow
    dotnet restore
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ .NET dependencies restored successfully" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to restore .NET dependencies" -ForegroundColor Red
        exit 1
    }
}

# Start Docker infrastructure services
if (-not $SkipDocker) {
    Write-Host "`nStarting infrastructure services (Neo4j, Qdrant)..." -ForegroundColor Yellow
    docker-compose up -d neo4j qdrant

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Infrastructure services started" -ForegroundColor Green
        Write-Host "  Waiting for services to be ready (30 seconds)..." -ForegroundColor Yellow
        Start-Sleep -Seconds 30

        # Check service health
        $neo4jStatus = docker-compose ps neo4j | Select-String "Up"
        $qdrantStatus = docker-compose ps qdrant | Select-String "Up"

        if ($neo4jStatus -and $qdrantStatus) {
            Write-Host "✓ All infrastructure services are healthy" -ForegroundColor Green
        } else {
            Write-Host "⚠ Some services may not be ready. Check with: docker-compose ps" -ForegroundColor Yellow
        }
    } else {
        Write-Host "✗ Failed to start infrastructure services" -ForegroundColor Red
    }
}

# Setup Python virtual environments
Write-Host "`nSetting up Python virtual environments..." -ForegroundColor Yellow
try {
    # GraphRAG service
    if (Test-Path "services/graphrag-service") {
        Push-Location "services/graphrag-service"
        python -m venv venv
        Write-Host "✓ Created virtual environment for GraphRAG service" -ForegroundColor Green
        Pop-Location
    }

    # Mem0 service
    if (Test-Path "services/mem0-service") {
        Push-Location "services/mem0-service"
        python -m venv venv
        Write-Host "✓ Created virtual environment for Mem0 service" -ForegroundColor Green
        Pop-Location
    }
} catch {
    Write-Host "⚠ Failed to create Python virtual environments" -ForegroundColor Yellow
}

# Build solution
Write-Host "`nBuilding solution..." -ForegroundColor Yellow
dotnet build --configuration Release
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Solution built successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to build solution" -ForegroundColor Red
    exit 1
}

# Summary
Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "Development Environment Setup Complete!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Edit .env file and add your OpenAI API key" -ForegroundColor White
Write-Host "2. Run: dotnet run --project src/AdvancedMemory.AppHost" -ForegroundColor White
Write-Host "3. Access Aspire Dashboard at: https://localhost:15888" -ForegroundColor White
Write-Host "`nUseful commands:" -ForegroundColor Yellow
Write-Host "- Run tests: dotnet test" -ForegroundColor White
Write-Host "- Format code: dotnet format" -ForegroundColor White
Write-Host "- View Docker services: docker-compose ps" -ForegroundColor White
Write-Host "- View Docker logs: docker-compose logs -f" -ForegroundColor White
Write-Host ""
