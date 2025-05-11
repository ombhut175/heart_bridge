# Rate Limiting Implementation

This document explains the rate limiting implementation for the Heart Bridge application.

## Overview

The application uses Upstash Redis to implement rate limiting for authentication routes. The main features are:

- Rate limit of 3 requests per minute for authentication endpoints
- Exemptions for critical routes (resend-OTP and isLoggedIn)
- Only active in production mode by default
- Easily configurable for testing purposes

## Dependencies

The following dependencies are required:

```json
{
  "@upstash/ratelimit": "^1.0.0",
  "@upstash/redis": "^1.28.4"
}
```

## Environment Variables

You need to set the following environment variables:

```
UPSTASH_REDIS_REST_URL=your_redis_url
UPSTASH_REDIS_REST_TOKEN=your_redis_token
```

## Default Configuration

- Rate limit: 3 requests per minute
- Rate limiting is only enabled in production mode (NODE_ENV === 'production')
- Exempt routes: `/api/resend-otp`, `/api/isLoggedIn`

## How to Use

### For Authentication Routes

The rate limiting for authentication routes is automatically applied via the middleware. No additional setup is required.

### For Custom Rate Limiting

You can create custom rate limiters for other parts of your application:

```typescript
import { createRateLimiter, applyRateLimit } from '../utils/rateLimit';

// Create a custom rate limiter with 5 requests per 30 seconds
const customRateLimiter = createRateLimiter('customEndpoint', 5, 30);

// Apply rate limiting in your API route
export default async function handler(req, res) {
  const { success, response } = await applyRateLimit(req);
  
  if (!success) {
    return response;
  }
  
  // Your route logic here
}
```

## Testing Rate Limiting

You can force enable or disable rate limiting by modifying the following values in `src/utils/rateLimit.ts`:

```typescript
// Set this to true to force enable rate limiting in any environment (for testing)
export const FORCE_ENABLE_RATE_LIMIT = true;

// Set this to true to force disable rate limiting in any environment (for emergencies)
export const FORCE_DISABLE_RATE_LIMIT = false;
```

## Handling Rate Limit Exceeded

When a rate limit is exceeded, the API will respond with a 401 Unauthorized status and a message indicating when the client can retry.

## Performance Considerations

- The rate limiter is designed to fail open - if Redis is unreachable, requests will be allowed through rather than blocking all traffic.
- Redis operations are asynchronous and should not significantly impact API performance.

## Security Considerations

- IP addresses are used as the default identifier for rate limiting.
- The rate limiter helps protect against brute force attacks on authentication endpoints.
- Exempt routes are carefully selected to not impact critical user flows. 