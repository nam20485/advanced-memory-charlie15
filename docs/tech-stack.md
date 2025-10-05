# Technology Stack Documentation

## advanced-memory-charlie15

### Overview
This project implements an MCP (Model Context Protocol) server-based advanced memory, recall, verification, and reasoning system combining GraphRAG for structured knowledge retrieval and Mem0 for agentic memory management.

---

## Language & Runtime

### Primary Language
- **C#** (.NET 9.0)

### Language Configuration
- **SDK Version**: 9.0.0
- **Roll Forward Policy**: latestFeature
- **global.json**: Yes, included for SDK version control

### Justification
C# with .NET 9.0 provides excellent performance, strong typing, modern async/await patterns, and comprehensive tooling support for building microservices and web applications. The choice of ASP.NET Core enables high-performance API development with built-in support for dependency injection, middleware, and configuration management.

---

## Core Frameworks & Technologies

### Web Framework
- **ASP.NET Core 9.0**
  - Web API for RESTful services
  - MCP (Model Context Protocol) server implementation
  - Server-Sent Events (SSE) support for streaming

### Frontend Framework
- **Blazor WebAssembly**
  - Interactive web UI for monitoring memory/reasoning events
  - Real-time progress visualization
  - Activity tracking dashboard

### Orchestration & Infrastructure
- **.NET Aspire**
  - Service orchestration and discovery
  - Distributed application development
  - Built-in telemetry and health checks

---

## Data Storage & Knowledge Management

### Graph Databases
- **Neo4j** (Primary knowledge graph)
  - GraphRAG knowledge base storage
  - Entity and relationship management
  - Community detection support
  - Cypher query language for graph traversal

### Vector Databases
- **Qdrant** (Self-hosted option) or **Neo4j Vector Index**
  - Semantic search capabilities
  - Embedding storage for RAG
  - High-performance similarity search

### Memory Storage (Mem0 Backend)
- **Hybrid Storage Architecture**:
  - Vector store: Qdrant or cloud-managed service
  - Graph store: Neo4j for relationship tracking
  - Key-value store: For metadata and fast lookups

---

## AI/ML Components

### LLM Integration
- **Azure OpenAI** or **OpenAI API**
  - GPT-4 for complex reasoning
  - GPT-4o-mini for cost-effective operations
  - Text embedding models (text-embedding-3-small/large)

### GraphRAG Implementation Options
Three implementation paths available:
1. **Microsoft graphrag library** - Reference implementation
2. **neo4j-graphrag library** - Native Neo4j SDK
3. **LlamaIndex** - Modular framework approach

### Memory Layer
- **Mem0 (mem0ai package)**
  - Agentic memory management
  - Multi-faceted memory model (working, episodic, factual, semantic)
  - Graph-based memory relationships

---

## Testing Frameworks

### Unit Testing
- **xUnit** - Primary test framework
- **Moq** - Mocking framework
- **FluentAssertions** - Assertion library

### Integration Testing
- **WebApplicationFactory** - ASP.NET Core integration tests
- **Testcontainers** - Containerized dependency testing

### End-to-End Testing
- **Playwright** - Browser automation
- **bUnit** - Blazor component testing

### Performance Testing
- **NBomber** - Load and performance testing
- **BenchmarkDotNet** - Micro-benchmarking

---

## Logging, Monitoring & Observability

### Logging
- **Serilog**
  - Structured logging
  - Multiple sinks (Console, File, Seq)
  - Enrichment with correlation IDs

### Telemetry
- **OpenTelemetry**
  - Distributed tracing
  - Metrics collection
  - Integration with .NET Aspire

### Monitoring
- **Application Insights** (Optional)
- **Prometheus** (Metrics)
- **Grafana** (Visualization)

---

## Containerization & Deployment

### Container Technologies
- **Docker**
  - Multi-stage builds
  - Docker Compose for local orchestration
  - Development and production images

### Infrastructure as Code
- **Terraform** (Planned for future phases)
  - Multi-provider deployment
  - Docker provider
  - Cloud providers (Azure, AWS)

---

## CI/CD & DevOps

### Version Control
- **Git** with **GitHub**
- Branch strategy: Feature branches with PR workflow

### CI/CD Pipeline
- **GitHub Actions**
  - Automated build on push/PR
  - Multi-stage pipeline:
    - Linting (dotnet format)
    - Code analysis (Roslyn analyzers)
    - Security scanning (CodeQL, dependency scanning)
    - Unit & integration tests
    - Docker image build
    - Container image publishing
    - Release automation

### Code Quality Tools
- **.NET Format** - Code style enforcement
- **Roslyn Analyzers** - Static code analysis
- **SonarQube** (Optional) - Continuous code quality

### Security Tools
- **GitHub CodeQL** - Security vulnerability detection
- **Dependabot** - Dependency updates and security alerts
- **OWASP Dependency-Check** - Dependency vulnerability scanning

---

## Development Tools & Utilities

### API Documentation
- **Swagger/OpenAPI** (Swashbuckle)
  - Interactive API explorer
  - Auto-generated documentation
  - Client SDK generation support

### Package Management
- **NuGet** - .NET package management
- **npm** - Frontend dependencies (for Blazor)

### Configuration Management
- **Microsoft.Extensions.Configuration**
  - appsettings.json
  - Environment variables
  - User secrets (development)
  - Azure Key Vault (production)

---

## Key Libraries & NuGet Packages

### ASP.NET Core Packages
- Microsoft.AspNetCore.OpenApi
- Swashbuckle.AspNetCore
- Microsoft.AspNetCore.SignalR (for real-time communication)

### Aspire Packages
- Aspire.Hosting
- Aspire.Hosting.Neo4j
- .NET Aspire Community Toolkit

### Testing Packages
- xunit
- xunit.runner.visualstudio
- Moq
- FluentAssertions
- Microsoft.AspNetCore.Mvc.Testing
- Testcontainers
- Playwright
- bUnit

### Logging & Observability
- Serilog.AspNetCore
- Serilog.Sinks.Console
- Serilog.Sinks.File
- OpenTelemetry.Extensions.Hosting
- OpenTelemetry.Instrumentation.AspNetCore

### GraphRAG & AI Integration
- Neo4j.Driver
- graphrag (Microsoft implementation - Python interop)
- neo4j-graphrag (via gRPC bridge or direct Python SDK)
- Azure.AI.OpenAI or OpenAI

### Mem0 Integration
- mem0ai (Python SDK - requires interop strategy)
- Options for .NET integration:
  - gRPC service wrapper
  - HTTP API wrapper
  - Python.NET for direct interop

---

## Interoperability Strategy

### Python/.NET Integration
Since GraphRAG and Mem0 have primary Python SDKs:

**Option 1: gRPC Bridge** (Recommended)
- Build Python gRPC services for GraphRAG and Mem0
- Consume from .NET via gRPC client
- Clean separation of concerns
- High performance

**Option 2: REST API Wrapper**
- FastAPI wrapper around Python SDKs
- .NET HttpClient consumption
- Simpler but higher latency

**Option 3: Python.NET**
- Direct Python execution from .NET
- pythonnet package
- More complex deployment

**Decision**: Use gRPC bridge pattern for production reliability and performance.

---

## Design Principles & Patterns

### Architectural Patterns
- **Microservices Architecture** - Logical service separation
- **MCP Protocol** - Standardized AI agent communication
- **CQRS Pattern** - Command/Query separation for complex operations
- **Repository Pattern** - Data access abstraction
- **Unit of Work Pattern** - Transaction management

### Design Principles
- **SOLID Principles** - Clean, maintainable code
- **Clean Architecture** - Dependency rule enforcement
- **Domain-Driven Design** - Core business logic isolation
- **API-First Design** - OpenAPI specification driven

---

## Development Environment

### IDE/Editors
- Visual Studio 2022
- Visual Studio Code
- Rider (JetBrains)

### Required Tools
- .NET 9.0 SDK
- Docker Desktop
- Git
- PowerShell 7+
- Python 3.11+ (for GraphRAG/Mem0 services)

### Optional Tools
- Azure CLI
- Terraform CLI
- Postman/Insomnia (API testing)
- Neo4j Desktop

---

## External Services & Dependencies

### Required External Services
- **OpenAI API** or **Azure OpenAI Service**
  - API key required
  - Embedding and chat completion endpoints

### Optional External Services
- **Neo4j AuraDB** (Managed Neo4j)
- **Qdrant Cloud** (Managed vector DB)
- **Mem0 Platform** (Managed memory service)

### Self-Hosted Alternatives
- Neo4j Community Edition (Docker)
- Qdrant (Docker)
- Self-hosted Mem0 (Python service)

---

## Performance & Scalability Considerations

### Caching Strategy
- **In-Memory Caching** - Response caching for frequent queries
- **Distributed Cache** - Redis for multi-instance deployments
- **HTTP Cache Headers** - Client-side caching

### Scalability Features
- **Horizontal Scaling** - Stateless API design
- **Load Balancing** - NGINX or cloud load balancer
- **Database Scaling** - Neo4j clustering, Qdrant replication
- **Async Processing** - Background job processing for indexing

### Performance Optimization
- **Connection Pooling** - Database connection reuse
- **Batch Operations** - Bulk indexing for GraphRAG
- **Pagination** - Large result set management
- **Streaming Responses** - SSE for incremental results

---

## Security Considerations

### Authentication & Authorization
- **JWT Tokens** - API authentication
- **API Keys** - Service-to-service authentication
- **Role-Based Access Control (RBAC)** - User permission management

### Data Security
- **TLS/HTTPS** - Transport encryption
- **Secrets Management** - Azure Key Vault, environment variables
- **Data Encryption at Rest** - Database-level encryption
- **Input Validation** - FluentValidation library

### Compliance
- **GDPR Considerations** - User data privacy
- **Audit Logging** - Security event tracking
- **Rate Limiting** - API abuse prevention

---

## Versioning & API Management

### API Versioning
- **URL Versioning** - /api/v1/, /api/v2/
- **Semantic Versioning** - SemVer 2.0 for packages

### Breaking Change Management
- **Deprecation Warnings** - Clear communication
- **Backward Compatibility** - Support multiple API versions
- **Migration Guides** - Documentation for version upgrades

---

## Summary

This technology stack provides a robust, scalable, and maintainable foundation for building an advanced AI agent system with deep knowledge management and personalized memory capabilities. The combination of .NET 9.0, ASP.NET Core, Neo4j, and modern AI integration patterns enables the creation of a production-ready system that balances performance, developer experience, and operational excellence.

The hybrid approach (Python SDKs for AI/ML with .NET for core application logic) leverages the strengths of each ecosystem while maintaining clean architectural boundaries through gRPC or REST APIs.
