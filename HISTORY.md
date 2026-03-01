# Digestif — Action History

## 2026-03-01 — Security audit + TDD hardening

**Tests added** (52 total, all green):
- `test/models/user_test.rb` — password min length, email/username uniqueness, username format
- `test/models/post_test.rb` — body required/max length, one-post-per-day, published_at auto-set
- `test/models/follow_test.rb` — no self-follows, no duplicate follows
- `test/controllers/posts_controller_test.rb` — auth gates, IDOR protection, business rules
- `test/controllers/follows_controller_test.rb` — auth gates, follow/unfollow
- `test/controllers/profiles_controller_test.rb` — auth gates, mass-assignment protection
- `test/controllers/digests_controller_test.rb` — auth gate
- `test/integration/security_test.rb` — open redirect, CSP header, session invalidation, user enumeration

**Fixes applied:**
- `User` model — added `validates :password, length: { minimum: 12 }, allow_nil: true`
- `Authentication` concern — fixed open redirect: `request.url` → `request.fullpath` (stored return path is now path-only, can never redirect to an external host)
- `ApplicationController` — added `rescue_from ActiveRecord::RecordNotFound` → renders 404 (prevents error detail leakage and enables clean IDOR testing)
- `content_security_policy.rb` — enabled CSP: `default-src 'self'`, Google Fonts allowed for fonts/styles, nonces wired for importmap inline scripts
- `production.rb` — enabled `force_ssl`, `assume_ssl`, and health-check SSL exclusion
- `test/fixtures/follows.yml` — removed non-existent `follower_type`/`followed_type` columns, fixed self-follow fixtures
- `test/fixtures/users.yml` — added missing `username` field
- `CLAUDE.md` — added requirement to write tests before any code change

## 2026-03-01 — Filled out README

- Rewrote `README.md` with project description, stack overview, setup instructions, test commands, and deployment notes

## 2026-03-01 — Initial GitHub setup

- Added remote `origin` pointing to `git@github.com:detournemint/digestif.git`
- Created initial commit with all 155 project files
- Pushed `main` branch to GitHub
- Changed GitHub default branch from `master` to `main`
- Deleted old `master` branch (contained unrelated Rails 5/6-era codebase)
- Created `CLAUDE.md` with instructions to maintain this history file
