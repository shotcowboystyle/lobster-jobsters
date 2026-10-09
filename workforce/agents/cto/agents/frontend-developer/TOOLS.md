# TOOLS.md - Frontend Developer Notes

## Build & Dev
- Dev server: `npm run dev`
- Production build: `npm run build && npm start`
- Linter: `npm run lint`
- Tests: `npm test` (unit), `npx playwright test` (E2E)

## Performance Targets
- LCP < 2.5s
- FID < 100ms  
- CLS < 0.1
- Total bundle < 200KB gzipped (initial load)
