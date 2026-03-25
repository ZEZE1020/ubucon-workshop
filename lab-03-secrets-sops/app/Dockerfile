# Secure FastAPI Application
# Multi-stage build with Canonical Chiseled Ubuntu (distroless)

# ============================================
# Stage 1: Builder
# ============================================
FROM python:3.10-slim-bookworm AS builder

WORKDIR /build

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY main.py .

# ============================================
# Stage 2: Runtime (Canonical Chiseled Ubuntu)
# ============================================
# Using Canonical's chiseled (distroless) Python image
# Minimal attack surface - no shell, no package manager
FROM ubuntu/python:3.10-22.04_beta AS runtime

# Labels for container metadata
LABEL maintainer="UbuCon Workshop 2026"
LABEL description="Secure FastAPI app with Canonical Chiseled Ubuntu"
LABEL security.distroless="true"

WORKDIR /app

# Copy virtual environment from builder
COPY --from=builder /opt/venv /opt/venv

# Copy application
COPY --from=builder /build/main.py .

# Set environment
ENV PATH="/opt/venv/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

# Run the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
