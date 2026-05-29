#!/usr/bin/env bash
# Stop hook: fires when Claude finishes a task
# Prompts the compounding loop: capture lessons before clearing context

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔁 Compounding Loop Checkpoint"
echo "   Before you /clear or close the session:"
echo "   1. Any architectural decisions made? → run 'adr-recorder' skill"
echo "   2. Any rules Claude got wrong? → add to CLAUDE.md"
echo "   3. Any repeatable workflow? → consider a new skill"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
