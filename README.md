# Digestif

A slow-paced social platform built around a single constraint: **one post per day, no more.**

Digestif is an antidote to the endless scroll. Instead of a live feed, you get a daily digest — yesterday's posts from the people you follow, delivered once. The newspaper/magazine aesthetic is intentional: read it, think about it, move on.

## What it does

- **One post per day** — enforced at the model level. Write it, edit it same-day, that's it.
- **Daily digest** — the home feed shows yesterday's posts from followed users, not a real-time stream.
- **User profiles** — display name, bio, location, interests, and a history of past posts.
- **Follow system** — follow/unfollow other users to shape your digest.
- **Auth** — session-based with signed cookies. Password reset via email.

## Stack

- **Ruby** 3.4.8 / **Rails** 8.1.2
- **SQLite3** — single-file database, no external DB server needed
- **Tailwind CSS** — custom newspaper theme (Playfair Display + Lora fonts, cream/parchment/ink palette)
- **Propshaft** + **Importmap** — no Node.js build step
- **Turbo** + **Stimulus** — Hotwire for interactivity
- **Solid Cache / Queue / Cable** — all database-backed, no Redis needed
- **Kamal** — Docker-based deployment

## Getting started

```bash
# Install dependencies
bundle install

# Set up the database
bin/rails db:setup

# Start the dev server
bin/dev
```

The app runs at `http://localhost:3000`.

## Running tests

```bash
bin/rails test
```

Security checks:

```bash
bin/brakeman        # static analysis
bin/bundler-audit   # dependency vulnerabilities
bin/rubocop         # style
```

Or run all at once:

```bash
bin/ci
```

## Deployment

Deployed via [Kamal](https://kamal-deploy.org). See `config/deploy.yml` for server configuration.

```bash
bin/kamal deploy
```
