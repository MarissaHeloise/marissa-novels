

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty). If chapter ID is provided, use it; otherwise, use the current chapter from config.json.

## Comprehensive Review Process

This command performs a comprehensive review of a chapter, checking for conflicts, consistency issues, and constitution compliance. It reads all relevant context and generates a detailed review report.

### Process Overview

1. **Intelligent Context Loading**: Read all relevant context (same as chapter-write)
2. **Chapter Analysis**: Analyze chapter content thoroughly
3. **Conflict Detection**: Check for conflicts with existing content
4. **Consistency Check**: Verify consistency across all dimensions
5. **Constitution Compliance**: Verify compliance with novel constitution
6. **Generate Review Report**: Create comprehensive review report with findings

## Review Structure

### Phase 1: Intelligent Context Loading (Automatic)

**CRITICAL: You MUST read all relevant context before reviewing.**

#### Step 1: Read Chapter & Extract References

1. **Read Chapter File**:
   - Read `./chapters/chapter-001.md` (user space, project root, same level as `.novelkit/`)
   - Extract all mentioned entities:
     - Character names
     - Location names
     - Item names
     - Plot references
     - Faction names
     - Event references
     - Time references
     - Relationship references

2. **Read Chapter Plan** (if exists):
   - Read `.novelkit/chapters/[chapter-id]/plan.md`
   - Compare actual content with plan
   - Identify deviations from plan

#### Step 2: Intelligent Information Retrieval

**Read all relevant context (same as chapter-write Phase 1):**

1. **Novel Constitution** (ALWAYS REQUIRED)
2. **Current Writer Profile** (if chapter was written)
3. **Main Plots** (mentioned or related)
4. **Subplots** (mentioned or related)
5. **Character Profiles** (all mentioned characters)
6. **Location Information** (all mentioned locations)
7. **Item Information** (all mentioned items)
8. **Faction Information** (if relevant)
9. **Relationship Network** (for character interactions)
10. **Foreshadowing Records** (related foreshadowing)
11. **Previous Chapters** (for continuity)
12. **Worldview** (if world-building involved)
13. **Timeline** (for chronological accuracy)
14. **Rules** (if relevant)

### Phase 2: Comprehensive Analysis (Automatic)

#### Analysis Dimension 1: Constitution Compliance

**Check all constitution rules:**

1. **Story Synopsis Compliance**:
   - Does content serve the core theme?
   - Does it match story type?
   - Does it align with core conflict?
   - Does it follow story direction?
   - Does it convey core values?

2. **Point of View Compliance**:
   - Correct POV type used?
   - POV character restrictions followed?
   - No forbidden information revealed?
   - POV switches properly marked?
   - POV consistency maintained?

3. **Target Audience Compliance**:
   - Content rating appropriate?
   - Language level suitable?
   - Complexity matches audience?
   - Themes appropriate?

4. **Tone & Style Compliance**:
   - Overall tone consistent?
   - Language style matches?
   - Emotional tone appropriate?
   - Style consistency maintained?

5. **Worldview Compliance**:
   - World type respected?
   - Rules system followed?
   - Taboos avoided?
   - World-building consistent?

6. **Character Constraints**:
   - Character types allowed?
   - Ability limits respected?
   - Behavior rules followed?
   - Character consistency maintained?

7. **Plot Constraints**:
   - Plot types allowed?
   - Conflict types appropriate?
   - Foreshadowing rules followed?
   - Plot structure appropriate?

8. **Time & Space Constraints**:
   - Within time span?
   - Within spatial range?
   - Time flow rules followed?
   - Spatial rules followed?

**Report**: List all violations with severity levels (Critical / Warning / Info)

#### Analysis Dimension 2: Internal Consistency

**Check consistency within the chapter:**

1. **Character Consistency**:
   - Character behavior matches their profiles?
   - Character abilities match their limits?
   - Character speech patterns consistent?
   - Character relationships accurate?
   - Character motivations logical?

2. **Location Consistency**:
   - Location descriptions match location data?
   - Geography accurate?
   - Location rules followed?
   - Location atmosphere consistent?

3. **Item Consistency**:
   - Item descriptions match item data?
   - Item abilities match item properties?
   - Item ownership accurate?
   - Item history consistent?

4. **Plot Consistency**:
   - Plot developments logical?
   - Plot connections accurate?
   - Plot timeline consistent?
   - Plot causality logical?

5. **World Consistency**:
   - World rules followed?
   - World-building consistent?
   - World history accurate?
   - World logic maintained?

**Report**: List all inconsistencies with severity levels

#### Analysis Dimension 3: Cross-Chapter Consistency

**Check consistency with other chapters:**

1. **Character State Continuity**:
   - Character states match previous chapters?
   - Character locations accurate?
   - Character relationships consistent?
   - Character development logical?

2. **Plot Continuity**:
   - Plot developments align with previous chapters?
   - Plot timeline consistent?
   - Plot threads properly continued?
   - Plot resolutions logical?

3. **World State Continuity**:
   - World state matches previous chapters?
   - World events consistent?
   - World changes logical?
   - World timeline accurate?

4. **Foreshadowing Continuity**:
   - Foreshadowing properly developed?
   - Foreshadowing reveals logical?
   - Foreshadowing timeline consistent?
   - Foreshadowing connections accurate?

5. **Relationship Continuity**:
   - Relationships match previous chapters?
   - Relationship changes logical?
   - Relationship dynamics consistent?
   - Relationship history accurate?

**Report**: List all continuity issues with severity levels

#### Analysis Dimension 4: Plan Compliance

**Check if chapter follows the plan:**

1. **Plot Compliance**:
   - Planned plot points included?
   - Planned events occurred?
   - Planned plot direction followed?
   - Planned plot connections made?

2. **Character Compliance**:
   - Planned characters appeared?
   - Planned character roles fulfilled?
   - Planned character developments occurred?
   - Planned character interactions happened?

3. **Location Compliance**:
   - Planned locations used?
   - Planned location descriptions included?
   - Planned location atmosphere achieved?

4. **Item Compliance**:
   - Planned items appeared?
   - Planned item roles fulfilled?
   - Planned item descriptions included?

5. **Foreshadowing Compliance**:
   - Planned foreshadowing included?
   - Planned foreshadowing properly executed?
   - Planned foreshadowing connections made?

**Report**: List all plan deviations with severity levels

#### Analysis Dimension 5: Writer Style Compliance

**Check if chapter follows writer style:**

1. **Language Characteristics**:
   - Vocabulary level matches writer profile?
   - Sentence structure matches writer profile?
   - Formality level matches writer profile?

2. **Writing Techniques**:
   - Dialogue style matches writer profile?
   - Description style matches writer profile?
   - Show vs Tell balance matches writer profile?

3. **Human-Like Features**:
   - Natural flow achieved?
   - Imperfections included?
   - Human quirks present?
   - Variation in structure?

4. **Anti-AI Detection**:
   - Human writing markers present?
   - AI patterns avoided?
   - Natural inconsistencies included?

**Report**: List all style deviations with severity levels

#### Analysis Dimension 6: Conflict Detection

**Check for conflicts:**

1. **Character Conflicts**:
   - Character abilities conflict?
   - Character states conflict?
   - Character relationships conflict?
   - Character motivations conflict?

2. **Plot Conflicts**:
   - Plot developments conflict?
   - Plot timelines conflict?
   - Plot resolutions conflict?
   - Plot threads conflict?

3. **World Conflicts**:
   - World rules conflict?
   - World events conflict?
   - World timeline conflict?
   - World state conflict?

4. **Location Conflicts**:
   - Location descriptions conflict?
   - Location rules conflict?
   - Location geography conflict?

5. **Item Conflicts**:
   - Item properties conflict?
   - Item ownership conflict?
   - Item history conflict?

6. **Relationship Conflicts**:
   - Relationship states conflict?
   - Relationship history conflict?
   - Relationship dynamics conflict?

**Report**: List all conflicts with severity levels and affected entities

### Phase 3: Interactive Review & Recommendations

**Present Review Results to User:**

1. **Summary Statistics**:
   - Total issues found
   - Critical issues count
   - Warning issues count
   - Info issues count
   - Overall compliance score

2. **Issue Categories**:
   - Constitution violations
   - Internal inconsistencies
   - Cross-chapter inconsistencies
   - Plan deviations
   - Style deviations
   - Conflicts

3. **Detailed Issue List**:
   For each issue:
   - Issue type
   - Severity level
   - Location in chapter (paragraph/section)
   - Description
   - Affected entities
   - Suggested fix
   - Related context

4. **Recommendations**:
   - Priority fixes (critical issues)
   - Important fixes (warning issues)
   - Optional improvements (info issues)
   - Style improvements
   - Consistency improvements

**User Options**:
- A) Review all issues
- B) Review only critical issues
- C) Review only warnings
- D) Review specific category
- E) Generate fix suggestions
- F) Export review report
- Custom: [User input]

### Phase 4: Generate Review Report

**Create comprehensive review report:**

Save to `.novelkit/chapters/[chapter-id]/review-report.md`

**Report Structure**:

```markdown
# Chapter Review Report: [Chapter ID]

**Chapter**: [Number] - [Title]  
**Reviewed**: [Date]  
**Reviewer**: AI Review System  
**Overall Score**: [Score]/100

## Executive Summary

- **Total Issues**: [Count]
- **Critical Issues**: [Count]
- **Warning Issues**: [Count]
- **Info Issues**: [Count]
- **Compliance Status**: ✅ Pass / ⚠️ Warning / ❌ Fail

## Constitution Compliance

### Status: ✅ Pass / ⚠️ Warning / ❌ Fail

**Violations Found**: [Count]

[Detailed violation list]

## Internal Consistency

### Status: ✅ Pass / ⚠️ Warning / ❌ Fail

**Issues Found**: [Count]

[Detailed issue list]

## Cross-Chapter Consistency

### Status: ✅ Pass / ⚠️ Warning / ❌ Fail

**Issues Found**: [Count]

[Detailed issue list]

## Plan Compliance

### Status: ✅ Pass / ⚠️ Warning / ❌ Fail

**Deviations Found**: [Count]

[Detailed deviation list]

## Writer Style Compliance

### Status: ✅ Pass / ⚠️ Warning / ❌ Fail

**Deviations Found**: [Count]

[Detailed deviation list]

## Conflict Detection

### Status: ✅ Pass / ⚠️ Warning / ❌ Fail

**Conflicts Found**: [Count]

[Detailed conflict list]

## Recommendations

### Priority Fixes (Critical)
1. [Fix 1]
2. [Fix 2]
...

### Important Fixes (Warning)
1. [Fix 1]
2. [Fix 2]
...

### Optional Improvements (Info)
1. [Improvement 1]
2. [Improvement 2]
...

## Detailed Issue List

[Full detailed list of all issues]

## Review Metadata

- **Review Duration**: [Time]
- **Context Files Read**: [Count]
- **Entities Analyzed**: [Count]
- **Checks Performed**: [Count]
```

## State Machine Update

After review completion:

1. **Read** `.novelkit/memory/config.json`
2. **Update** `current_chapter`:
   - `review_status`: "reviewed"
   - `review_score`: [score]
   - `review_date`: [current timestamp]
   - `review_issues_count`: [count]
3. **Update** `session.last_action`: "Reviewed chapter [chapter-id] ([title]), [issues_count] issues found"
4. **Update** `session.last_action_time`: [current timestamp]
5. **Update** `session.last_action_command`: "chapter-review"
6. **Add to** `history.recent_actions` array (keep last 20):
   ```json
   {
     "action": "reviewed_chapter",
     "chapter_id": "[chapter-id]",
     "chapter_title": "[title]",
     "review_score": [score],
     "issues_count": [count],
     "critical_issues": [count],
     "timestamp": "[ISO 8601]",
     "command": "chapter-review"
   }
   ```
7. **Update** `last_updated`: [current timestamp]
8. **Save** updated config.json

## Error Handling

- If chapter doesn't exist: Error, prompt user
- If context files missing: Warn but continue with available context
- If review fails: Report error, allow partial review
- If conflicts detected: List all conflicts, allow user to review

## Review Best Practices

1. **Always read all context** before reviewing
2. **Check all dimensions** systematically
3. **Prioritize critical issues** first
4. **Provide actionable recommendations** for each issue
5. **Link issues to related context** for better understanding
6. **Generate comprehensive report** for future reference

