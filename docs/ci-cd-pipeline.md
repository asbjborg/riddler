# CI/CD Pipeline

This document outlines the Continuous Integration and Continuous Deployment pipeline for Riddler.

## Overview

Our pipeline automates testing, building, and releasing of the Riddler addon using GitHub Actions.

## Pipeline Stages

### 1. Testing
- Lua syntax validation
- Unit tests (when implemented)
- Integration tests (when implemented)

### 2. Building
- Package addon files
- Generate release artifacts
- Version number validation

### 3. Deployment
- Automatic releases on version tags
- GitHub release creation
- Changelog generation

## Release Process

1. Create a new version tag (e.g., `v1.0.0`)
2. Push tag to trigger release workflow
3. Pipeline automatically:
   - Runs all tests
   - Packages the addon
   - Creates GitHub release
   - Attaches artifacts

## Future Improvements

- [ ] Add automated version number updates in .toc file
- [ ] Implement automated changelog generation
- [ ] Add code quality checks
- [ ] Set up automated dependency updates 