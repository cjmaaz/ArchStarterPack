# curl - Transfer Data with URLs

Download files, make API calls, and transfer data using various protocols.

---

## 📋 Quick Reference

```bash
curl https://example.com                    # GET request
curl -O https://example.com/file.txt        # Download file
curl -o myfile.txt https://example.com/file # Download with custom name
curl -I https://example.com                 # Headers only
curl -X POST https://api.example.com/data   # POST request
curl -d "param=value" https://api.com       # POST with data
curl -H "Authorization: Bearer TOKEN" url   # Custom header
curl -u user:pass https://example.com       # Basic auth
curl -L https://example.com                 # Follow redirects
curl -s https://example.com                 # Silent mode
```

---

## Common Options

| Option | Purpose | Example |
|--------|---------|---------|
| `-O` | Save with remote filename | `curl -O url` |
| `-o FILE` | Save as FILE | `curl -o file.txt url` |
| `-X METHOD` | HTTP method | `curl -X POST` |
| `-d DATA` | POST data | `curl -d "key=val"` |
| `-H HEADER` | Add header | `curl -H "Accept: json"` |
| `-u USER:PASS` | Authentication | `curl -u admin:secret` |
| `-L` | Follow redirects | `curl -L url` |
| `-I` | Headers only | `curl -I url` |
| `-s` | Silent mode | `curl -s url` |
| `-v` | Verbose | `curl -v url` |
| `-w FORMAT` | Custom output | `curl -w "%{http_code}"` |

---

## Beginner Examples

### Example 1: Basic GET Request
```bash
curl https://api.github.com

# Fetches and displays content
```

### Example 2: Download File
```bash
curl -O https://example.com/file.zip

# Saves as file.zip
```

### Example 3: Download with Custom Name
```bash
curl -o myfile.zip https://example.com/download

# Saves as myfile.zip
```

### Example 4: Get Headers Only
```bash
curl -I https://example.com

# Shows HTTP headers
```

### Example 5: Follow Redirects
```bash
curl -L https://short.url/abc

# Follows redirects to final URL
```

---

## Intermediate Examples

### Example 6: POST Request
```bash
curl -X POST https://api.example.com/users

# Sends POST request
```

### Example 7: POST with Data
```bash
curl -X POST -d "name=John&email=john@example.com" https://api.example.com/users

# Sends form data
```

### Example 8: POST JSON Data
```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"name":"John","email":"john@example.com"}' \
  https://api.example.com/users

# Sends JSON payload
```

### Example 9: Custom Headers
```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/json" \
  https://api.example.com/data

# Multiple headers
```

### Example 10: Basic Authentication
```bash
curl -u username:password https://api.example.com/secure

# HTTP Basic Auth
```

### Example 11: Save Response and Headers
```bash
curl -D headers.txt -o response.txt https://example.com

# -D saves headers
```

### Example 12: Download Multiple Files
```bash
curl -O https://example.com/file1.txt \
     -O https://example.com/file2.txt

# Downloads both files
```

---

## Advanced Examples

### Example 13: API with Token
```bash
TOKEN="your_token_here"
curl -H "Authorization: Bearer $TOKEN" \
  https://api.example.com/resource

# Token-based auth
```

### Example 14: PUT Request
```bash
curl -X PUT \
  -H "Content-Type: application/json" \
  -d '{"status":"updated"}' \
  https://api.example.com/resource/123

# Update resource
```

### Example 15: DELETE Request
```bash
curl -X DELETE https://api.example.com/resource/123

# Delete resource
```

### Example 16: Upload File
```bash
curl -F "file=@/path/to/file.txt" https://example.com/upload

# Multipart form upload
```

### Example 17: Check Response Code
```bash
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://example.com)
echo "Status: $HTTP_CODE"

# Get status code only
```

### Example 18: Measure Response Time
```bash
curl -w "Time: %{time_total}s\n" -o /dev/null -s https://example.com

# Shows total time
```

### Example 19: Download with Progress Bar
```bash
curl -# -O https://example.com/largefile.zip

# Shows progress bar
```

### Example 20: Resume Download
```bash
curl -C - -O https://example.com/largefile.zip

# Resumes interrupted download
```

---

## Salesforce Examples

### Example 21: SOQL Query
```bash
curl "https://instance.salesforce.com/services/data/v60.0/query?q=SELECT+Id,Name+FROM+Account" \
  -H "Authorization: Bearer $ACCESS_TOKEN"

# Query Salesforce data
```

### Example 22: Create Record
```bash
curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"Name":"Acme Corp"}' \
  "https://instance.salesforce.com/services/data/v60.0/sobjects/Account"

# Create Account record
```

### Example 23: Get Org Limits
```bash
curl -H "Authorization: Bearer $ACCESS_TOKEN" \
  "https://instance.salesforce.com/services/data/v60.0/limits" | jq

# Check API limits
```

---

## Practice Problems

### Beginner (1-8)
1. Fetch content from a URL
2. Download a file with original name
3. Download file with custom name
4. Get HTTP headers only
5. Follow redirects
6. Make POST request
7. Send form data
8. Download multiple files

### Intermediate (9-16)
9. POST JSON data with headers
10. Use Bearer token authentication
11. Save response and headers separately
12. Check HTTP status code
13. PUT request to update resource
14. DELETE request
15. Upload file
16. Basic authentication

### Advanced (17-24)
17. Measure API response time
18. Resume interrupted download
19. Download with progress bar
20. Complex API workflow
21. Error handling with retry
22. Parallel downloads
23. Rate-limited API calls
24. Certificate validation

---

**Next**: [tar - Archive Files](./tar.md)
