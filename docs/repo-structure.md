# Repository Structure

## Directory Layout
*(Fill in for your project — example below)*

```
/
├── src/                    # Application source code
│   ├── api/               # Route handlers and controllers
│   ├── services/          # Business logic (no HTTP dependencies)
│   ├── repositories/      # All database access goes here — nowhere else
│   ├── domain/            # Types, interfaces, value objects
│   └── utils/             # Pure utility functions
├── tests/
│   ├── unit/              # Fast, isolated, no I/O
│   ├── integration/       # Uses test DB and queue
│   └── e2e/               # Full user flows
├── adr/                   # Architectural Decision Records
├── .claude/docs/          # Extended docs for Claude (not for humans)
├── .claude/               # Claude Code framework
│   ├── agents/            # Specialized subagent definitions
│   ├── skills/            # On-demand domain knowledge
│   └── hooks/             # Lifecycle quality gates
├── CLAUDE.md              # Claude's constitution (≤120 lines)
└── AGENTS.md              # Universal agent instructions (symlink target)
```

## Module Responsibilities
*(Fill in — what each major module owns and does NOT own)*

| Module | Owns | Does NOT own |
|---|---|---|
| `api/` | HTTP request/response shape | Business logic |
| `services/` | Business logic | DB access, HTTP |
| `repositories/` | All DB queries | Business logic |
| `domain/` | Types and interfaces | Any I/O |

## Cross-Module Rules
- `api/` imports from `services/` only
- `services/` imports from `repositories/` and `domain/` only
- `repositories/` imports from `domain/` only
- No circular imports — if you need one, create an interface in `domain/`

## Naming Conventions
*(Fill in for your project)*
- Files: `kebab-case.ts`
- Classes: `PascalCase`
- Functions/variables: `camelCase`
- Constants: `UPPER_SNAKE_CASE`
- Test files: `<module>.test.ts` in mirrored `tests/` path
