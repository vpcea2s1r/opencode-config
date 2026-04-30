# CLAUDE.md

OpenCode instructions based on expert practices from GitHub communities (Karpathy, everything-claude-code, and OSS best practices).

## Core Principles

### 1. Think Before Coding
**Don't assume. Don't hide confusion. Surface tradeoffs.**

- State assumptions explicitly before implementing
- If unclear, ask - don't guess
- Present multiple approaches when ambiguity exists
- Push back if simpler solution exists
- If something is unclear, stop and ask

### 2. Simplicity First
**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked
- No abstractions for single-use code
- No "flexibility" that wasn't requested
- No error handling for impossible scenarios
- If 200 lines could be 50, rewrite it
- Consider O(n) vs O(1) for performance

### 3. Surgical Changes
**Touch only what you must. Clean up only your own mess.**

- Don't "improve" adjacent code
- Don't refactor things that aren't broken
- Match existing style exactly
- If you notice unrelated dead code, mention - don't delete

### 4. Goal-Driven Execution
**Define success criteria. Loop until verified.**

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

---

## Agent Workflow

### Standard Pipeline
```
user → PLAN → ARCHITECT → BUILD → TESTER → REVIEW → user
         ↓
      review ← tester (loop)
```

### Agent Responsibilities

| Agent | Role | When to Use |
|-------|------|-------------|
| PLAN | Understand requirements, ask clarifying questions | New feature, unclear requirements |
| ARCHITECT | Design solution, plan implementation | Complex tasks, architecture decisions |
| BUILD | Implement code changes | Writing code, fixes |
| TESTER | Verify correctness, run tests | Testing, validation |
| REVIEW | Final review before completion | Before deliver |

### When to Escalate

- Requirements unclear → Ask PLAN
- Design doesn't work → Escalate to ARCHITECT
- Tests failing repeatedly → Escalate to ARCHITECT
- Done → REVIEW

---

## Test-First Default

**Always write tests before implementation.**

1. Write failing test first
2. Run test - verify failure
3. Write code to make test pass
4. Run test - verify pass
5. Run all tests - verify no regressions

If no tests exist:
- Create them before adding features
- Create them before fixing bugs

---

## Iterative Approach

**Small batches. Verify after each.**

- Max 2-3 files per pass
- After each change: run tests, lint, typecheck
- Show progress and ask before continuing
- For large changes: propose incremental plan

---

## Safety & Verification

**Always verify destructive operations.**

| Action | Required |
|--------|----------|
| `rm -rf` | CONFIRM before running |
| `DROP TABLE` | CONFIRM |
| `git reset --hard` | CONFIRM |
| Delete files | CONFIRM |

**Always show diff before applying changes.**

---

## Trivial Mode

**Fast path for simple tasks.**

For trivial tasks (typo fixes, one-liners):
- Skip full process
- Just make the change directly
- Use judgment

Examples: print formatting, rename variable, simple typo fix, add import

---

## Context Engineering

### Before Starting
1. Check project structure
2. Identify existing patterns
3. Ask about architecture if unclear

### During Work
1. Keep context minimal but sufficient
2. Use checkpoints for long tasks
3. Summarize progress periodically

### Memory Persistence
- Key decisions → document for future sessions
- Patterns discovered → note for reuse

---

## Token Optimization

### Model Selection by Task

| Task Type | Model | Reasoning |
|----------|-------|-----------|
| Quick questions | gpt-5-nano | Fast, low cost |
| Implementation | gpt-5-nano / big-pickle | Balanced |
| Complex analysis | big-pickle | Most capable |
| Testing | minimax-m2.5-free | Verification |

### Prompt Optimization
- Be specific about format needed
- State constraints explicitly
- Avoid redundant context

---

## Verification Checklist

Before completing any task:

- [ ] Tests written and passing
- [ ] No unintended changes to other files
- [ ] Lint/typecheck passing
- [ ] No console.log/debug code left
- [ ] Error handling appropriate
- [ ] No TODO/FIXME left (unless acknowledged)

---

## Anti-Patterns to Avoid

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Silently assume format | Wrong implementation | Ask for clarification |
| Build abstraction up front | Overcomplication | Wait until pattern emerges |
| Fix adjacent code while editing | Scope creep | Only touch requested code |
| "Make it work" | Unclear success | Define specific criteria |
| Write code then test | Not test-driven | Test first, then code |

---

## Quick Reference

### Workflow
1. Understand requirements (PLAN)
2. Design solution (ARCHITECT)
3. Implement (BUILD)
4. Test (TESTER)
5. Review (REVIEW)

### Success Criteria
- Test passes
- Code does exactly what asked
- No regressions
- Clean diff (only necessary changes)

---

**Good code solves today's problem simply, not tomorrow's problem prematurely.**

**These guidelines working if:** fewer unnecessary changes, fewer rewrites, clarifying questions come before mistakes.