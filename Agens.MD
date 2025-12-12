# Agent Rules and Guidelines

## IMPORTANT: File Protection Rule
#1 - **Never write or change this file** - This file serves as immutable reference documentation for agent behavior and coding standards.

## Code Documentation Standards
#2 - **Make FULL commentaries with each line of code** - Every line of code must include comprehensive comments that explain the underlying logic, purpose, and implementation details. This documentation serves as the primary mechanism for understanding code logic and should be detailed enough for future maintainers to grasp the intent and execution flow without additional context.

## Logging and Change Tracking
#3 - **Create AgentsLog.json Schema** - Maintain a well-documented JSON schema as commentary within the AgentsLog.json file. This schema should track all changes with timestamps. When adding entries, append new timestamped blocks before the final line rather than rewriting the entire file. Each entry should document:
   - Timestamp of the change
   - Files modified or created  #
   - Interactions and dependencies
   - Summary of changes
   - Integration points affected

## Development Workflow
#4 - **Use thinking before reading each file** - Before reading any file, perform the following sequence:
   1. Analyze the file's purpose and expected structure
   2. Use web search to identify best practices, techniques, and libraries
   3. Research integration patterns relevant to the codebase
   4. Review the code summary and roadmap for context
   5. Only then proceed to write or modify code

## Branch Protection
#5 - **Never pull to master branch** - All changes must be made through feature branches. Direct commits or pulls to the master/main branch are strictly prohibited. Use pull requests for all merges.

## Encoding Standards
#6 - **UTF-8 output token format** - All code, documentation, and output must use UTF-8 encoding to ensure proper character representation and internationalization support.

## Language Standard
#7 - **Always in English** - All code comments, documentation, variable names, function names, and communication must be in English to maintain consistency and accessibility for the development team.

## Code Quality and CI/CD Integration
#8 - **Analyze code for proper efficiency with .yml CI/CD** - Before committing code, verify that:
   - The code integrates properly with CI/CD workflows defined in `.yml` files
   - All CI/CD pipeline steps will execute correctly
   - Code follows best practices for automated testing and deployment
   - Performance and efficiency are optimized for CI/CD environments

## Code Quality Assurance
#9 - **Fix, add, check lints** - Before finalizing any code changes:
   - Fix all existing linting errors
   - Add necessary linting configurations if missing
   - Run lint checks to ensure code quality
   - Verify that no new linting issues are introduced




