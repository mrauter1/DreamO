#!/usr/bin/env bash
# Activate the Python virtual environment
cd /workspace
source venv/bin/activate

# Change to the application directory
cd DreamO

# Run the application in the foreground
#exec python app.py

# Alternative: to run in background and redirect logs
nohup python app.py > /workspace/output.log 2>&1 &
