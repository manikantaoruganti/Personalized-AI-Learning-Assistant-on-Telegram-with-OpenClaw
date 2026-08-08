# 🦞 Personalized AI Learning Assistant

Welcome to your Personalized AI Learning Assistant! This project leverages OpenClaw to create an intelligent Telegram bot that provides tailored daily interview questions and technical tidbits based on a user's learning profile. Stay sharp, stay updated, and master your technical domains with ease.

## ✨ Features

*   **Personalized Onboarding**: Guides new users through a conversational flow to collect their technical domains, experience level, learning goals, and timezone.
*   **Daily Tech Briefs**: Automatically sends a daily brief at 9 PM in the user's local timezone, featuring:
    *   **5 Tailored Interview Questions**: Covering Concept, Coding, System Design, and Behavioral types, matched to the user's domains and experience level.
    *   **3-5 Recent Technical Tidbits**: Synthesized insights from the latest web content relevant to the user's interests.
*   **Dynamic Content Generation**: Utilizes a Large Language Model (LLM) to generate highly relevant and fresh content.
*   **Web Search Integration**: Fetches the latest information from the web to ensure tidbits and questions are current.
*   **Persistent Memory**: Stores user profiles to maintain personalization across sessions.
*   **Dockerized Deployment**: Easy setup and deployment using Docker and Docker Compose.

## 🚀 Getting Started

Follow these steps to set up and run your Personalized AI Learning Assistant.

### Prerequisites

*   **Docker & Docker Compose**: Ensure Docker Desktop (or Docker Engine and Compose) is installed on your system.
    *   [Install Docker](https://docs.docker.com/get-docker/)
*   **Telegram Bot Token**: Create a new bot via Telegram's [@BotFather](https://t.me/botfather) and obtain your API token.
*   **LLM Provider API Key**:
    *   **Google Gemini**: Obtain an API key from [Google AI Studio](https://aistudio.google.com/app/apikey).
    *   **OpenAI**: Obtain an API key from [OpenAI Platform](https://platform.openai.com/account/api-keys).
    *   **Ollama (Local)**: No API key needed, but ensure Ollama is running (see `docker-compose.yml` for an optional service).
*   **Web Search API Key**:
    *   **Tavily**: Obtain an API key from [Tavily AI](https://tavily.com/).
    *   **Serper**: Obtain an API key from [Serper API](https://serper.dev/).
    *   **SerpAPI**: Obtain an API key from [SerpAPI](https://serpapi.com/).

### Setup Steps

1.  **Clone the Repository (if not already done):**
    ```bash
    git clone https://github.com/your-username/ai-learning-assistant.git
    cd ai-learning-assistant
    ```

2.  **Configure Environment Variables:**
    Copy the example environment file and fill in your details:
    ```bash
    cp .env.example .env
    ```
    Open the newly created `.env` file and replace the placeholder values:
    ```ini
    # .env
    LLM_PROVIDER="google" # or "ollama", "openai", etc.
    MODEL_NAME="gemini-1.5-flash" # or "llama3", "gpt-4o", etc.
    TELEGRAM_BOT_TOKEN="YOUR_TELEGRAM_BOT_TOKEN"
    SEARCH_PROVIDER="tavily" # or "serper", "serpapi"
    SEARCH_API_KEY="YOUR_WEB_SEARCH_API_KEY"
    TIMEZONE="America/New_York" # IMPORTANT: Set your local IANA timezone (e.g., Europe/London, Asia/Tokyo)
    ```

3.  **Build and Run with Docker Compose:**
    ```bash
    docker-compose up --build -d
    ```
    This command will:
    *   Build the Docker image for the `openclaw-assistant` service.
    *   Start the `openclaw-assistant` container, which runs the OpenClaw Gateway.
    *   (Optionally) Start the `ollama` container if `LLM_PROVIDER` is set to `ollama` and you want to run an LLM locally.
    *   Run containers in detached mode (`-d`).

4.  **Verify Services (Optional):**
    Check the logs to ensure everything is running correctly:
    ```bash
    docker-compose logs -f openclaw-assistant
    ```
    You should see messages indicating the OpenClaw Gateway is starting and connecting to Telegram.

## 🤖 Using the Assistant

1.  **Start a Chat**: Find your bot on Telegram and send `/start`.
2.  **Onboarding**: The bot will guide you through a series of questions to set up your learning profile (domains, experience level, goals, timezone).
3.  **Daily Briefs**: Once your profile is complete, you will automatically receive a personalized tech brief every evening at 9 PM in your specified timezone.

## 📂 Project Structure

```
.
├── config/
│   └── openclaw.json         # OpenClaw Gateway configuration
├── skills/
│   ├── daily-quiz/
│   │   └── SKILL.md          # Skill definition for generating daily tech briefs
│   └── user-onboarding/
│       └── SKILL.md          # Skill definition for user profile collection
├── data/                     # Persistent memory and logs (Docker volume)
├── .env.example              # Example environment variables
├── .env                      # Your actual environment variables (ignored by Git)
├── Dockerfile                # Docker image definition for the OpenClaw assistant
├── docker-compose.yml        # Docker Compose setup for services
├── LICENSE                   # Project license
└── README.md                 # This README file
```

## ⚙️ Configuration Details

### `config/openclaw.json`

This file configures the OpenClaw Gateway, including LLM provider, plugins (Telegram, Web Search), memory provider, and automation rules.

*   **LLM**: Configures the Large Language Model provider and model name.
*   **Plugins**:
    *   `telegram`: Connects to your Telegram bot using the `TELEGRAM_BOT_TOKEN`.
    *   `web_search`: Integrates with a web search API (e.g., Tavily) using `SEARCH_PROVIDER`, `SEARCH_ENDPOINT`, and `SEARCH_API_KEY`.
*   **Memory**: Uses a `json_file` provider to store user data persistently in `/app/data/memory.json`.
*   **Skills**: Defines the available skills (`user-onboarding`, `daily-quiz`) and their paths.
*   **Automation**:
    *   `new-user-onboarding`: A `standing_order` that triggers the `user-onboarding` skill whenever a `telegram.new_user` event occurs.
    *   `nightly-tech-brief`: A `cron` job scheduled for `0 21 * * *` (9 PM daily) in the specified `TIMEZONE`. It triggers the `daily-quiz` skill and broadcasts a message to the user.

### `skills/user-onboarding/SKILL.md`

This skill defines the conversational flow for new user onboarding. It collects:
*   Technical domains
*   Experience level
*   Learning goals
*   Timezone

It uses OpenClaw's memory functions (`memory.set`) to store this profile information and provides clarification prompts for vague answers.

### `skills/daily-quiz/SKILL.md`

This skill is responsible for generating the daily tech brief. It performs the following steps:
1.  **Retrieves User Profile**: Fetches the stored user profile from memory.
2.  **Web Search**: Constructs a search query based on the user's domains and level, then uses the `web_search` plugin to find recent content.
3.  **Content Generation**: Uses the LLM to generate 5 personalized interview questions (varying types) and 3-5 technical tidbits, all based on the user's profile and the latest web search results.
4.  **Telegram Markdown Formatting**: Formats the output strictly in Telegram Markdown for a clean and readable brief.

## 🛠️ Development

### Stopping the Services

```bash
docker-compose down
```

### Rebuilding Images

If you make changes to the `Dockerfile` or `package.json`, you'll need to rebuild the image:

```bash
docker-compose up --build -d
```

### Accessing Container Shell

For debugging or inspection:

```bash
docker exec -it openclaw-ai-learning-assistant sh
```

### Persistent Data

User memory and logs are persisted in the `./data` directory on your host machine, thanks to the Docker volume mapping in `docker-compose.yml`.

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
