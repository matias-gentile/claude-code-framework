---
name: api-conventions
description: Enforces REST API design conventions. Invoke for any endpoint, route, or HTTP handler creation or modification.
---

# API Conventions

## URL Design
- `kebab-case` for all path segments: `/user-profiles`, not `/userProfiles`
- Version in URL path: `/v1/`, `/v2/`
- Plural nouns for collections: `/v1/orders`
- Sub-resources nested logically: `/v1/users/{userId}/orders`

## HTTP Methods
| Action | Method |
|---|---|
| Fetch list | GET |
| Fetch one | GET |
| Create | POST |
| Full replace | PUT |
| Partial update | PATCH |
| Delete | DELETE |

## Response Envelope (all responses)
```json
{
  "data": { },
  "meta": { "requestId": "uuid", "timestamp": "iso8601" },
  "error": null
}
```

On error, `data` is `null` and `error` is populated:
```json
{
  "data": null,
  "meta": { "requestId": "uuid", "timestamp": "iso8601" },
  "error": { "code": "NOT_FOUND", "message": "Resource not found." }
}
```

## Pagination (required on all list endpoints)
```json
{
  "data": [],
  "meta": { "nextCursor": "abc123", "hasMore": true, "total": 340 }
}
```
Use cursor-based pagination by default. Never return unbounded lists.

## JSON Properties
- `camelCase` for all JSON property names

## Status Codes
| Code | When |
|---|---|
| 200 | Success (GET, PATCH, PUT) |
| 201 | Created (POST) |
| 204 | No content (DELETE) |
| 400 | Validation error |
| 401 | Unauthenticated |
| 403 | Forbidden |
| 404 | Not found |
| 409 | Conflict / duplicate |
| 500 | Server error — never expose stack traces |

## Authentication
- `Authorization: Bearer <token>` header only
- Never accept credentials in URL query parameters
- Never log tokens, cookies, or Authorization headers
