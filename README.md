![logo](doc/sitrep_logo.png)

# sitrep

See the "situation report" of your functional groups of services in Consul... as a Service

## Example

```json
{
  "overall": "degraded",
  "groups": {
    "Full Experience": {
      "fancy-service": {
        "overall": "degraded",
        "nodes": [
          "passing", "passing", "passing", "failing"
        ]
      },
      "toast-butter-service": {
        "overall": "healthy",
        "nodes": [
          "passing", "passing", "passing", "passing"
        ]
      }
    },
    "Core Experience": {
      "dashboard-service": {
        "overall": "degraded",
        "nodes": [
          "passing", "passing", "passing", "failing"
        ]
      }
    },
    "Critical Services": {
      "authentication-service": {
        "overall": "degraded",
        "nodes": [
          "passing", "passing", "warning", "failing"
        ]
      },
      "authorization-service": {
        "overall": "healthy",
        "nodes": [
          "passing", "passing", "passing", "passing"
        ]
      },
      "user-service": {
        "overall": "healthy",
        "nodes": [
          "passing", "passing", "passing", "passing"
        ]
      }
    },
    "Uncategorized": {
      "unknown-service": {
        "overall": "degraded",
        "nodes": [
          "passing", "passing", "passing", "failing"
        ]
      }
    }
  }
}
```
