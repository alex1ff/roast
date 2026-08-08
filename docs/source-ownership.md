# Source ownership and change strategy

FlutterFlow export is retired. This Git repository is the authoritative source and no change needs to remain compatible with future regeneration.

## Working rules

- Generated-style widgets are editable, but large mechanical rewrites are avoided unless they solve a measured problem.
- Durable business rules belong in `lib/services/`, typed backend adapters, Firebase rules, or Cloud Functions.
- Page widgets should render state, collect input, invoke a use case, and present user-safe feedback.
- Active custom code remains under static analysis; rollback copies do not belong in `lib/`.
- Provider secrets and production datasets never enter the repository.

## Verification

Every maintained change runs:

```bash
flutter analyze
flutter test
npm run backend:checks
git diff --check
```

Release-size changes also use the measurement process in [performance-baseline.md](performance-baseline.md).
