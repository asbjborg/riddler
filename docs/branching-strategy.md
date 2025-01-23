# Branching Strategy

## Protected Branches

- `main` - Production-ready code
- `develop` - Integration branch for features

## Branch Naming

- Feature branches: `feature/description`
- Bug fixes: `fix/description`
- Documentation: `docs/description`
- Release branches: `release/version`

## Workflow

1. Create a new branch from `develop`
2. Make your changes
3. Create a Pull Request to `develop`
4. After review and approval, merge to `develop`
5. Periodically merge `develop` into `main` for releases

## Protection Rules

### Main Branch

- No direct pushes
- Requires pull request
- Requires approval from at least one reviewer
- Must pass all status checks
- Must have linear history (no merge commits)

### Develop Branch

- No direct pushes
- Requires pull request
- Must pass all status checks

## Status Checks Required

- Commit message validation
- Code style checks (coming soon)
- Tests (coming soon)
