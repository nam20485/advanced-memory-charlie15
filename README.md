# Advanced Memory Charlie15

[![Build and Test](https://github.com/nam20485/advanced-memory-charlie15/actions/workflows/build.yml/badge.svg)](https://github.com/nam20485/advanced-memory-charlie15/actions/workflows/build.yml)
[![Code Quality](https://github.com/nam20485/advanced-memory-charlie15/actions/workflows/code-quality.yml/badge.svg)](https://github.com/nam20485/advanced-memory-charlie15/actions/workflows/code-quality.yml)
[![Docker Build](https://github.com/nam20485/advanced-memory-charlie15/actions/workflows/docker.yml/badge.svg)](https://github.com/nam20485/advanced-memory-charlie15/actions/workflows/docker.yml)

An advanced AI agent system that combines **GraphRAG** (Graph-based Retrieval-Augmented Generation) for structured knowledge retrieval with **Mem0** for stateful agentic memory management, unified through the **Model Context Protocol (MCP)**.

## Overview

This project implements a "digital expert" AI agent with both deep, structured domain knowledge and personalized, evolving memory of user interactions. It addresses two critical limitations of current AI agents:

1. **Shallow Knowledge Retrieval**: Standard RAG struggles with multi-hop reasoning and complex relationships
2. **Lack of Memory**: Stateless agents cannot personalize or learn from past interactions

### Solution Architecture

- **GraphRAG**: Knowledge graph for deep, relational domain expertise
- **Mem0**: Memory layer for stateful, personalized interactions
- **MCP Protocol**: Standardized, scalable agent communication
- **Verification Layer**: Ensures factual accuracy and reduces hallucinations

## Features

- Multi-user memory management with isolation
- Global search for thematic/high-level questions across knowledge base
- Local search for specific entity queries with multi-hop reasoning
- Episodic, factual, working, and semantic memory types
- Real-time activity monitoring and visualization via Blazor UI
- Fact verification against trusted corpus (grounding RAG)
- Composite orchestration tools for complex workflows
- RESTful API with OpenAPI documentation
- Server-Sent Events (SSE) for streaming responses
- Horizontal scalability and load balancing support

## Technology Stack

- **Language**: C# .NET 9.0
- **Framework**: ASP.NET Core Web API
- **Frontend**: Blazor WebAssembly
- **Orchestration**: .NET Aspire
- **AI/ML**: GraphRAG, Mem0, Azure OpenAI/OpenAI
- **Databases**: Neo4j (graph), Qdrant (vectors)
- **Testing**: xUnit, Moq, FluentAssertions, Testcontainers
- **CI/CD**: GitHub Actions
- **Containerization**: Docker, Docker Compose

## Quick Start

### Prerequisites

- .NET 9.0 SDK
- Docker Desktop
- OpenAI API Key or Azure OpenAI endpoint
- Git
- PowerShell 7+ (for scripts)

### Local Development Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/nam20485/advanced-memory-charlie15.git
   cd advanced-memory-charlie15
   ```

2. **Set up environment variables**:
   ```bash
   cp .env.example .env
   # Edit .env and add your OpenAI API key
   ```

3. **Start infrastructure services**:
   ```bash
   docker-compose up -d neo4j qdrant
   ```

4. **Restore and build the solution**:
   ```bash
   dotnet restore
   dotnet build
   ```

5. **Run tests**:
   ```bash
   dotnet test
   ```

6. **Run the application**:
   ```bash
   dotnet run --project src/AdvancedMemory.AppHost
   ```

7. **Access the applications**:
   - Aspire Dashboard: https://localhost:15888
   - MCP Server API: https://localhost:8080/swagger
   - Blazor Monitoring UI: https://localhost:5000

## Project Structure

```
advanced-memory-charlie15/
├── src/
│   ├── AdvancedMemory.MCP.Server/       # ASP.NET Core MCP Server
│   ├── AdvancedMemory.KnowledgeProvider/ # GraphRAG integration
│   ├── AdvancedMemory.MemoryProvider/    # Mem0 integration
│   ├── AdvancedMemory.GroundingProvider/ # Verification RAG
│   ├── AdvancedMemory.Orchestration/     # Composite workflows
│   ├── AdvancedMemory.Shared/            # Shared DTOs and contracts
│   ├── AdvancedMemory.UI/                # Blazor WebAssembly UI
│   └── AdvancedMemory.AppHost/           # .NET Aspire orchestration
├── tests/
│   ├── AdvancedMemory.MCP.Server.UnitTests/
│   ├── AdvancedMemory.KnowledgeProvider.Tests/
│   ├── AdvancedMemory.MemoryProvider.Tests/
│   ├── AdvancedMemory.IntegrationTests/
│   └── AdvancedMemory.UI.Tests/
├── services/
│   ├── graphrag-service/                 # Python GraphRAG gRPC service
│   └── mem0-service/                     # Python Mem0 gRPC/FastAPI service
├── docker/
│   ├── Dockerfile.McpServer
│   ├── Dockerfile.BlazorApp
│   ├── Dockerfile.GraphRAGService
│   └── Dockerfile.Mem0Service
├── docs/                                 # Documentation
├── scripts/                              # Build and deployment scripts
├── .github/workflows/                    # CI/CD pipelines
├── docker-compose.yml
├── global.json
└── README.md
```

## Development

### Building the Solution

```bash
# Build all projects
dotnet build

# Build in Release mode
dotnet build --configuration Release

# Build specific project
dotnet build src/AdvancedMemory.MCP.Server
```

### Running Tests

```bash
# Run all tests
dotnet test

# Run with code coverage
dotnet test --collect:"XPlat Code Coverage"

# Run specific test project
dotnet test tests/AdvancedMemory.MCP.Server.UnitTests
```

### Code Quality

```bash
# Format code
dotnet format

# Check formatting without changes
dotnet format --verify-no-changes

# Run with Roslyn analyzers
dotnet build /p:EnforceCodeStyleInBuild=true
```

## Docker Deployment

### Full Stack Deployment

```bash
# Build and start all services
docker-compose up --build

# Start in detached mode
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

### Individual Service Deployment

```bash
# Build MCP Server
docker build -f docker/Dockerfile.McpServer -t advanced-memory-mcp-server .

# Build Blazor UI
docker build -f docker/Dockerfile.BlazorApp -t advanced-memory-ui .

# Build GraphRAG Service
docker build -f docker/Dockerfile.GraphRAGService -t advanced-memory-graphrag .

# Build Mem0 Service
docker build -f docker/Dockerfile.Mem0Service -t advanced-memory-mem0 .
```

## API Documentation

Once the MCP Server is running, access the interactive API documentation at:
- Swagger UI: https://localhost:8080/swagger

### MCP Protocol Tools

- `query_knowledge_base(query, search_type, user_context?)` - Query GraphRAG knowledge
- `add_interaction_memory(user_id, conversation_turns, metadata?)` - Add user memory
- `search_user_memory(user_id, query, limit?)` - Search user memories
- `get_user_profile(user_id)` - Get synthesized user profile
- `grounding_check(statement, source?)` - Verify factual claims
- `get_comprehensive_answer(user_id, query)` - Composite orchestrated workflow

## Configuration

### Environment Variables

Key environment variables (set in `.env` file or environment):

```bash
# OpenAI Configuration
OPENAI_API_KEY=your-api-key-here
AZURE_OPENAI_ENDPOINT=https://your-endpoint.openai.azure.com/
AZURE_OPENAI_API_KEY=your-azure-key

# Database Configuration
NEO4J_URI=bolt://localhost:7687
NEO4J_USERNAME=neo4j
NEO4J_PASSWORD=password123
QDRANT_HOST=localhost
QDRANT_PORT=6333

# Service URLs
GRAPHRAG_SERVICE_URL=localhost:50051
MEM0_SERVICE_URL=localhost:50052
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow C# coding conventions
- Write unit tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting PR
- Use conventional commit messages

## Roadmap

### Phase 1: Foundation (Current)
- [x] Solution scaffolding
- [x] Core project structure
- [x] Docker configuration
- [x] CI/CD pipelines
- [ ] Basic provider implementations

### Phase 2: Core Services
- [ ] GraphRAG integration
- [ ] Mem0 integration
- [ ] Grounding provider
- [ ] MCP server implementation

### Phase 3: UI & Integration
- [ ] Blazor monitoring dashboard
- [ ] Real-time event visualization
- [ ] Orchestration layer
- [ ] API documentation

### Phase 4: Advanced Features
- [ ] Performance optimization
- [ ] Security implementation
- [ ] Monitoring & observability
- [ ] Scalability features

### Phase 5: Production Ready
- [ ] Comprehensive testing
- [ ] Documentation completion
- [ ] Deployment automation
- [ ] Release management

## Documentation

- [Application Plan](https://github.com/nam20485/advanced-memory-charlie15/issues/2)
- [Architecture Documentation](docs/architecture.md)
- [Technology Stack](docs/tech-stack.md)
- [Application Template](docs/ai-new-app-template.md)
- [Enhanced Technical Report](docs/Enhanced%20Technical%20Report%20on%20Architecting%20and%20Implementing%20a%20Unified%20Knowledge%20and%20Memory%20Server.md)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Microsoft GraphRAG team
- Mem0 AI team
- Model Context Protocol specification
- .NET Aspire team

## Support

For issues, questions, or contributions, please:
- Open an issue on GitHub
- Contact the maintainers
- Review the documentation

---

**Built with .NET 9.0 and modern AI technologies**
