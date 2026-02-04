# CLAUDE.md - AI Assistant Guidelines for M2M

This document provides context and guidelines for AI assistants working with the M2M repository.

## Project Overview

**Repository:** M2M (Kali-Dedwen/M2M)
**Status:** Initial setup phase
**Last Updated:** 2026-02-03

M2M is a new project repository. This CLAUDE.md serves as the foundational documentation for AI assistants and should be updated as the project develops.

## Repository Structure

```
/home/user/M2M/
├── CLAUDE.md           # AI assistant guidelines (this file)
├── README.md           # Project overview and setup
├── .git/               # Git version control
└── (project files to be added)
```

### Recommended Structure (as project grows)

```
M2M/
├── CLAUDE.md           # AI assistant guidelines
├── README.md           # Project documentation
├── src/                # Source code
│   ├── main/           # Main application code
│   └── lib/            # Shared libraries
├── tests/              # Test files
├── docs/               # Documentation
├── scripts/            # Build/utility scripts
└── config/             # Configuration files
```

## Development Workflow

### Git Conventions

1. **Branch Naming:**
   - Feature branches: `feature/<description>`
   - Bug fixes: `fix/<description>`
   - AI-assisted work: `claude/<session-identifier>`

2. **Commit Messages:**
   - Use clear, descriptive commit messages
   - Format: `<type>: <short description>`
   - Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`
   - Example: `feat: add user authentication module`

3. **Pull Requests:**
   - Include clear description of changes
   - Reference related issues
   - Ensure all tests pass before merging

### Code Style Guidelines

When code is added to this project, follow these conventions:

1. **General Principles:**
   - Write clean, readable code with meaningful names
   - Keep functions small and focused
   - Avoid over-engineering; implement only what's needed
   - Don't add features beyond what was requested

2. **Documentation:**
   - Add comments only where logic isn't self-evident
   - Keep documentation up-to-date with code changes
   - Update this CLAUDE.md when project structure changes

3. **Security:**
   - Never commit secrets or credentials
   - Validate all external inputs
   - Follow OWASP security guidelines

## Build and Run Commands

*(To be updated as build system is established)*

```bash
# Placeholder commands - update when build system is configured
# npm install / pip install / cargo build / etc.
# npm run dev / python main.py / cargo run / etc.
# npm test / pytest / cargo test / etc.
```

## Testing

*(To be updated as testing framework is configured)*

- All new features should include tests
- Maintain test coverage for critical paths
- Run tests before committing changes

## Dependencies

*(To be updated as project dependencies are added)*

No dependencies configured yet. Update this section when:
- Package manager is chosen (npm, pip, cargo, etc.)
- Dependencies are added to the project
- External services are integrated

## Configuration

*(To be updated as configuration needs are defined)*

Expected configuration files:
- Environment variables: `.env` (never commit, use `.env.example`)
- Application config: `config/` directory
- CI/CD: `.github/workflows/` or equivalent

## Key Architectural Decisions

*(Document important decisions here as they are made)*

| Decision | Rationale | Date |
|----------|-----------|------|
| Initial repo setup | Starting fresh M2M project | 2026-02-03 |

## Common Tasks for AI Assistants

### When Adding New Features
1. Read existing code to understand patterns
2. Plan changes using TodoWrite tool
3. Implement incrementally with clear commits
4. Add tests for new functionality
5. Update documentation as needed

### When Fixing Bugs
1. Reproduce and understand the issue
2. Identify root cause before coding
3. Make minimal targeted changes
4. Add regression tests
5. Document the fix in commit message

### When Refactoring
1. Ensure tests exist before refactoring
2. Make incremental changes
3. Keep functionality identical
4. Run tests after each change

## Important Files to Know

| File | Purpose |
|------|---------|
| `CLAUDE.md` | AI assistant guidelines (this file) |
| `README.md` | Project overview and setup |

## Notes for AI Assistants

1. **Always read before writing:** Understand existing code before making changes
2. **Keep changes focused:** Only modify what's necessary for the task
3. **Track your work:** Use TodoWrite to plan and track complex tasks
4. **Commit incrementally:** Make small, logical commits
5. **Update this file:** Keep CLAUDE.md current as the project evolves
6. **Ask when uncertain:** If requirements are unclear, ask for clarification

## Contact and Resources

*(Add relevant links and contacts as established)*

- Repository: Kali-Dedwen/M2M
- Issues: Use GitHub issues for bug reports and feature requests

---

*This CLAUDE.md will be expanded as the M2M project develops. AI assistants should update this file when significant architectural decisions are made or when the project structure changes.*
