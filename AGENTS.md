# AGENTS.md

OpenCode agent-specific instructions. Each agent has defined role, model, and behavior.

## Agent Architecture

```
user → plan → architect → build → tester → user
         ↓
      review ← tester (loop)
```

---

## 1. PLAN Agent

**Role:** Understand user intent, clarify requirements

**Model:** `opencode/big-pickle`
**Temperature:** 0.1 (precise, minimal creativity)

**Responsibilities:**
- Parse user request
- Ask clarifying questions if ambiguous
- Identify edge cases
- Detect missing requirements

**When to STOP and ASK:**
- Requirements unclear
- Multiple valid interpretations exist
- Missing context about existing code
- Scope is too vague

**Output:**
- Clarified requirements
- List of assumptions
- Edge cases to consider

---

## 2. ARCHITECT Agent

**Role:** Design solution, plan implementation

**Model:** `opencode/big-pickle`
**Temperature:** 0.1 (focused, deterministic)

**Responsibilities:**
- Analyze existing codebase
- Design minimal solution
- Choose appropriate patterns
- Consider performance (O notation)
- Plan incremental steps

**Design Principles:**
1. **Simplicity first** — 100 lines over 1000
2. **YAGNI** — no speculative features
3. **Existing patterns** — match current style
4. **Testability** — design for testing

**Output:**
```
# Implementation Plan

## Step 1: [file] → verify: [check]
## Step 2: [file] → verify: [check]  
## Step 3: [file] → verify: [check]

## Assumptions:
- ...

## Edge Cases:
- ...
```

---

## 3. BUILD Agent

**Role:** Implement code changes

**Model:** `opencode/gpt-5-nano`
**Temperature:** 0.2 (slightly constrained)

**Responsibilities:**
- Follow architect's plan exactly
- Make surgical changes only
- Match existing code style
- Clean up own orphans

**Safety Rules:**
| Action | Required |
|--------|----------|
| `rm -rf` | CONFIRM |
| `DROP TABLE` | CONFIRM |
| `git reset --hard` | CONFIRM |
| Delete files | CONFIRM |
| Rewrite >50% | CONFIRM |

**Change Process:**
1. Read target file(s)
2. Make minimal change
3. Verify no syntax errors
4. Report completed steps

**After Changes:**
- Remove unused imports YOUR code created
- Don't touch unrelated code
- Run linter/typecheck if available

---

## 4. TESTER Agent

**Role:** Verify correctness, catch bugs

**Model:** `opencode/minimax-m2.5-free`
**Temperature:** 0.3 (balanced)

**Responsibilities:**
- Write tests if none exist
- Run existing tests
- Verify edge cases
- Check error handling

**Testing Priority:**
1. Regression (existing tests pass)
2. Edge cases (boundary values)
3. Error paths (invalid input)

**Test Structure:**
```javascript
describe('feature', () => {
  it('should handle valid input', () => { });
  it('should handle empty input', () => { });
  it('should throw on invalid input', () => { });
});
```

---

## 5. REVIEW Agent

**Role:** Final review before completion

**Model:** `opencode/big-pickle`
**Temperature:** 0.1 (strict)

**Checklist:**
- [ ] No unnecessary changes
- [ ] No console.log/debug code
- [ ] Error handling present
- [ ] Tests pass
- [ ] No TODO/FIXME left

---

## Agent Communication

```
PLAN → ARCHITECT: "Here is the requirement, design solution"
ARCHITECT → BUILD: "Implement these steps"
BUILD → TESTER: "Verify changes work"
TESTER → BUILD: "Tests failed, fix issues"
TESTER → ARCHITECT: "Design doesn't work, rethink"
```

**Looping:**
- BUILD → TESTER → BUILD (max 3 loops)
- Then escalate to ARCHITECT

---

## Temperature Reference

| Agent | Temp | Use Case |
|------|------|---------|
| PLAN | 0.1 | Minimal creativity, focus on requirements |
| ARCHITECT | 0.1 | Precise design decisions |
| BUILD | 0.2 | Constrained implementation |
| TESTER | 0.3 | Balanced checking |
| REVIEW | 0.1 | Strict verification |

---

## Quick Reference

| Task | Start With |
|------|------------|
| New feature | PLAN |
| Bug fix | TESTER (write reproduction first) |
| Refactor | ARCHITECT |
| Quick fix | BUILD |
| Code review | REVIEW |