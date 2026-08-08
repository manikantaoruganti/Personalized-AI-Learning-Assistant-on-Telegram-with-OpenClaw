# Use a lightweight Node.js image as the base
FROM node:20-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (if any) to install dependencies
COPY package*.json ./

# Install OpenClaw and its dependencies globally
# Using --prefix /usr/local to ensure it's in PATH and accessible
RUN npm install -g openclaw@latest

# Copy the rest of the application code
COPY . .

# Create a directory for persistent memory and ensure correct permissions
RUN mkdir -p /app/data && chown -R node:node /app/data
USER node

# Expose the port OpenClaw Gateway runs on
EXPOSE 8080

# Command to run the OpenClaw Gateway
CMD ["openclaw", "gateway", "--config", "config/openclaw.json"]
