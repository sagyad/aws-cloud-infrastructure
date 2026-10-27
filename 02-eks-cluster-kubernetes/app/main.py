# -----------------------------------------------------------------------------
# EKS Multi-AZ Demo Application
# Lightweight Flask web app that displays pod metadata to verify:
#   - Load balancing (different pod names on each refresh)
#   - Multi-AZ distribution (different IPs across availability zones)
#   - Rolling updates (version changes without downtime)
# Runs on port 5000 — deployed to EKS via Kubernetes Deployment manifest.
# -----------------------------------------------------------------------------

# Developer created this — your job starts at the Dockerfile
from flask import Flask
import os
import socket

app = Flask(__name__)

@app.route("/")
def home():
    pod_name = os.environ.get("HOSTNAME", "unknown")
    version = os.environ.get("APP_VERSION", "v1")
    return f"""
    <h1>EKS Multi-AZ Demo</h1>
    <p><b>Pod:</b> {pod_name}</p>
    <p><b>Version:</b> {version}</p>
    <p><b>IP:</b> {socket.gethostbyname(socket.gethostname())}</p>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

