# Development Workflow & Best Practices

## Commands

- `npm run build` - Build the project
- `npm run typecheck` - Run the typechecker
- `turbo typecheck lint` - Run typecheck and lint across workspace
- `prettier --write <file>` - Format newly created files

## Code Style

- Use ES modules (`import`/`export`) syntax, not CommonJS (`require`)
- Destructure imports when possible: `import { foo } from 'bar'`
- Use TypeScript strict mode
- Prefer `const` over `let`, avoid `var`
- Use meaningful variable and function names

## Git Branch Strategy

**Baseline: GitHub Flow (simplified)**

- `main` - Always deployable, protected branch
- `feature/*` - Feature branches (e.g., `feature/add-user-auth`)
- `fix/*` - Bug fix branches (e.g., `fix/login-error`)
- `refactor/*` - Refactoring work (e.g., `refactor/api-client`)

**Workflow:**
1. Create branch from `main`: `git checkout -b feature/my-feature`
2. Make incremental commits as you work
3. Push to origin regularly
4. Open PR when ready for review
5. Merge to `main` after approval
6. Delete feature branch after merge

**Branch naming:** Use lowercase with hyphens, be descriptive

## Commit Strategy

**Critical: Write commits as you go for each task step**

**Baseline commit message format:**
```
<type>: <description>

[optional body explaining why, not what]
```

**Types:** `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

**Examples:**
- `feat: add user authentication endpoint`
- `fix: resolve race condition in data loader`
- `refactor: extract validation logic to utility`
- `test: add unit tests for payment processing`

**Benefits:**
- Easy reversion if something goes wrong
- Clear history of incremental progress
- Enables granular rollback by you or automated tools

## Testing Strategy

**Baseline: Test-driven development when feasible**

- Write tests for new features before or alongside implementation
- **Prefer single test execution** during development for speed
- Run full test suite before committing to `main`
- Maintain minimum 80% code coverage for critical paths
- Integration tests for API endpoints
- Unit tests for business logic and utilities

**Test naming:** Describe behavior, not implementation
```javascript
// Good
test('returns 401 when user is not authenticated')

// Avoid
test('checkAuth function')
```

## Development Cycle

1. Create feature branch
2. Make code changes
3. Write/update tests
4. Run relevant tests
5. **Commit incrementally** after each logical task step
6. Run `turbo typecheck lint` after a series of changes
7. Run Prettier on newly created files
8. Push to remote regularly

## Dependency Management

**Baseline: Conservative and deliberate**

- Evaluate new dependencies carefully (bundle size, maintenance, security)
- Use exact versions in `package.json` for critical dependencies
- Run `npm audit` before adding packages
- Document why significant dependencies were added
- Update dependencies monthly, not reactively
- Test thoroughly after dependency updates

**Before adding a dependency:**
1. Is this functionality already available?
2. Can we implement it simply in-house?
3. Is the package actively maintained?
4. What's the bundle size impact?

**Commands:**
```bash
npm install <package>          # Add dependency
npm install -D <package>       # Add dev dependency
npm audit fix                  # Fix security issues
npm outdated                   # Check for updates
```

## Documentation Requirements

**Baseline: Document as you build**

**Required documentation:**
- Public APIs: JSDoc comments with parameters, return types, examples
- Complex algorithms: Inline comments explaining the "why"
- New features: Update README or feature docs
- Breaking changes: Migration guide in CHANGELOG
- Setup steps: Keep README current

**When to document:**
- New public functions/classes: Always
- Bug fixes: Add comment if non-obvious
- Refactors: Update affected docs
- Configuration changes: Update setup docs

**Format:**
```typescript
/**
 * Authenticates user credentials and returns JWT token
 *
 * @param email - User's email address
 * @param password - User's password
 * @returns JWT token string
 * @throws AuthenticationError if credentials invalid
 *
 * @example
 * const token = await authenticate('user@example.com', 'password123')
 */
```

## Code Review Process

**Baseline: Self-review before committing**

**Self-review checklist:**
- [ ] Code follows style guide (ES modules, destructuring)
- [ ] All tests pass
- [ ] TypeScript errors resolved
- [ ] No console.logs or debugging code
- [ ] Error handling implemented
- [ ] Edge cases considered
- [ ] Documentation updated
- [ ] No hardcoded secrets or credentials
- [ ] Performance implications considered
- [ ] Accessibility requirements met (if UI)

**PR review guidelines:**
- Keep PRs small (<400 lines changed)
- Write descriptive PR descriptions
- Link related issues
- Request review from relevant team members
- Respond to feedback constructively

## Performance Considerations

**Baseline targets:**

- **Bundle size:**
  - Main bundle: < 200KB gzipped
  - Individual chunks: < 50KB gzipped
  - Monitor with `npm run build` size analysis

- **Build time:**
  - Development build: < 5 seconds
  - Production build: < 60 seconds
  - If exceeded, investigate and optimize

- **Test execution:**
  - Unit tests: < 10 seconds total
  - Integration tests: < 30 seconds total
  - E2E tests: < 2 minutes total

**Performance checklist:**
- [ ] Images optimized and appropriately sized
- [ ] Lazy loading for heavy components
- [ ] Database queries indexed
- [ ] API responses paginated
- [ ] Memoization for expensive calculations
- [ ] No unnecessary re-renders (React)

**Monitoring:**
- Check bundle size after adding dependencies
- Profile slow tests and optimize
- Use build tools to identify bottlenecks

## TypeScript Error Handling

**Baseline: Zero tolerance**

- Fix TypeScript errors immediately, don't accumulate
- Never use `@ts-ignore` without explanation comment
- Prefer proper typing over `any`

**Error resolution:**
- **< 5 errors:** Review and address individually
- **≥ 5 errors:** Consider using auto-error-resolver agent

## Automated Post-Response Hook

After AI code generation completes:
1. Read edit logs to identify modified repositories
2. Run build scripts on affected repositories
3. Check for TypeScript errors
4. Present errors to AI if < 5, recommend resolver if ≥ 5
5. Log all actions

## Context Management

**⚠️ Warning: Document progress when context reaches ~30%**

When approaching context limits:
1. Commit all current work
2. Document completed tasks and next steps
3. Clear context window
4. Resume with documented state

This prevents context loss and maintains workflow continuity.

## Pre-Push Checklist

Before pushing to remote:
- [ ] All tests passing
- [ ] `turbo typecheck lint` runs clean
- [ ] Prettier applied to new files
- [ ] Incremental commits made throughout
- [ ] Code follows ES module style
- [ ] Documentation updated
- [ ] Self-review completed
- [ ] No sensitive data in commits

## Resources

- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitHub Flow](https://guides.github.com/introduction/flow/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
