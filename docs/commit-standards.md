# Commit Message Standards

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification for commit messages.

## Format

```text
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

## Types

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools

## Scope

The scope should be the area of the addon being modified:

- `core`: Core addon functionality
- `ui`: User interface components
- `quiz`: Quiz/question related changes
- `db`: Database/storage changes
- `loc`: Localization
- `deps`: Dependencies
- `tools`: Development tools and scripts

## Examples

```text
feat(ui): add score display panel
fix(core): prevent duplicate questions in same session
docs(readme): update installation instructions
style(ui): improve button alignment
refactor(quiz): simplify question loading logic
chore(tools): update PR creation script
```

## Commit Validation

We use GitHub Actions to validate commit messages. Invalid commit messages will be flagged during pull requests.
