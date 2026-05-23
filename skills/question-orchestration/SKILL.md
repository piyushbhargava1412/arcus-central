---
name: question-orchestration
description: Conduct interactive questioning one question at a time with recommendations, answer capture, and configurable iteration limits. Use when an agent needs to clarify ambiguities, confirm scope decisions, or gather structured input from the user during spec clarification, plan confirmation, or discovery workflows.
metadata:
  version: "1.0.0"
  type:
    - agents
---

# Question Orchestration

## Purpose

Own interactive questioning flow for any stage: one question at a time, provide recommendations, capture answers, track iteration limits. Used by clarification, confirmation, and exploratory workflows.

## Inputs

- `question_queue`: prioritized list of clarification/confirmation candidates
- `max_questions`: iteration limit (e.g., 5 for spec clarifications, 3 for scope confirmations)
- `user_interaction_mode`: "clarify" (spec), "confirm" (scope/architecture), "explore" (discovery)

## Processing Rules

1. Present one question at a time in chat.
2. For each question, provide a recommended answer with 2-5 options or free-form (≤5 words).
3. Record user's response and validate against format/options.
4. Move to next question only after valid answer received.
5. Stop at `max_questions` limit.
6. Track cumulative question count across session.
7. Return mapping of answers to artifact sections or scope areas for patching.

## Output Contract

- Must return:
  - ordered list of `{ question, user_answer, recommended_option }` tuples
  - mapping of answers to artifact sections or decision points
- Must not return:
  - unanswered questions
  - implementation design guidance

## Validation Gates

- [ ] One question presented at a time
- [ ] Each question answered before proceeding
- [ ] Total questions <= max_questions
- [ ] Answers are actionable and specific
- [ ] No speculative LLM assumptions

## Failure Modes

- `QUESTION_UNANSWERED`: re-ask clarification if response ambiguous
- `QUESTION_LIMIT_EXCEEDED`: stop at max_questions; report unanswered queue
- `INVALID_RESPONSE_FORMAT`: ask user to re-answer in prescribed format

