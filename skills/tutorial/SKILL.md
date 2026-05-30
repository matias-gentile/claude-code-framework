---
name: tutorial
description: Interactive console tutorial for the agent-first engineering framework. Walks through each layer of the framework step by step, with hands-on exercises. Run this on your first day with the framework, or share with a new team member.
---

# Framework Tutorial

You are running an interactive tutorial. Guide the user through the framework step by step.
Do NOT show all steps at once. Present one step, wait for the user to respond, then move on.
Use clear visual separators. Keep each step focused. Use plain language — avoid jargon.
When a technical term is unavoidable, explain it immediately in plain English.

---

## How to run this tutorial

Present this introduction first, then wait:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀  Agent-First Engineering Framework — Tutorial
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

This tutorial has 8 steps. Each one is hands-on —
I'll explain one thing, then we'll actually do it
together using your real project.

Takes about 20 minutes.

Type 'next' to move forward, 'skip' to skip a step,
or ask any question at any time.

Ready? Let's start.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Then wait for the user to respond before continuing.

---

## Step 1 — The Mental Model (2 min)

Present:

```
━━ STEP 1 of 8 — The Big Idea ━━━━━━━━━━━━━━━━━━━━━

Think of yourself as a construction project manager.

You don't mix the concrete yourself. You have
specialists: an architect who reads the plans, a
safety inspector who checks the work, tradespeople
who do the actual building.

You make the decisions. They handle execution.

This framework does the same thing for software:

  YOU (you make the decisions)
  ├── planner      → reads the codebase, makes a plan
  │                  never writes a single line of code
  ├── tdd-writer   → writes tests that define "done"
  │                  before any implementation starts
  ├── [implement]  → writes the actual code
  ├── code-reviewer → reviews changes before they merge
  └── quality-gate → checks everything is really done

The framework itself (the rules file, the skills,
the automatic checks) is your standing orders —
so you don't repeat yourself every time you work.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 Any questions? Or type 'next' to continue.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Answer any questions fully, then wait for 'next'.

---

## Step 2 — CLAUDE.md (the rules file) (3 min)

First, read the actual CLAUDE.md file in this project.
Then present (filling in the bracketed parts with what you actually found):

```
━━ STEP 2 of 8 — CLAUDE.md: The Rules File ━━━━━━━

Every time you open Claude Code, it reads one file
first: CLAUDE.md. Think of it as the standing orders
that every agent follows automatically.

I just read yours. Here's what's in it:

  📏 Length: [X] lines (budget is 120 — beyond that,
     rules start getting missed)
  📋 Main rules: [list the 2-3 most important ones]
  🤖 Agents listed: [count and names]
  🛠  Skills listed: [count and names]

[If under 80 lines]:
  ✅ You have plenty of room to add project-specific rules.
[If 80-120 lines]:
  ✅ Healthy length — you're in the ideal range.
[If over 120 lines]:
  ⚠️ Getting long. Move some content to reference files
     to keep the important rules easy to find.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎯 TRY IT: Let me scan your codebase for rules.

   I'll look for 5 types of project-specific patterns:
   1. Module boundaries — what can import from what?
   2. Wrapper conventions — custom HTTP client, logger, error class?
   3. Naming surprises — anything that differs from language defaults?
   4. Data shape facts — prices in cents? IDs as strings?
   5. Error handling — custom error class? specific pattern?

   I'll scan your code and propose rules. You approve each one
   before it goes into CLAUDE.md.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Scan the codebase using the 5-category approach from the setup skill.
Propose 2-4 rules. For each one, explain WHY it's worth adding — what Claude would get wrong without it.
Wait for the user to approve or reject each. Add approved rules to CLAUDE.md.
Show the lines added. Then wait for 'next'.

---

## Step 3 — The 4-Phase Flow (3 min)

```
━━ STEP 3 of 8 — The 4-Phase Flow ━━━━━━━━━━━━━━━━━

Every task that touches more than one file follows
this sequence. It's a hard rule in CLAUDE.md.

  1. EXPLORE  → planner reads the codebase, finds
                 what will be affected. Read-only.
                 Produces a numbered plan for you.

  2. PLAN     → you review the plan and approve it.
                 Nothing gets written until you say so.

  3. IMPLEMENT → tdd-writer writes failing tests first
                  (tests that prove the feature works),
                  then code is written to pass them.

  4. VERIFY   → the feature is confirmed working
                 end-to-end, not just "tests pass".

Why in this order?

Most developers jump straight to step 3 and start
coding. Then they hit something unexpected, rework
it, hit another thing, rework again.

The planner catches the unexpected stuff upfront.
It takes 2 minutes. It saves 30 minutes of rework.

The tdd-writer writes tests BEFORE code because it
forces a clear definition of "done" before you start.
Without it, you write the test to match whatever you
built, which defeats the purpose.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎯 TRY IT: Describe a small task you need to do
   in this project — one sentence is enough.

   I'll dispatch the planner right now so you can
   see what Phase 1 actually looks like.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Wait for the user's task description. Actually dispatch the planner agent on it.
Show them the output. Point out: the affected files, the risks, the numbered plan.
Then wait for 'next'.

---

## Step 4 — Your Agent Team (3 min)

```
━━ STEP 4 of 8 — Your Agent Team ━━━━━━━━━━━━━━━━━

You have 4 specialists available:

  planner
    What it does: reads the codebase, maps what will
    be affected, writes a numbered plan
    What it CAN'T do: write or edit any file
    When to use: before any multi-file task

  tdd-writer
    What it does: writes failing tests that define
    what "correct behaviour" looks like
    What it CAN'T do: touch your source code (src/)
    When to use: before writing any feature code

  code-reviewer
    What it does: reviews code changes for issues,
    security problems, and architectural violations
    What it CAN'T do: write or edit any file
    When to use: before every merge or pull request

  quality-gate
    What it does: checks 6 things before you can
    call a task done — tests pass, plan complete,
    no unfinished TODOs, commit is clean, etc.
    When to use: before closing any task

Each agent runs completely separately from the others.
A mistake in one can't affect the others' work.

How to use them — just type naturally:
  "Use the planner agent to explore [task]"
  "Use the tdd-writer agent to write tests for [thing]"
  "Use the code-reviewer agent to review this change"
  "Use the quality-gate agent to check this task"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎯 TRY IT: Let's run the code-reviewer on your
   current changes (if you have any).

   Type 'review my changes' or 'next' to skip.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

If they say 'review my changes': run `git diff` first, then dispatch the code-reviewer.
Walk them through the verdict: ✅ Approved / ⚠️ Approved with notes / ❌ Blocked.
Explain what each means. Then wait for 'next'.

---

## Step 5 — Skills (2 min)

```
━━ STEP 5 of 8 — Skills ━━━━━━━━━━━━━━━━━━━━━━━━━━━

Skills are knowledge modules that Claude loads
only when they're relevant to what you're doing.

Why not just put everything in CLAUDE.md?
Because Claude has a memory limit per session.
Loading everything at once wastes that memory on
things you don't need right now. Skills load only
when the topic comes up — keeping memory free.

You have 8 skills installed:

  setup          → run once to auto-fill your project's
                   specific details (stack, test commands,
                   directory structure)

  tutorial       → this tutorial you're doing right now

  verification   → step-by-step flows to confirm a
                   feature works from the user's perspective
                   (different from unit tests)

  tdd-practices  → rules for writing tests before code

  runbook        → what to do when something breaks —
                   a systematic debugging checklist

  session-notes  → writes structured notes to a file
                   during work so summaries come from
                   real records, not fading memory

  adr-recorder   → records architectural decisions
                   (more on this in Step 7)

  api-conventions → REST endpoint design rules

The most important one to actually set up: VERIFICATION.
Verification flows prove your features work from the
user's perspective — not just that the code compiles.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎯 TRY IT: Describe your app's most important
   user-facing feature in one sentence.

   Example: "users can sign up with email and password"
   or "a customer can add items to a cart and check out"

   I'll create a verification flow for it right now.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Wait for their feature description. Read the codebase to understand the feature.
Write a real verification flow into `.claude/skills/verification/SKILL.md`.
Show them the entry that was added — walk through what each field means.
Then wait for 'next'.

---

## Step 6 — Hooks (automatic checks) (2 min)

First, check if `.claude/hooks/.test-command` exists.

If it EXISTS — present:

```
━━ STEP 6 of 8 — Automatic Checks (Hooks) ━━━━━━━━

Hooks are shell scripts that run automatically at
key moments — you never have to remember to trigger
them yourself.

You have 3 hooks set up:

  After every file write
    → runs your test suite automatically
    → if tests fail, Claude sees the output and
       should fix the issue before continuing

  Before every git commit
    → blocks the commit if tests haven't passed
       since the last file was edited
    → this means you can't accidentally commit
       broken code

  When Claude finishes a task
    → asks you the 3 compounding loop questions
       (more on this in the next step)

Your test suite is already configured ✅
  Command: [show contents of .test-command]

Let me run it now to confirm it works:
```

Run the test command. Show the output. If it passes, say "tests are passing — hooks are active."
If it fails, explain the failures are in their code, not the framework.
Then wait for 'next'.

---

If it does NOT exist — present:

```
━━ STEP 6 of 8 — Automatic Checks (Hooks) ━━━━━━━━

Hooks are shell scripts that run automatically at
key moments — you never have to remember to trigger
them yourself.

You have 3 hooks set up:

  After every file write
    → runs your tests automatically
    → Claude sees the results and fixes failures
       before moving on

  Before every git commit
    → blocks the commit if tests haven't passed
    → prevents accidentally committing broken code

  When Claude finishes a task
    → asks the 3 compounding loop questions

For the first two to work, I need to know what
command runs your tests.

This is just the command you'd type in the terminal
to run your test suite. For example:
  npm test
  npx vitest run
  pytest
  go test ./...
  bundle exec rspec
  cargo test

I checked your project and it looks like you're
using [detected stack]. Your test command is
probably: [inferred command]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎯 Is that right? Or tell me the correct command.

   I'll save it and run it now to confirm it works.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Wait for their confirmation or correction.
Write the command to `.claude/hooks/.test-command`.
Run it. Show the output.
If tests pass: "hooks are now active — every file write will trigger this automatically."
If tests fail: "these failures are in your existing code, not the framework. The hooks are
active — they'll catch any new failures too."
Then wait for 'next'.

---

## Step 7 — The Compounding Loop (2 min)

```
━━ STEP 7 of 8 — The Compounding Loop ━━━━━━━━━━━━━

This is the one habit that determines whether the
framework gets more useful over time or stays flat.

After every non-trivial session, ask yourself three
questions. The session-end hook will remind you:

  1. Did Claude get something wrong repeatedly?
     → Add a one-line rule to CLAUDE.md

     Example: Claude kept using axios directly
     instead of your internal wrapper. You add:
     "Never import axios directly — use httpClient
     from src/utils/http.ts"

     Next session: Claude follows it automatically.

  2. Was there an important technical decision?
     → Record it as an ADR (Architecture Decision Record)

     An ADR is a short file that answers: what did
     we decide, why did we decide it, and what did
     we rule out? It lives in the adr/ folder.

     Example decisions worth recording:
     - "We chose Drizzle over Prisma because..."
     - "All API calls go through the gateway service"
     - "We use cursor-based pagination everywhere"

     Future sessions read the relevant ADR before
     touching that area — so decisions don't get
     reversed by accident.

  3. Did a workflow take many back-and-forth turns?
     → Create a skill for it

     If you had to give Claude the same instructions
     3 times this session, those instructions should
     be a skill — loaded automatically next time.

[Check adr/ folder and count files]
[If 0-1]: You've got room to grow. Try the
          adr-recorder after today's session.
[If 2+]:  You're already capturing decisions.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎯 TRY IT: Is there any technical decision you've
   already made for this project?

   Even something small:
   - "We use PostgreSQL, not SQLite"
   - "The frontend is Next.js App Router, not Pages"
   - "We don't use an ORM — raw SQL only"

   Tell me and I'll record it as your first ADR.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Wait for their decision. Use the adr-recorder skill to create the ADR.
Show them the file path and the first few lines of what was written.
Explain: "This file will be read automatically next time Claude works in that area."
Then wait for 'next'.

---

## Step 8 — Your First Real Task (3 min)

```
━━ STEP 8 of 8 — Let's Do a Real Task ━━━━━━━━━━━━━

You've seen every layer of the framework.
Now let's use all of it on something real.

Here's what will happen:

  Step 1: You give me a task
  Step 2: I run the planner → you see the plan
          and approve it (or ask questions)
  Step 3: I run the tdd-writer → you see the
          failing tests that define "done"
  Step 4: I write the code to make tests pass
          (hooks run your tests automatically)
  Step 5: I run the code-reviewer → you see the
          verdict before anything merges
  Step 6: I run the verification skill → confirmed
          working from the user's perspective
  Step 7: We do the compounding loop → capture
          any lessons before closing

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎯 Describe a real task from your backlog.

   It can be small — a bug fix, a small feature,
   or even just a refactor. One sentence is enough.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Run the full 4-phase flow on their actual task. Use real agents.
Narrate what's happening at each step in plain language — don't assume they understand.
After completion, run the compounding loop checkpoint.

Then present the completion message:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎉 Tutorial Complete

Here's what we did today:
  ✅ Added a project-specific rule to CLAUDE.md
  ✅ Configured your test command (hooks are active)
  ✅ Created a verification flow for [feature]
  ✅ Recorded your first ADR for [decision]
  ✅ Ran the full 4-phase flow on a real task

Daily cheat sheet:
  "Use the planner agent to..."        → before any task
  "Use the tdd-writer agent to..."     → before writing code
  "Use the code-reviewer agent..."     → before merging
  "Use the quality-gate agent..."      → before closing
  "Run the verification skill for..."  → to confirm it works
  /usage                               → see how much was used
  /compact then /clear                 → clean up at session end

The 3 questions to ask at the end of every session:
  1. What did Claude get wrong? → rule in CLAUDE.md
  2. Was there a decision? → adr-recorder skill
  3. What took too many turns? → make it a skill

That's the whole framework.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
