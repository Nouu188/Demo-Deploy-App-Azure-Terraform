# Quotes API

A simple Node.js Express application that adds timestamped quotes to PostgreSQL.

## Requirements

- Docker
- Docker Compose

## Setup and Run

1. Start the application:
```bash
docker-compose up --build
```

2. The API will be available at `http://localhost:3000`

## API Endpoints

### Add a Quote
```bash
curl -X POST http://localhost:3000/add-line
```

Response:
```json
{
  "success": true,
  "data": {
    "id": 1,
    "timestamp": "2025-11-30T10:30:00.000Z",
    "quote": "The only way to do great work is to love what you do."
  }
}
```

### Get All Quotes
```bash
curl http://localhost:3000/quotes
```

### Health Check
```bash
curl http://localhost:3000/
```

## Environment Variables

The application uses the following environment variable for database connection:

- `DATABASE_URL`: PostgreSQL connection string (configured in docker-compose.yml)

## Stop the Application

```bash
docker-compose down
```

To remove volumes as well:
```bash
docker-compose down -v
```
