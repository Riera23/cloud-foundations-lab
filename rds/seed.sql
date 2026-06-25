-- Lab 08 — tablas transaccionales de la app
\c course

CREATE TABLE IF NOT EXISTS app_users (
    id          SERIAL PRIMARY KEY,
    username    TEXT UNIQUE NOT NULL,
    email       TEXT UNIQUE NOT NULL,
    created_at  TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS app_sessions (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     INT  REFERENCES app_users(id) ON DELETE CASCADE,
    started_at  TIMESTAMPTZ DEFAULT now(),
    expires_at  TIMESTAMPTZ,
    ip_address  INET
);

CREATE TABLE IF NOT EXISTS app_audit_log (
    id          BIGSERIAL PRIMARY KEY,
    user_id     INT REFERENCES app_users(id),
    action      TEXT NOT NULL,
    detail      JSONB,
    logged_at   TIMESTAMPTZ DEFAULT now()
);

INSERT INTO app_users (username, email) VALUES
    ('alice', 'alice@example.com'),
    ('bob',   'bob@example.com'),
    ('carol', 'carol@example.com')
ON CONFLICT DO NOTHING;

INSERT INTO app_audit_log (user_id, action, detail) VALUES
    (1, 'login',  '{"ip": "10.0.1.5"}'),
    (1, 'upload', '{"file": "report.csv", "size_kb": 42}'),
    (2, 'login',  '{"ip": "10.0.2.8"}')
ON CONFLICT DO NOTHING;
