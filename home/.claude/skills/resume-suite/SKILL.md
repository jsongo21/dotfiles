---
name: resume-suite
description: Combined resume review and tailoring for technical roles. Use for reviewing the master resume, generating tailored applications for specific jobs, improving bullet quality or skills sections. Understands the LaTeX source format, the tailored/ directory structure and the Singapore job market. Combines review framework with a multi-phase tailoring workflow including experience discovery.
---

# Resume Suite

Project root: `/Users/jason/Documents/personal/job/singapore`
Master resume: `{root}/resume.tex`
Tailored resumes: `{root}/tailored/{slug}/resume.tex`
Build command: `make tailored COMPANY={slug}` (run from root)
Master PDF build: `make pdf`

## Mode Detection

**Review mode** — user asks to review, audit, check or improve the master resume without a specific job.

**Tailor mode** — user provides a job description (text or URL) or names a specific company/role to apply for.

Confirm mode if ambiguous.

---

## Review Mode

### Step 1: Read the resume

Read `resume.tex` from the project root.

### Step 2: Apply the framework

Work through each section below. Classify each issue as:
- **Critical** — will cost interviews
- **Important** — reduces effectiveness
- **Minor** — polish

Output grouped by section, prioritised within each group. Rewrite specific bullets only where it adds value — do not rewrite the entire resume. End with a numbered priority list ordered by impact.

### Contact

Required: name, city/country, email, LinkedIn, GitHub, portfolio.

Missing phone number is **critical** for Singapore. Recruiters and hiring managers contact via WhatsApp first. Flag any email formatting that reads oddly.

### Professional Summary

Check for:
- Consistent grammatical voice throughout (no person-shift mid-paragraph)
- Concrete claims over vague ones ("influencing architecture decisions" needs an outcome)
- AI tools framed as productivity evidence, not identity ("actively applying" over "fluent in")
- No filler sentences or marketing speak

### Technical Skills

Preferred category order: Languages, Frontend, Backend, Cloud, DevOps, Databases, AI Tools, Testing, Observability.

Flag:
- Misplaced items (auth services belong in Cloud, not Backend)
- Basics that add noise for a senior engineer (HTML, CSS on their own)
- Generic entries that are made redundant by specifics (standalone "CI/CD" when GitHub Actions is listed)
- Anything claimed that cannot be discussed in depth in an interview

Group AWS services with parenthetical detail: `AWS (Lambda, ECS, Step Functions, ...)`.

### Experience: Bullet Quality

Apply the formula: **[Action verb] + [Technical what] + [Scale or impact]**

**Strong action verbs:** Architected, Engineered, Resolved, Designed, Migrated, Built, Optimised, Delivered, Unblocked, Led

**Weak patterns to flag:**
- Process over outcome ("Mapped the codebase to identify..." — what did that enable?)
- Vague scale ("thousands of properties" — how many exactly?)
- No metric and no scope indicator
- Redundant bullets covering the same achievement

**Metric types to surface:**
- Users or scale: "serving 10,000+ students", "millions of Australian consumers"
- Performance: "reduced from 30s to 200ms (99% reduction)"
- Volume: "50+ Azure Functions", "100+ endpoints"
- Time saved: "reduced deployment from 2 hours to 15 minutes"
- Business impact: "unblocking bulk publishing for energy retailers"

If a precise metric is unavailable, scope or complexity is acceptable: "across tens of thousands of student records", "a complete structural redesign".

**Bullet allocation by recency:** the most recent role gets the most bullets. A 2022-2023 role should not outbullet a current role.

### Consulting/Client Structure

The nested client structure (Company → Client → bullets) reads well to consulting-aware recruiters but can confuse product company hiring managers.

For master resume review, check each client section:
- At least one metric-bearing bullet per client
- Most recent client deserves highest scrutiny — all-process bullets here is **critical**
- Look for client sections with thin coverage that could be strengthened using bullets from tailored versions

When tailoring for a product company, consider flattening the most relevant client into the top-level role entry (see Tailor Mode, Phase 2).

### Education

No changes needed if the degrees, honours project and year are accurate.

---

## Tailor Mode

### Phase 0: Intake

1. Parse the job description (WebFetch if URL provided, otherwise read pasted text)
2. Read `resume.tex` (master)
3. Scan `tailored/*/resume.tex` for any existing tailored versions
4. Build an experience inventory: all roles, bullets and metrics currently documented

Extract from the JD:
- Must-have requirements
- Nice-to-have requirements
- Implicit signals (team size, seniority, working style)
- Terminology map (their language vs the resume's language)
- Red flags or gaps to address

### Phase 1: Research

Run targeted web searches:
- `{company} engineering culture values`
- `{company} tech stack engineering blog`
- `{company} recent news`
- LinkedIn for people in equivalent roles at the company (for background and terminology)

Synthesise into a success profile:
- What the role actually needs beyond the literal JD
- Cultural fit signals
- Narrative angle to lead with
- Risk factors (gaps, seniority questions) and how to mitigate them

**Checkpoint 1** — present the success profile and proposed structure. Wait for approval before proceeding.

Present:
- Top 5 key requirements
- Cultural signals identified
- Narrative angle recommended
- Gaps identified
- Proposed bullet allocation per role
- Any sections to add or drop

Adjust based on feedback, then continue.

### Phase 2: Template Decisions

Decide structure for this specific role.

**Role consolidation:** consolidate same-company positions when the narrative is stronger combined and page space is tight. Keep separate when responsibilities differ substantially or the progression itself is the story.

**Client flattening:** when tailoring for a product company, consider promoting the most relevant client engagement to the top-level Mantel Group entry rather than nesting it. This reads more naturally to product company hiring managers unfamiliar with the consulting resume format.

**Title reframing:** stay truthful to what was actually done, but emphasise the aspect most relevant to the target. "Graduate Researcher" can become "Research Software Engineer" if the work was coding-heavy. Always keep company name and dates exact.

**Summary rewrite:** rewrite the professional summary to lead with the narrative angle identified in Phase 1. Align terminology to the JD.

**Skills reorder:** lead with skills the JD mentions explicitly. Reorder within categories to match the JD's priorities.

### Phase 2.5: Experience Discovery (optional)

Offer this step when the experience inventory has gaps against JD requirements.

For each gap, conduct a branching conversation:

**Opening probe:**
- Technical gap: "Have you worked with {skill} or anything closely related?"
- Soft skill gap: "Tell me about times you've {demonstrated the capability}."
- Recent work: "What have you worked on recently that is not in the resume yet?"

**Branch based on the answer:**
- Strong yes: dig for metrics — scale, outcome, technology, production vs prototype
- Indirect or adjacent: explore transferability and how articulable it is
- Personal project or side work: assess recency and substance before including
- No: try one broader probe, then move on and note for the cover letter

**Follow-up pattern for any substantive answer:**
- "What was the scope — how many users, records, requests?"
- "Was this in production?"
- "What was the outcome or impact?"
- "Any specific challenges you had to work through?"

Capture each discovery as a draft bullet immediately and confirm accuracy with the user. Keep the truthfulness bar high — help articulate, never fabricate. Recognise when to move on after two or three attempts yield nothing.

### Phase 3: Assembly

For each bullet slot in the template:

1. Identify candidate bullets from the master and from existing tailored resumes
2. Rate confidence:
   - **Direct** — keyword, domain and outcome all align
   - **Transferable** — same capability in a different context (medium confidence)
   - **Adjacent** — related tools or problem space (lower confidence)
   - **Gap** — nothing above 60%; flag explicitly
3. For transferable matches, show the reframing transparently:
   - Original: `{bullet}`
   - Reframed: `{adjusted bullet}`
   - Change: what shifted and why it remains accurate
4. For gaps, offer options: use the reframed best available, note for cover letter, or drop the slot

**Checkpoint 2** — present coverage summary and full bullet mapping. Wait for approval before generating.

Present:
- Direct matches count
- Reframed bullets count and what changed
- Gaps remaining and recommended handling
- Rough overall JD coverage

Adjust based on feedback, then generate.

### Phase 4: Generate

**Slug:** `{company}_{role_slug}` — lowercase, underscores, no spaces. Match the naming pattern in existing tailored directories (e.g. `autodesk_senior_software_engineer`).

**Directory:** `tailored/{slug}/`

**Steps:**
1. Create the directory if it does not exist
2. Copy `resume.tex` to `tailored/{slug}/resume.tex`
3. Apply all approved changes: summary rewrite, skills reorder, bullet swaps, structural decisions
4. Preserve existing LaTeX commands exactly (`\jobtitle`, `\jobsubtitle`, `\client`, `\clientitems`, `\skill`) — content changes only, no formatting changes
5. Build PDF: `make tailored COMPANY={slug}` from the project root (runs xelatex twice and cleans aux files)
6. Create `tailored/{slug}/notes.md` with:
   - Role and company
   - JD summary (3-4 bullets)
   - Key changes from master
   - Gaps to address in cover letter if any

---

## Quality Reference

### Bullet formula

**[Action verb] + [Technical what] + [Scale or impact]**

Weak:
```
- Worked on backend services
- Helped improve system performance
- Uplifted the internal booking experience
```

Strong:
```
- Resolved a critical performance bottleneck by introducing targeted database indexing,
  reducing curriculum data retrieval from 30 seconds to under 200ms (99% reduction)
- Built and delivered the Next.js frontend for Energy Made Easy, the Australian Energy
  Regulator's national energy comparison platform serving millions of Australian consumers
- Migrated build tooling from Razzle to Vite, reducing bundle size by ~20% and
  significantly improving build times across the team
```

### Technical skills section

**What to list:** technologies you can discuss in depth in a technical interview.

**What to omit:** assumed basics (HTML, CSS for senior engineers), technologies touched once, generic categories made redundant by specifics (standalone "CI/CD" when GitHub Actions is listed), operating systems unless the role is DevOps/SRE.

**Grouping:** consolidate related services with parenthetical detail rather than flat lists:
- `AWS (Lambda, ECS, Step Functions, EventBridge, CDK, SES, S3, API Gateway)`
- Not: `AWS, Lambda, ECS, Step Functions, ...`

### Singapore market context

- Phone number is expected in the contact section
- Consulting client names carry weight — government agencies, ASX-listed companies and regulated industries (healthcare, energy, finance) signal credibility
- Many Singapore JDs list a tech stack explicitly; reorder the skills section to match when tailoring
- Seniority signals matter more than in Australia; make level-appropriate scope explicit in bullets (e.g. "with broad technical autonomy across system design, infrastructure and API development")

### ATS vs technical recruiter balance

For ATS: include exact skill keywords from the JD, use standard section headers, avoid tables.

For technical recruiters: show depth (not just that you used a technology, but what you built with it), include concrete metrics, demonstrate problem-solving through specific challenges resolved.
