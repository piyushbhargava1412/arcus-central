# Flow: Story Closure

**Agent**: `sdd.close`  
**Purpose**: Produce a concise completion summary for a finished story, refresh impacted `.context/` artifacts using story-scoped context, and archive the story directory.  

In-scope:
- Resolve story ID and validate artifacts exist (`spec.md`, `tasks.md`).  
- Run story-scoped context sync (no-op if context already current).  
- Generate `completion-summary.md` and archive story to `.arcus/archive/<STORY-ID>/`.

Inputs:
- Story artifacts under `.arcus/specs/<STORY-ID>/`  
- `.arcus-metadata.json` (for arcus version)  

Outputs:
- `.arcus/specs/<STORY-ID>/completion-summary.md`  
- `.arcus/archive/<STORY-ID>/` (archived story directory)  
- Possibly updated `.context/` artifacts (if drift detected and updated)

Primary skills used:
- `session-bootstrap`
- `context-sync` (story-scoped)
- `markdown-generation`
- `markdown-validation`
- `report-renderer`

Entry criteria: Story tasks and spec present; user requests closure.  
Exit criteria: Summary generated, archive created, `.context/` refreshed if applicable.

