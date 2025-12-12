# ============================================================================
# Pull Request Template
# ============================================================================
# This template ensures pull requests include all necessary information for
# effective code review, testing, and merging. Please fill out all relevant
# sections before requesting review.
# ============================================================================

## Summary
<!-- Provide a clear and concise description of what this PR changes -->
<!-- What problem does this solve? Why is this change needed? -->
<!-- Link to related issue: Closes #123 -->

**What changed:**
- 

**Why this change:**
- 

## Type of Change
<!-- Mark the relevant option with an 'x' -->
- [ ] 🐛 Bug fix (non-breaking change that fixes an issue)
- [ ] ✨ New feature (non-breaking change that adds functionality)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] 📚 Documentation update
- [ ] 🔧 Refactoring (no functional changes)
- [ ] ⚡ Performance improvement
- [ ] 🔒 Security fix
- [ ] 🧹 Code cleanup

## Testing
<!-- Describe the tests you ran and provide instructions for reviewers -->
- [ ] ✅ Tests added/updated for new functionality
- [ ] ✅ All existing tests pass: `uv run pytest`
- [ ] ✅ Code formatting check: `uv run ruff format --check .`
- [ ] ✅ Linting check: `uv run ruff check .`
- [ ] ✅ Type checking: `uv run mypy .`
- [ ] ✅ Manual verification completed (describe below)

**Manual Testing Steps:**
1. 
2. 
3. 

**Test Results:**
<!-- Paste test output or describe test coverage -->

## Code Quality Checklist
<!-- Ensure code quality standards are met -->
- [ ] ✅ Code follows project style guidelines
- [ ] ✅ Self-review completed
- [ ] ✅ Code is commented, particularly complex logic
- [ ] ✅ Documentation updated (if applicable)
- [ ] ✅ No new warnings or errors introduced
- [ ] ✅ No hardcoded values or secrets
- [ ] ✅ Error handling implemented appropriately

## Security Checklist
<!-- Security considerations for this change -->
- [ ] ✅ No secrets or credentials committed
- [ ] ✅ No sensitive data exposed
- [ ] ✅ Input validation implemented (if applicable)
- [ ] ✅ Security implications reviewed
- [ ] ✅ Dependencies scanned for vulnerabilities

## Documentation
<!-- Documentation updates for this change -->
- [ ] ✅ README updated (if needed)
- [ ] ✅ Code comments added for complex logic
- [ ] ✅ Docstrings updated (if applicable)
- [ ] ✅ CHANGELOG updated (if applicable)
- [ ] ✅ API documentation updated (if applicable)

## Dependencies
<!-- List any new dependencies or changes to existing dependencies -->
- [ ] ✅ New dependencies added to `pyproject.toml`
- [ ] ✅ Dependencies are necessary and minimal
- [ ] ✅ Security implications of new dependencies reviewed

## CI/CD
<!-- CI/CD pipeline status -->
- [ ] ✅ All CI checks pass
- [ ] ✅ No merge conflicts
- [ ] ✅ Branch is up to date with base branch

## Screenshots/Demo
<!-- If applicable, add screenshots or a demo of the changes -->
<!-- Drag and drop images here -->

## Additional Notes
<!-- Anything else reviewers should know -->
<!-- - Risks or potential issues -->
<!-- - Rollback plan (if applicable) -->
<!-- - Follow-up tasks -->
<!-- - Performance impact -->
<!-- - Breaking changes and migration path -->

