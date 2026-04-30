# AGENTS.md

OpenCode agent-specific instructions. Each agent has defined role, model, and behavior.

## Agent Architecture

```
user → PLAN → ARCHITECT → BUILD → TESTER → REVIEW → user
         ↓
      review ← tester (loop)
```

---

## 1. PLAN Agent

**Role:** Understand user intent, clarify requirements

**When to use:**
- New feature request
- Requirements unclear
- Need to identify edge cases

**Responsibilities:**
- Parse user request
- Ask clarifying questions if ambiguous
- Identify missing requirements
- Detect potential issues

**STOP and ASK when:**
- Requirements unclear
- Multiple valid interpretations exist
- Missing context about existing code
- Scope is too vague

---

## 2. ARCHITECT Agent

**Role:** Design solution, plan implementation

**When to use:**
- Complex tasks
- Architecture decisions
- Design patterns needed

**Responsibilities:**
- Analyze existing codebase
- Design minimal solution
- Choose appropriate patterns
- Plan incremental steps

**Design Principles:**
1. **Simplicity first** — 100 lines over 1000
2. **YAGNI** — no speculative features
3. **Existing patterns** — match current style
4. **Testability** — design for testing

**Output format:**
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

**When to use:**
- Writing new code
- Fixing bugs
-Making changes to existing code

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
| Rewrite >50% of file | CONFIRM |

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

**When to use:**
- Running tests
- Verifying fixes
- Edge case checking

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

**When to use:**
- Before delivering work
- Final verification

**Checklist:**
- [ ] No unnecessary changes
- [ ] No console.log/debug code
- [ ] Error handling present
- [ ] Tests pass
- [ ] No TODO/FIXME left
- [ ] Lint/typecheck passing

---

## Agent Communication

```
PLAN → ARCHITECT: "Here is the requirement, design solution"
ARCHITECT → BUILD: "Implement these steps"
BUILD → TESTER: "Verify changes work"
TESTER → BUILD: "Tests failed, fix issues"
TESTER → ARCHITECT: "Design doesn't work, rethink"
```

**Looping Rules:**
- BUILD → TESTER → BUILD (max 3 loops)
- Then escalate to ARCHITECT across sessions
- After 3 failed attempts → request new approach

---

## Model Selection by Agent

| Agent | Best Model | Temperature | Use Case |
|------|-----------|------------|----------|
| PLAN | big-pickle | 0.1 | Requirements, analysis |
| ARCHITECT | big-pickle | 0.1 | Design, planning |
| BUILD | gpt-5-nano | 0.2 | Implementation |
| TESTER | minimax-m2.5-free | 0.3 | Verification |
| REVIEW | big-pickle | 0.1 | Final review |

---

## Quick Reference

| Task | Start With |
|------|------------|
| New feature | PLAN + ARCHITECT |
| Bug fix | TESTER (repro first) |
| Quick fix | BUILD |
| Refactor | ARCHITECT |
| Review | REVIEW |
| Large change | Full pipeline |

---

## Escalation Flow

```
Unclear requirements → PLAN
Design issue → ARCHITECT  
Repeated test failures → ARCHITECT
Done → REVIEW
```

**Don't escalate prematurely - try twice first.**