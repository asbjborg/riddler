# Branching Strategy

## Protected Branches

### Main Branch (`main`)
- Production-ready code
- Strict protection rules
- Used for releases

## Branch Naming

- Feature branches: `feature/description`
- Bug fixes: `fix/description`
- Documentation: `docs/description`
- Release branches: `release/version`

## Protection Rules

### Main Branch
- No direct pushes
- Requires pull request
- Requires approval from at least one reviewer
- Must pass all status checks
- Must have linear history (no merge commits)
- Must be up to date before merging

### All Other Branches
- No direct pushes
- Requires pull request
- Must pass all status checks
- Must be up to date before merging
- Allows merge commits
- Flexible merge strategies (merge, squash, rebase)

## Workflow

1. Create a new feature branch with appropriate prefix
2. Make your changes
3. Create a Pull Request
4. Address review comments
5. Merge after approval and passing checks

## Status Checks Required
- Commit message validation (conventional commits)
- Code style checks (coming soon)
- Tests (coming soon)
