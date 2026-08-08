# Daily Quiz Skill

This skill retrieves a user's learning profile, searches the web for recent content, and generates personalized interview questions and technical tidbits.

## Workflow

1.  **Retrieve User Profile:**
    *   First, retrieve the user's learning profile from memory.
    *   `{% set user_profile = memory.get("user_profile_" + user.id) %}`
    *   `{% if not user_profile %}`
    *   `I couldn't find your learning profile. Please start by using the /start command to onboard.`
    *   `{% return %}`
    *   `{% endif %}`

2.  **Web Search for Recent Content:**
    *   Construct a search query using the user's domains and keywords like "recent", "latest", "current", "fresh".
    *   `{% set search_query = "recent " + user_profile.domains | join(' ') + " latest tech news " + user_profile.level + " insights" %}`
    *   `{% set search_results = web_search(search_query) %}`
    *   `{% if not search_results %}`
    *   `I encountered an issue fetching recent web content. Please try again later.`
    *   `{% return %}`
    *   `{% endif %}`

3.  **Generate Personalized Content:**
    *   Using the `user_profile` and `search_results`, generate 5 interview questions and 3-5 technical tidbits.
    *   The questions must match the user's `domains` and `level`, avoid repetition (by focusing on *fresh* content from search results), and vary between Concept, Coding, System Design, and Behavioral types.
    *   The technical tidbits should be synthesized insights from the `search_results`.

    ```
    You are an expert technical interviewer and content curator.
    Based on the user's profile:
    Domains: {{ user_profile.domains | join(', ') }}
    Experience Level: {{ user_profile.level }}
    Learning Goals: {{ user_profile.goals | join(', ') }}

    And the following recent web content:
    {{ search_results }}

    Generate exactly 5 interview questions and 3-5 technical tidbits.

    Interview Questions must:
    - Match the user's domains and experience level.
    - Avoid repetition (focus on fresh topics from the search results).
    - Vary in type: include Concept, Coding, System Design, and Behavioral questions.

    Technical Tidbits must:
    - Be 3-5 concise, interesting insights synthesized from the recent web content.
    - Be relevant to the user's domains.

    Format the output strictly in Telegram Markdown as follows:

    🦞 Your Daily Tech Brief
    {{ "now" | date("YYYY-MM-DD") }}
    ━━━━━━━━━━━━━━
    🧠 Interview Questions

    1. [Concept] Question 1 related to {{ user_profile.domains[0] }} for a {{ user_profile.level }} level.
    2. [Coding] Question 2 related to {{ user_profile.domains[1] }} for a {{ user_profile.level }} level.
    3. [System Design] Question 3 related to {{ user_profile.domains[0] }} for a {{ user_profile.level }} level.
    4. [Behavioral] Question 4 relevant to a {{ user_profile.level }} professional.
    5. [Concept/Coding/System Design] Question 5 related to {{ user_profile.domains[0] }} or {{ user_profile.domains[1] }} for a {{ user_profile.level }} level.

    ━━━━━━━━━━━━━━
    💡 Today's Tidbits

    - Tidbit 1: Synthesized insight from recent web content.
    - Tidbit 2: Another interesting point from the search results.
    - Tidbit 3: A third relevant technical insight.
    - (Optional) Tidbit 4: If applicable, a fourth insight.
    - (Optional) Tidbit 5: If applicable, a fifth insight.

    ━━━━━━━━━━━━━━
    Reply answers to this message to get feedback or ask for more details!
    ```
