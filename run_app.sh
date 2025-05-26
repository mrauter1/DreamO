#!/usr/bin/env bash
#
# Launch DreamO
# – Activates the virtual-env
# – Ensures the FLUX model is available (or triggers HF login)
# – Starts app.py (foreground or background, as preferred)

set -euo pipefail

# ---------------------------------------------------------------------------
# 1. Activate the Python virtual environment
# ---------------------------------------------------------------------------
cd /workspace
source venv/bin/activate

# ---------------------------------------------------------------------------
# 2. Move to application root
# ---------------------------------------------------------------------------
cd DreamO

# ---------------------------------------------------------------------------
# 3. Verify that the FLUX model is present locally
#    If absent, ensure the user is authenticated with Hugging Face so that
#    `snapshot_download()` inside app.py can fetch it.
# ---------------------------------------------------------------------------
MODEL_DIR="models/FLUX.1-dev/transformer"

if [[ ! -d "${MODEL_DIR}" || -z "$(ls -A "${MODEL_DIR}" 2>/dev/null)" ]]; then
    echo "[info] FLUX model not found in '${MODEL_DIR}'."
    echo "[info] You must be logged in to Hugging Face to download it."

    # Check current authentication status
    if ! huggingface-cli whoami &>/dev/null; then
        echo "[prompt] Please enter your Hugging Face access token to continue."
        huggingface-cli login
    else
        echo "[info] Hugging Face credentials detected – continuing."
    fi
else
    echo "[info] FLUX model already present – skipping authentication check."
fi

# ---------------------------------------------------------------------------
# 4. Launch the application
#    Comment/uncomment whichever launch mode you prefer.
# ---------------------------------------------------------------------------

# --- Foreground (shows logs in current terminal) ---------------
# exec python app.py

# --- Background (detaches and writes logs to output.log) -------
nohup python -u app.py > output.log 2>&1 &
echo "Application started with PID: $!"
