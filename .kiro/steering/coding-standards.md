---
description: Coding standards and conventions for the Meduseld project
---

# Coding Standards

## Error Handling

Every `catch` block must include a `console.error()` (or `logger.error()` in Python) with a descriptive message and the error object. Never silently swallow errors.

```javascript
// Bad
catch (e) {
  doFallback();
}

// Good
catch (e) {
  console.error('Description of what failed:', e);
  doFallback();
}
```

```python
# Bad
except Exception:
    pass

# Good
except Exception as e:
    logger.error("Description of what failed: %s", e)
```
