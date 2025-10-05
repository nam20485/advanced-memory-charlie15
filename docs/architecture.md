# Architecture Documentation

## advanced-memory-charlie15

### Executive Summary
This document defines the architecture for an advanced AI agent system that combines GraphRAG (Graph-based Retrieval-Augmented Generation) for structured knowledge retrieval with Mem0 for stateful agentic memory management. The system is built on the Model Context Protocol (MCP) to provide a unified, scalable, and maintainable platform for intelligent knowledge management and reasoning.

---

## Table of Contents
1. [Architectural Overview](#architectural-overview)
2. [System Architecture](#system-architecture)
3. [Component Architecture](#component-architecture)
4. [Data Architecture](#data-architecture)
5. [API Architecture](#api-architecture)
6. [Deployment Architecture](#deployment-architecture)
7. [Security Architecture](#security-architecture)
8. [Design Decisions & Trade-offs](#design-decisions--trade-offs)

---

## Architectural Overview

### Vision
Build a "digital expert" AI agent that possesses both deep, structured domain knowledge (via GraphRAG) and personalized, evolving memory of user interactions (via Mem0), unified through a standardized MCP server interface.

### Core Architectural Principles

1. **Separation of Concerns**
   - Knowledge layer (GraphRAG) handles domain expertise
   - Memory layer (Mem0) manages user-specific context
   - Verification layer ensures factual accuracy
   - Orchestration layer coordinates complex workflows

2. **Modularity & Extensibility**
   - MCP protocol provides stable API contract
   - Provider pattern enables implementation swapping
   - Plugin architecture for new capabilities

3. **Scalability & Performance**
   - Stateless server design for horizontal scaling
   - Asynchronous processing for long-running operations
   - Caching strategies at multiple levels

4. **Reliability & Observability**
   - Comprehensive logging and telemetry
   - Health checks and monitoring
   - Graceful degradation and error handling

---

## System Architecture

### High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         User Interface Layer                     │
│  ┌────────────────────┐         ┌─────────────────────────┐    │
│  │  Blazor WebAssembly │         │   External AI Agents    │    │
│  │   (Monitoring UI)   │         │  (LangGraph, CrewAI)    │    │
│  └─────────┬───────────┘         └───────────┬─────────────┘    │
└────────────┼─────────────────────────────────┼──────────────────┘
             │                                  │
             │ WebSocket/SignalR                │ MCP (SSE/HTTP)
             │                                  │
┌────────────┼──────────────────────────────────┼──────────────────┐
│            │      Application Layer           │                  │
│  ┌─────────▼───────────────┐    ┌────────────▼──────────────┐   │
│  │  Blazor Backend Service │    │  MCP Server (ASP.NET Core)│   │
│  │  (SignalR Hub)          │    │  - MCP Protocol Handler    │   │
│  └─────────────────────────┘    │  - SSE Endpoint           │   │
│                                  │  - Tool Dispatcher         │   │
│                                  └────────────┬──────────────┘   │
│                                               │                  │
│                         ┌─────────────────────┼─────────────┐    │
│                         │                     │             │    │
│            ┌────────────▼──────┐  ┌──────────▼──────┐  ┌───▼────────┐
│            │ Knowledge Provider │  │ Memory Provider │  │ Grounding  │
│            │   (GraphRAG Core)  │  │   (Mem0 Core)   │  │  Provider  │
│            └────────────┬───────┘  └──────────┬──────┘  └───┬────────┘
└─────────────────────────┼─────────────────────┼─────────────┼─────────┘
                          │                     │             │
                          │ gRPC/REST           │ gRPC/REST   │ HTTP
                          │                     │             │
┌─────────────────────────┼─────────────────────┼─────────────┼─────────┐
│            Data & Infrastructure Layer        │             │         │
│  ┌─────────▼──────────┐     ┌────────────────▼─────────┐  │         │
│  │ Python GraphRAG    │     │  Python Mem0 Service     │  │         │
│  │ Service (gRPC)     │     │  (gRPC/FastAPI)          │  │         │
│  │ - Microsoft impl   │     │  - Memory SDK            │  │         │
│  │ - neo4j impl       │     │  - Graph/Vector stores   │  │         │
│  │ - LlamaIndex impl  │     └──────────────┬───────────┘  │         │
│  └────────┬───────────┘                    │              │         │
│           │                                │              │         │
│  ┌────────▼────────────────────────────────▼──────────────▼─────────┐
│  │                    Storage Layer                                 │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────────┐ │
│  │  │  Neo4j   │  │  Qdrant  │  │  Parquet │  │  Document Store  │ │
│  │  │  Graph   │  │  Vectors │  │  Files   │  │  (Raw Corpus)    │ │
│  │  └──────────┘  └──────────┘  └──────────┘  └──────────────────┘ │
│  └──────────────────────────────────────────────────────────────────┘
└─────────────────────────────────────────────────────────────────────┘

External Services:
┌─────────────────────────────────────────┐
│  OpenAI / Azure OpenAI API              │
│  - GPT-4 / GPT-4o-mini                  │
│  - text-embedding-3-small/large         │
└─────────────────────────────────────────┘
```

### Architecture Layers

#### 1. User Interface Layer
- **Blazor WebAssembly**: Interactive monitoring dashboard
  - Real-time event visualization
  - Memory/knowledge activity tracking
  - System health monitoring
- **External AI Agents**: Consume MCP services
  - LangGraph agents
  - CrewAI agents
  - Custom agent implementations

#### 2. Application Layer (.NET Core)
- **MCP Server** (ASP.NET Core Web API)
  - MCP protocol implementation
  - Server-Sent Events (SSE) endpoint
  - Tool routing and dispatch
  - Request validation and error handling

- **Blazor Backend Service**
  - SignalR hub for real-time updates
  - State management for UI
  - Activity event streaming

#### 3. Provider/Service Layer
- **Knowledge Provider**: GraphRAG abstraction
- **Memory Provider**: Mem0 abstraction
- **Grounding Provider**: Verification RAG
- **Orchestration Provider**: Composite workflows

#### 4. Integration Layer (Python Services)
- **GraphRAG Service** (Python with gRPC)
  - Document ingestion and indexing
  - Graph construction
  - Global/local search execution

- **Mem0 Service** (Python with gRPC/FastAPI)
  - Memory operations (add, search, update)
  - User context management
  - Memory relationship tracking

#### 5. Data/Storage Layer
- **Neo4j**: Knowledge graph and memory graph
- **Qdrant**: Vector embeddings
- **Parquet Files**: GraphRAG artifacts (Microsoft impl)
- **Document Store**: Raw corpus (blob storage)

---

## Component Architecture

### MCP Server Components

#### Tool Dispatcher
**Responsibility**: Routes MCP tool requests to appropriate providers

```csharp
// Conceptual structure
public interface IToolDispatcher
{
    Task<ToolResponse> DispatchAsync(ToolRequest request, CancellationToken ct);
}

public class ToolDispatcher : IToolDispatcher
{
    private readonly Dictionary<string, IToolProvider> _providers;

    public async Task<ToolResponse> DispatchAsync(ToolRequest request, CancellationToken ct)
    {
        if (!_providers.TryGetValue(request.ToolName, out var provider))
            throw new ToolNotFoundException(request.ToolName);

        return await provider.ExecuteAsync(request.Parameters, ct);
    }
}
```

**Key Features**:
- Dynamic provider registration
- Request validation
- Error handling and retry logic
- Telemetry and logging integration

#### Provider Abstraction Layer

**Knowledge Provider Interface**:
```csharp
public interface IKnowledgeProvider
{
    Task<KnowledgeResponse> QueryAsync(
        string query,
        SearchType searchType,
        string? userContext = null,
        CancellationToken ct = default);
}

public enum SearchType
{
    Global,  // Thematic, high-level questions
    Local    // Specific entity queries with multi-hop reasoning
}
```

**Memory Provider Interface**:
```csharp
public interface IMemoryProvider
{
    Task<AddMemoryResult> AddInteractionAsync(
        string userId,
        ConversationTurn[] turns,
        Dictionary<string, string>? metadata = null,
        CancellationToken ct = default);

    Task<MemorySearchResult> SearchMemoriesAsync(
        string userId,
        string query,
        int limit = 5,
        CancellationToken ct = default);

    Task<UserProfile> GetUserProfileAsync(
        string userId,
        CancellationToken ct = default);
}
```

**Grounding Provider Interface**:
```csharp
public interface IGroundingProvider
{
    Task<VerificationResult> VerifyFactAsync(
        string claim,
        string? source = null,
        CancellationToken ct = default);
}
```

### Python Service Components

#### GraphRAG Service Architecture

**Purpose**: Encapsulates Python GraphRAG SDK in a gRPC service

**Key Modules**:
- **Indexing Module**: Document ingestion and graph construction
- **Query Module**: Global and local search execution
- **Configuration Module**: Pipeline and LLM settings management

**gRPC Service Definition** (conceptual):
```protobuf
service GraphRAGService {
    rpc IndexDocuments(IndexRequest) returns (IndexResponse);
    rpc QueryKnowledge(QueryRequest) returns (QueryResponse);
    rpc GetStatus(StatusRequest) returns (StatusResponse);
}

message QueryRequest {
    string query = 1;
    SearchType search_type = 2;
    optional string user_context = 3;
}

message QueryResponse {
    string answer = 1;
    repeated Source sources = 2;
    map<string, string> metadata = 3;
}
```

#### Mem0 Service Architecture

**Purpose**: Wraps Mem0 SDK for .NET consumption

**Key Modules**:
- **Memory Operations**: Add, search, update, delete
- **User Management**: Profile and context handling
- **Graph Management**: Relationship tracking

**API Endpoints** (FastAPI or gRPC):
```python
# FastAPI example
@app.post("/memory/add")
async def add_memory(request: AddMemoryRequest) -> AddMemoryResponse:
    # Mem0 SDK integration
    pass

@app.post("/memory/search")
async def search_memory(request: SearchMemoryRequest) -> SearchMemoryResponse:
    # Mem0 SDK integration
    pass
```

---

## Data Architecture

### Knowledge Graph Schema (Neo4j)

#### GraphRAG Knowledge Graph

**Node Types**:
- **Entity**: Core entities extracted from documents
  - Properties: `id`, `name`, `type`, `description`, `source_ids`
- **Chunk**: Text units from source documents
  - Properties: `id`, `text`, `document_id`, `embedding`, `position`
- **Community**: Clustered entity groups (from Leiden algorithm)
  - Properties: `id`, `level`, `summary`, `entity_count`

**Relationship Types**:
- **MENTIONED_IN**: Entity → Chunk
- **RELATED_TO**: Entity → Entity (with `relationship_type`, `strength`, `description`)
- **BELONGS_TO**: Entity → Community
- **PART_OF**: Community → Community (hierarchical)

**Indexes**:
- Vector index on `Chunk.embedding` for semantic search
- Full-text index on `Entity.name` and `Entity.description`
- B-tree index on `Entity.type`

#### Mem0 Memory Graph

**Node Types**:
- **Memory**: Individual memory records
  - Properties: `id`, `user_id`, `content`, `embedding`, `created_at`, `updated_at`, `importance`
- **User**: User entities
  - Properties: `id`, `profile_summary`, `preferences`
- **MemoryEntity**: Entities extracted from memories
  - Properties: `id`, `name`, `type`

**Relationship Types**:
- **HAS_MEMORY**: User → Memory
- **CONTAINS**: Memory → MemoryEntity
- **RELATES_TO**: Memory → Memory (temporal or semantic relationships)
- **REFERENCES**: MemoryEntity → MemoryEntity

### Vector Storage Architecture (Qdrant)

**Collections**:
1. **knowledge_embeddings**: Document chunk embeddings for GraphRAG
   - Dimensions: 1536 (text-embedding-3-small) or 3072 (text-embedding-3-large)
   - Distance metric: Cosine similarity

2. **memory_embeddings**: User memory embeddings for Mem0
   - Dimensions: 1536
   - Distance metric: Cosine similarity
   - Payload: `{user_id, memory_id, timestamp, importance}`

### Document Storage

**Raw Corpus Storage**:
- Azure Blob Storage or S3 for production
- Local filesystem for development
- Organized by: `{corpus_name}/{category}/{document_id}.{ext}`

**GraphRAG Artifacts** (Microsoft implementation):
- Parquet files for entities, relationships, communities
- Location: `{project_root}/output/artifacts/`

---

## API Architecture

### MCP Server API

#### Tool Catalog

**Knowledge Tools**:
- `query_knowledge_base(query, search_type, user_context?)`
  - Returns: Synthesized answer with sources

**Memory Tools**:
- `add_interaction_memory(user_id, conversation_turn[], metadata?)`
  - Returns: Memory ID and status
- `search_user_memory(user_id, query, limit?)`
  - Returns: Ranked list of relevant memories
- `get_user_profile(user_id)`
  - Returns: Synthesized user profile

**Composite Tools** (Orchestration Layer):
- `get_comprehensive_answer(user_id, query)`
  - Orchestrates: memory search → knowledge query → verification → synthesis
  - Returns: Verified, personalized answer with provenance

**Verification Tools**:
- `grounding_check(statement, source?)`
  - Returns: Verification result with confidence and evidence

#### MCP Protocol Flow

1. **Client Request** (Agent → MCP Server)
   ```json
   {
     "jsonrpc": "2.0",
     "method": "tools/call",
     "params": {
       "name": "query_knowledge_base",
       "arguments": {
         "query": "What are the main themes in the knowledge base?",
         "search_type": "global",
         "user_context": "User is an expert in AI"
       }
     },
     "id": 1
   }
   ```

2. **Server Processing**
   - Validate request
   - Route to Knowledge Provider
   - Provider calls Python GraphRAG service via gRPC
   - Process response
   - Add telemetry

3. **Server Response** (MCP Server → Agent)
   ```json
   {
     "jsonrpc": "2.0",
     "result": {
       "content": [
         {
           "type": "text",
           "text": "The main themes identified in the knowledge base are..."
         }
       ],
       "metadata": {
         "sources": ["community_report_5", "community_report_12"],
         "search_type": "global",
         "processing_time_ms": 1250
       }
     },
     "id": 1
   }
   ```

### REST API (Monitoring & Admin)

**Endpoints**:
- `GET /health` - Health check
- `GET /metrics` - Prometheus metrics
- `GET /api/v1/status` - System status
- `POST /api/v1/index/trigger` - Trigger re-indexing
- `GET /api/v1/users/{userId}/memories` - Admin memory access

---

## Deployment Architecture

### Development Environment

**Docker Compose Setup**:
```yaml
services:
  neo4j:
    image: neo4j:latest
    ports: ["7474:7474", "7687:7687"]
    volumes: ["./data/neo4j:/data"]

  qdrant:
    image: qdrant/qdrant:latest
    ports: ["6333:6333"]
    volumes: ["./data/qdrant:/qdrant/storage"]

  graphrag-service:
    build: ./services/graphrag
    ports: ["50051:50051"]
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}

  mem0-service:
    build: ./services/mem0
    ports: ["50052:50052"]
    environment:
      - NEO4J_URI=bolt://neo4j:7687
      - QDRANT_HOST=qdrant

  mcp-server:
    build: ./src/McpServer
    ports: ["8080:8080"]
    environment:
      - GRAPHRAG_SERVICE_URL=graphrag-service:50051
      - MEM0_SERVICE_URL=mem0-service:50052

  blazor-ui:
    build: ./src/BlazorApp
    ports: ["5000:5000"]
    environment:
      - MCP_SERVER_URL=http://mcp-server:8080
```

### Production Deployment (Azure)

**Architecture**:
- **Azure Container Apps**: Host .NET services
- **Azure Kubernetes Service (AKS)**: Alternative for complex orchestration
- **Azure OpenAI**: Managed LLM service
- **Neo4j AuraDB**: Managed graph database
- **Qdrant Cloud**: Managed vector database
- **Azure Blob Storage**: Document corpus
- **Azure Application Insights**: Monitoring
- **Azure Key Vault**: Secrets management

**Scaling Strategy**:
- MCP Server: Horizontal scaling (3+ instances)
- Python Services: Horizontal scaling with load balancing
- Databases: Managed service auto-scaling
- Caching: Azure Redis Cache for distributed caching

---

## Security Architecture

### Authentication & Authorization

**API Security**:
- **JWT Tokens**: Bearer authentication for MCP clients
- **API Keys**: Service-to-service authentication
- **RBAC**: User roles (admin, developer, user)

**User Isolation**:
- All Mem0 operations scoped by `user_id`
- Row-level security in queries
- Separate memory graphs per tenant (enterprise)

### Data Protection

**In Transit**:
- TLS 1.3 for all HTTP/gRPC communication
- Certificate-based authentication for services

**At Rest**:
- Database encryption (Neo4j, Qdrant native encryption)
- Azure Storage encryption for documents
- Secrets in Azure Key Vault

**Privacy**:
- PII detection and masking
- Configurable data retention policies
- GDPR compliance (right to deletion)

### Rate Limiting & Throttling

- Per-user rate limits
- Per-IP rate limits for public endpoints
- Token bucket algorithm
- Graceful degradation under load

---

## Design Decisions & Trade-offs

### Decision 1: Python Services via gRPC vs. Direct Integration

**Decision**: Use gRPC bridge pattern for Python GraphRAG and Mem0 SDKs

**Rationale**:
- GraphRAG and Mem0 have mature Python SDKs
- gRPC provides high performance, type safety
- Clean separation enables independent scaling
- Easier to maintain than Python.NET interop

**Trade-offs**:
- Additional deployment complexity
- Network hop latency (mitigated by local deployment)
- Alternative considered: HTTP REST API (simpler but less performant)

### Decision 2: Neo4j as Primary Graph Database

**Decision**: Use Neo4j for both GraphRAG knowledge graph and Mem0 memory graph

**Rationale**:
- Native graph database with Cypher query language
- Excellent performance for multi-hop traversal
- Official neo4j-graphrag library support
- Mature ecosystem and tooling

**Trade-offs**:
- Licensing (Community vs. Enterprise)
- Learning curve for Cypher
- Alternative considered: Microsoft graphrag with Parquet (simpler but less query flexibility)

### Decision 3: MCP Protocol for Agent Communication

**Decision**: Implement Model Context Protocol (MCP) as agent interface

**Rationale**:
- Emerging standard for AI agent tooling
- Server-Sent Events enable streaming responses
- Standardized contract promotes interoperability
- Future-proof for multi-agent systems

**Trade-offs**:
- Protocol still evolving
- Limited tooling compared to REST
- Alternative considered: Pure REST API (more mature but less AI-agent optimized)

### Decision 4: Blazor WebAssembly for Monitoring UI

**Decision**: Use Blazor WASM for the monitoring dashboard

**Rationale**:
- Single language (.NET/C#) across stack
- Real-time updates via SignalR
- Component-based architecture
- Excellent tooling in Visual Studio

**Trade-offs**:
- Initial download size
- Browser compatibility constraints
- Alternative considered: React (larger ecosystem) or Blazor Server (lower client load)

### Decision 5: Composite Tools in Orchestration Layer

**Decision**: Implement high-level composite tools on the MCP server

**Rationale**:
- Simplifies agent logic
- Centralized workflow definition
- Enables parallel execution of independent calls
- Better observability and debugging

**Trade-offs**:
- Less flexibility for agents
- Tighter coupling of workflow logic to server
- Alternative considered: Agent-only orchestration (more flexible but brittle)

---

## Future Architecture Considerations

### Planned Enhancements

1. **Cross-Graph Linking**
   - Link memory graph nodes to knowledge graph entities
   - Enable queries like "Show me what I've learned about X from the knowledge base"

2. **Multi-Tenant Support**
   - Tenant-isolated databases
   - Usage metering and billing integration
   - Admin portal for tenant management

3. **Advanced Caching**
   - Redis distributed cache
   - Query result caching with smart invalidation
   - Pre-computation of common queries

4. **Async Processing**
   - Message queue (RabbitMQ, Azure Service Bus)
   - Background indexing jobs
   - Long-running query handling

5. **Federated Knowledge**
   - Multiple knowledge graphs per domain
   - Cross-graph query federation
   - Knowledge graph versioning

---

## Appendix

### Reference Architectures
- [Microsoft GraphRAG Architecture](https://github.com/microsoft/graphrag)
- [Neo4j GraphRAG Implementation](https://github.com/neo4j/neo4j-graphrag)
- [Mem0 Architecture](https://docs.mem0.ai/architecture)
- [Model Context Protocol Specification](https://modelcontextprotocol.io/)

### Related Documentation
- [Technology Stack](./tech-stack.md)
- [API Documentation](../api-docs/) (to be generated)
- [Deployment Guide](../docs/deployment.md) (to be created)
- [Security Guidelines](../docs/security.md) (to be created)

---

**Document Version**: 1.0
**Last Updated**: 2025-10-04
**Author**: Planning Agent (Planner)
**Status**: Draft for Stakeholder Review
