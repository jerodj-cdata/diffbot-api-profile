# CData API Profile for Diffbot (Beta)

A CData API Driver profile that enables SQL-based access to the [Diffbot Knowledge Graph API](https://www.diffbot.com/products/knowledge-graph/).

**Version:** 25.0.9417.0
**Status:** Beta
**Last Updated:** 2026-01-06

## Overview

This API Profile allows CData tools (API Driver, Sync, API Server, etc.) to connect to Diffbot's Knowledge Graph, exposing entity data as SQL-queryable tables. Query organizations and people from Diffbot's extensive knowledge graph using standard SQL syntax.

## Requirements

- CData API Driver 2025 (or compatible CData product)
- Diffbot API Token ([Get one here](https://www.diffbot.com/))

## Installation

1. Download or clone this repository
2. Package the contents as a `.apip` file (ZIP archive with `.apip` extension)
3. Set the `Profile` connection property to the path of the `.apip` file

## Connection Properties

| Property | Required | Description |
|----------|----------|-------------|
| `Profile` | Yes | Path to the `.apip` profile file |
| `APIToken` | Yes | Your Diffbot API token |

### Example Connection String

```
Profile=/path/to/diffbot.apip;APIToken=your_token_here;
```

## Available Tables

### Account

Returns information about your Diffbot account.

```sql
SELECT * FROM Account
```

### Organization

Query organizations from the Diffbot Knowledge Graph. Supports filtering by city and employee count.

```sql
-- Get organizations in San Francisco with 100+ employees
SELECT * FROM Organization
WHERE city_name = 'San Francisco'
AND num_employees = 100
```

**Key Fields:**
- `entity.name`, `entity.fullName` - Organization name
- `entity.nbEmployees` - Employee count
- `entity.industries`, `entity.categories` - Industry classification
- `entity.revenue`, `entity.totalInvestment` - Financial data
- Location fields (address, city, country, coordinates)
- Social URIs (LinkedIn, Twitter, website, etc.)

### GenericQuery_Person

Query person entities using Diffbot Query Language (DQL). Pass a URL-encoded DQL query string.

```sql
-- Query for people (requires DQL query parameter)
SELECT * FROM GenericQuery_Person
WHERE dql_query = 'type:Person name:"John Smith"'
```

**Key Fields:**
- `entity.name`, `entity.gender`, `entity.age` - Basic info
- `entity.educations` - Education history
- `entity.employments` - Work history
- `entity.skills`, `entity.languages` - Professional skills
- Social URIs (LinkedIn, GitHub, Twitter, etc.)

## Diffbot Query Language (DQL)

The Organization and GenericQuery_Person tables use [Diffbot Query Language](https://docs.diffbot.com/kgapi/dql-quickstart) for filtering. DQL allows complex queries against the Knowledge Graph.

**Example DQL Queries:**
- `type:Organization locations.city.name:"New York"` - Organizations in NYC
- `type:Person employments.employer.name:"Google"` - People who work at Google
- `type:Organization industries:"Software"` - Software companies

## File Structure

```
├── Account.rsd              # Account endpoint schema
├── Organization.rsd         # Organization query schema
├── GenericQuery_Person.rsd  # Person query schema
├── sys_indexes.rsd          # System metadata table
├── ConnectionProperties.json # Connection property definitions
├── META-INF/
│   └── MANIFEST.MF          # Profile metadata and checksums
└── README.md
```

## Limitations

- **Read-only**: This profile only supports SELECT operations (no INSERT/UPDATE/DELETE)
- **Beta status**: Some features may change in future versions
- **Paging disabled**: Large result sets may be truncated

## Resources

- [Diffbot Knowledge Graph Documentation](https://docs.diffbot.com/kgapi/)
- [DQL Query Reference](https://docs.diffbot.com/kgapi/dql-quickstart)
- [CData API Driver Documentation](https://cdn.cdata.com/help/DAG/jdbc/)

## License

This profile is provided for use with licensed CData products. Diffbot API usage is subject to [Diffbot's terms of service](https://www.diffbot.com/company/terms/).
