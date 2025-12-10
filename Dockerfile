# Stage 1: Clone the private GitHub repository
FROM alpine/git:latest AS git-clone
ARG GITHUB_TOKEN
WORKDIR /build
# Clone the private repository (GITHUB_TOKEN is required for private repos)
# Pass GITHUB_TOKEN as build arg: docker build --build-arg GITHUB_TOKEN=your_token .
RUN if [ -z "$GITHUB_TOKEN" ]; then \
        echo "ERROR: GITHUB_TOKEN is required for private repository tutnyal/langflow-ainime-private"; \
        exit 1; \
    fi && \
    git clone https://${GITHUB_TOKEN}@github.com/tutnyal/langflow-ainime-private.git .

# Stage 2: Build from the cloned repository
# Using a Python base image since langflow is Python-based
FROM python:3.11-slim

WORKDIR /app

# Copy the cloned repository contents
COPY --from=git-clone /build /app

# Install system dependencies if needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies from the repo
# The repo should have requirements.txt or setup.py
RUN if [ -f requirements.txt ]; then \
        pip install --no-cache-dir -r requirements.txt; \
    elif [ -f setup.py ]; then \
        pip install --no-cache-dir -e .; \
    else \
        pip install --no-cache-dir langflow; \
    fi

EXPOSE 7860

CMD ["langflow", "run", "--host", "0.0.0.0", "--port", "7860"]

