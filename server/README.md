# Backend (FastAPI) — Starter

This backend is included to support:
- Admin authentication (JWT)
- User accounts + device sessions
- Subscription tiers (Stripe stub)
- Support tickets (stub)

## Run (dev)
```bash
cd server
python -m venv .venv
# Windows: .\.venv\Scripts\Activate.ps1
# macOS/Linux: source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

Open:
- http://localhost:8000/docs
