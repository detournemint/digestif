# Claude Instructions for Digestif

## Action History

After completing any meaningful action (feature added, bug fixed, file created/deleted, schema changed, config updated, etc.), append an entry to `HISTORY.md` in the project root.

### Format

```
## YYYY-MM-DD — Short title

- What was done and why
- Files created/modified/deleted
- Any notable decisions or trade-offs
```

Use today's date. Group multiple related changes under one entry. Keep entries concise but specific enough to reconstruct what happened.

Do not log trivial read-only operations (file reads, searches, status checks).

## Tests

**Any code change must be accompanied by tests.** Follow this order:

1. Write the test first (it should fail before the fix)
2. Make the change
3. Verify the test passes
4. Ensure the full suite still passes (`bin/rails test`)

Use `ActionDispatch::IntegrationTest` for controller/request tests and `ActiveSupport::TestCase` for model tests. Use fixtures and the `sign_in_as` helper from `test/test_helpers/session_test_helper.rb` for authenticated requests.
