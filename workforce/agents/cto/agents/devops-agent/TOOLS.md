# TOOLS.md - DevOps Agent Notes

## Infrastructure
- Hosting: To be determined (Vercel / Railway / VPS)
- CDN: Cloudflare or Vercel Edge
- DNS: Managed through hosting provider

## CI/CD
- Pipeline: GitHub Actions
- Environments: staging → production
- Branch protection: main requires PR + CI pass

## Monitoring Targets
- Uptime: 99.9%+ (max ~43min downtime/month)
- API p95 response: <500ms
- LCP: <2.5s
- Error rate: <1% of requests

## Backup Schedule
- Database: daily automated, weekly restore test
- User uploads: daily automated
- Config: version controlled in Git
