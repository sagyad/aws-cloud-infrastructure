# -----------------------------------------------------------------------------
# Dockerfile — EKS Multi-AZ Demo Application
# Builds a lightweight Python container for deployment to Amazon EKS.
# Uses slim base image to minimise attack surface and image size (~150MB).
# Dependencies are installed before copying app code to leverage Docker
# layer caching — rebuilds are faster when only application code changes.
# -----------------------------------------------------------------------------

# Stage 1: Use official Python slim image as base platform
FROM python:3.13-slim

# Prevent Python from writing .pyc files and enable real-time log output
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED = 1 

# Set working directory inside the container
WORKDIR /app

# Copy dependency file first — Docker caches this layer separately
# so 'pip install' only re-runs when requirements.txt changes
COPY requirements.txt /app/

# Install Python dependencies with no cache to reduce image size
RUN pip install --no-cache-dir -r requirements.txt

# Expose the application port
EXPOSE 5000

# Copy the rest of the application code
COPY . /app/

# Start the Flask application
CMD ["python","main.py"]
