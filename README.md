# CData API Profile for Diffbot

A CData API Driver profile that enables SQL-based access to the [Diffbot Knowledge Graph API](https://www.diffbot.com/products/knowledge-graph/).

## Overview

This API Profile allows CData tools (API Driver, Sync, API Server, etc.) to connect to Diffbot's Knowledge Graph, exposing KG data as SQL-queryable tables. Query organizations, people, articles, and places from Diffbot's extensive knowledge graph using standard SQL syntax. No manual data uploads required.

## Requirements

- CData API Driver for JDBC ([Get a trial license here](https://www.cdata.com/apidriver/download/#drivers))
- Diffbot API Token ([Get a free token here](https://www.diffbot.com/))

## Installation

### CData API Driver Setup
Skip if you already have the CData API Driver installed.

1. Install the appropriate API Driver for JDBC for your operating system. 
2. Note the install location of your driver.
3. Create a new user driver in your SQL client and add `<location>/lib/cdata.jdbc.api.jar` and `<location>/lib/cdata.jdbc.api.lic` as the driver files. If the `.lic` file is missing in your lib directory, generate one by running `java -jar cdata.jdbc.api.jar -license`

### Diffbot API Profile Setup
1. Download the [latest release](https://github.com/jerodj-cdata/diffbot-api-profile/releases).
2. Create a new data source in your SQL client with the CData API Driver you installed in the previous step.
3. Set authentication to "none".
4. Set the URL property to the following, adjust values enclosed in `<>` with your own values.

```
jdbc:api:Profile=/<location>/diffbot-api-profile;ProfileSettings="APIToken=<Your Diffbot API Token>";AuthScheme=None;
```

**IMPORTANT:** Do not include the `.apip` extension in the URL.

## Querying Data in Diffbot Knowledge Graph with SQL

### Account

Returns status and metadata about your Diffbot token. This should be run on first install to confirm you have an active token and the CData/Diffbot connection is working.

```sql
SELECT * FROM Account
```

### Organization

Query organizations from the Diffbot Knowledge Graph. To filter the data, supply a DQL statement to the `dql` property in the WHERE clause. ([Learn how to write DQL](https://docs.diffbot.com/docs/kg-search))

```sql
-- Get organizations in San Francisco with 100+ employees
SELECT * FROM Organization
WHERE dql = 'type:Organization location.city.name:"San Francisco" nbEmployees>100'
```

**Key Fields Returned:**
- `name` - Organization name
- `homepageUri` - Organization website
- `nbEmployees` - Employee count
- `categories` - Industry classification
- `revenue` - Publicly known revenue figures for the organization
- `investments` - Publicly known investment rounds for the organization
- `locations` - Location fields (address, city, country, coordinates)
- `linkedInUri`/`wikipediaUri` - Social and other links on the web

For the full ontology, see https://docs.diffbot.com/docs/ont-organization

### Person

Query people in the Diffbot Knowledge Graph. To filter the data, supply a DQL statement to the `dql` property in the WHERE clause. ([Learn how to write DQL](https://docs.diffbot.com/docs/kg-search))

```sql
-- List everyone who has ever been a founder
SELECT * FROM Person
WHERE dql_query = 'type:Person employments.title:"Founder"'
```

DQL is a highly flexible querying language. Brace yourself. 

```sql
-- List AI founders who previously worked at FAANG companies
SELECT * FROM Person
WHERE dql_query = 'type:Person employments.{title:"Founder" employer.categories.name:"Artificial Intelligence Software" isCurrent:true} employments.{employer.name:or("Facebook", "Amazon", "Apple", "Netflix", "Google") isCurrent:false}'
```

**Key Fields:**
- `name`
- `educations` - Education history in a JSON array
- `employments` - Work history in a JSON array
- `linkedInUri` - LinkedIn and other social URLs

For the full ontology, see https://docs.diffbot.com/docs/ont-person

### Article

Query articles from the Diffbot Knowledge Graph. To filter the data, supply a DQL statement to the `dql` property in the WHERE clause. ([Learn how to write DQL](https://docs.diffbot.com/docs/kg-search))

```sql
-- Get M&A articles in English published within the last 7 days
SELECT * FROM Article
WHERE dql = 'type:Article categories.name:"Acquisitions, Mergers and Takeovers" date<7d language:en sortBy:date'
```

**Key Fields Returned:**
- `title` - Article title
- `text` - Article text
- `author` - Article author
- `pageUrl` - Article URL
- `date.str` - Published date
- `publisherCountry` - Publishing country
- `tags` - Tagged entities

For the full ontology, see https://docs.diffbot.com/docs/ont-article

### Place

Query places from the Diffbot Knowledge Graph. To filter the data, supply a DQL statement to the `dql` property in the WHERE clause. ([Learn how to write DQL](https://docs.diffbot.com/docs/kg-search))

```sql
-- Get every city in Texas, United States
SELECT * FROM Place
WHERE dql = 'type:Place types:"City" location.country.name:"United States" location.region.name:"Texas"'
```

**Key Fields Returned:**
- `name` - Name of place
- `summary` - One-liner
- `description` - Many-liner
- `population` - Population of a place
- `location.latitude`/`location.longitude` - Lat/long coordinates of a place

For the full ontology, see https://docs.diffbot.com/docs/ont-place

## File Structure

```
├── Account.rsd                 # Account endpoint schema
├── Article.rsd                 # Article entity schema
├── Organization.rsd            # Organization entity schema
├── Person.rsd                  # Person entity schema
├── Place.rsd                   # Place entity schema
├── sys_indexes.rsd             # System metadata table
├── ConnectionProperties.json   # Connection property definitions
├── META-INF/
│   └── MANIFEST.MF             # Profile metadata and checksums
└── README.md
```

## Limitations

- **Read-only**: This profile only supports SELECT operations (no INSERT/UPDATE/DELETE). You're querying a database, not writing to one!
- **Beta status**: Some features may change in future versions
- **Paging disabled**: During the beta, queries will return a maximum of 25 records at once. Reach out to [jerome@diffbot.com](mailto:jerome@diffbot.com) to unlock this.

## Resources

- [What is the Diffbot Knowledge Graph?](https://docs.diffbot.com/docs/getting-started-with-diffbot-knowledge-graph)
- [Introduction to DQL](https://docs.diffbot.com/reference/introduction-to-search-dql)
- [CData API Driver](https://www.cdata.com/apidriver/)

## License

This profile is provided for use with licensed CData products. Diffbot API usage is subject to [Diffbot's terms of service](https://www.diffbot.com/company/terms/).

