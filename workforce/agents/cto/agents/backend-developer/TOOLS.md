# TOOLS.md - Backend Developer Notes

## Database
- Primary: PostgreSQL
- Cache: Redis
- ORM: Prisma or Drizzle (type-safe)

## Key Integrations
- Payments: Stripe (Checkout, Webhooks, Customer Portal)
- Email: Transactional service for confirmations and reminders
- Auth: NextAuth / Auth.js

## API Conventions
- REST: /api/v1/...
- Error format: { error: { code, message, details? } }
- Pagination: cursor-based for large collections
