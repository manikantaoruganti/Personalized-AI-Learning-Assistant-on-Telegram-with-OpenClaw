# User Onboarding Skill

This skill guides new users through an onboarding process to collect their learning preferences and set up their personalized profile.

## Workflow

1.  **Greet User & Explain Purpose:**
    *   Start by warmly greeting the user and explaining what the AI Learning Assistant does.
    *   "Hello there! I'm your Personalized AI Learning Assistant. My purpose is to help you stay updated and sharp in your technical domains by providing daily personalized interview questions and technical tidbits."

2.  **Collect User Profile Information (One Question at a Time):**
    *   **Domains:** "To get started, what are the primary technical domains or technologies you're interested in? (e.g., 'Frontend Development', 'Cloud Computing with AWS', 'Machine Learning', 'DevOps', 'Cybersecurity')"
    *   **Experience Level:** "Great! Now, what's your current experience level in these domains? (e.g., 'Beginner', 'Intermediate', 'Advanced', 'Expert')"
    *   **Learning Goals:** "Understood. What are your main learning goals or objectives? Are you preparing for interviews, looking to deepen your knowledge, or exploring new areas? (e.g., 'Prepare for Senior Software Engineer interviews', 'Master Kubernetes', 'Learn Rust programming')"
    *   **Timezone:** "Finally, to ensure you receive your daily tech brief at the right time, please tell me your timezone. (e.g., 'America/New_York', 'Europe/London', 'Asia/Tokyo')"

3.  **Clarification for Vague Answers:**
    *   If any answer seems vague or ambiguous, ask for clarification.
    *   Example for domains: "Could you please be more specific about 'Frontend Development'? Are you focusing on React, Vue, Angular, or a broader scope?"
    *   Example for goals: "When you say 'deepen knowledge', are there specific topics or areas within your domains you'd like to focus on?"

4.  **Store Memory:**
    *   Once all information is collected and clarified, store it in the user's persistent memory.
    *   `memory.set("user_profile_{{user.id}}", { "domains": [...], "level": "...", "goals": [...], "timezone": "..." })`

5.  **Confirm Profile & Explain Daily Schedule:**
    *   "Thank you! I've successfully created your learning profile. Here's a summary:"
    *   "**Domains:** {{memory.get('user_profile_{{user.id}}').domains | join(', ')}}"
    *   "**Level:** {{memory.get('user_profile_{{user.id}}').level}}"
    *   "**Goals:** {{memory.get('user_profile_{{user.id}}').goals | join(', ')}}"
    *   "**Timezone:** {{memory.get('user_profile_{{user.id}}').timezone}}"
    *   "Every evening at 9 PM in your timezone ({{memory.get('user_profile_{{user.id}}').timezone}}), I will send you a personalized tech brief. This brief will include 5 interview questions tailored to your domains and level, along with 3-5 interesting technical tidbits from recent web searches."

6.  **End Politely:**
    *   "I'm excited to be your learning companion! Feel free to reach out if you have any questions or want to update your profile. Happy learning!"
