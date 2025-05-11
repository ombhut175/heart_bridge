import { Ratelimit } from "@upstash/ratelimit";
import { NextRequest } from "next/server";
import { responseUnauthorized } from "../helpers/responseHelpers";
import { ApiRouteConst, RateLimitUserApiConst, RateLimitHeaderConst, RateLimitDefaultConst, RateLimitNameConst } from "../helpers/string_const";
import { redis } from "./rateLimit";

// API routes that should be excluded from rate limiting
const EXEMPT_USER_ROUTES: string[] = [
  // Add any exempt routes here if needed
];

// Configuration for different user API routes with appropriate rate limits
const USER_RATE_LIMIT_CONFIG: Record<string, { requests: number; duration: number }> = {
  // Main GET endpoints - medium security with more frequent access allowed
  [RateLimitUserApiConst.GET_USERS]: {
    requests: +RateLimitUserApiConst.MEDIUM_SECURITY_REQUESTS,
    duration: +RateLimitUserApiConst.LOW_SECURITY_DURATION,
  },
  [RateLimitUserApiConst.GET_USER_INFO]: {
    requests: +RateLimitUserApiConst.MEDIUM_SECURITY_REQUESTS,
    duration: +RateLimitUserApiConst.LOW_SECURITY_DURATION,
  },
  
  // Write operations - high security with more restricted access
  [RateLimitUserApiConst.UPDATE_PROFILE]: {
    requests: +RateLimitUserApiConst.MEDIUM_SECURITY_REQUESTS,
    duration: +RateLimitUserApiConst.MEDIUM_SECURITY_DURATION,
  },
  [RateLimitUserApiConst.CREATE_USER]: {
    requests: +RateLimitUserApiConst.MEDIUM_SECURITY_REQUESTS,
    duration: +RateLimitUserApiConst.MEDIUM_SECURITY_DURATION,
  },
  [RateLimitUserApiConst.UPDATE_USER]: {
    requests: +RateLimitUserApiConst.MEDIUM_SECURITY_REQUESTS,
    duration: +RateLimitUserApiConst.MEDIUM_SECURITY_DURATION,
  },
  [RateLimitUserApiConst.DELETE_USER]: {
    requests: +RateLimitUserApiConst.HIGH_SECURITY_REQUESTS,
    duration: +RateLimitUserApiConst.HIGH_SECURITY_DURATION,
  },
  
  // Toggle favorite - can be called more frequently
  [RateLimitUserApiConst.TOGGLE_FAVOURITE]: {
    requests: +RateLimitUserApiConst.MEDIUM_SECURITY_REQUESTS,
    duration: +RateLimitUserApiConst.LOW_SECURITY_DURATION,
  },
  
  // Session operations - special security needs
  [RateLimitUserApiConst.LOGOUT]: {
    requests: +RateLimitUserApiConst.MEDIUM_SECURITY_REQUESTS,
    duration: +RateLimitUserApiConst.LOW_SECURITY_DURATION,
  },
  
  // Resource-intensive operations
  [RateLimitUserApiConst.UPLOAD_IMAGE]: {
    requests: +RateLimitUserApiConst.HIGH_SECURITY_REQUESTS,
    duration: +RateLimitUserApiConst.MEDIUM_SECURITY_DURATION,
  },
};

// Default rate limit fallback
const DEFAULT_USER_RATE_LIMIT = {
  requests: RateLimitUserApiConst.MEDIUM_SECURITY_REQUESTS,
  duration: RateLimitUserApiConst.MEDIUM_SECURITY_DURATION
};

// Create a rate limiter for a specific user API endpoint
export function createUserRateLimiter(endpoint: string) {
  const config = USER_RATE_LIMIT_CONFIG[endpoint] || DEFAULT_USER_RATE_LIMIT;
  
  return new Ratelimit({
    redis,
    limiter: Ratelimit.slidingWindow(config.requests, `${config.duration}${RateLimitDefaultConst.SLIDING_WINDOW_SUFFIX}`),
    analytics: true,
    prefix: `user:${endpoint}`,
    ephemeralCache: new Map(),
  });
}

// Map API paths to rate limit endpoint keys
function getEndpointKey(path: string): string {
  if (path === ApiRouteConst.GET_USER_INFO) return RateLimitUserApiConst.GET_USER_INFO;
  if (path === ApiRouteConst.UPDATE_PROFILE) return RateLimitUserApiConst.UPDATE_PROFILE;
  if (path === "/api/user") return RateLimitUserApiConst.GET_USERS;
  if (path.startsWith("/api/user/toggleFavourite")) return RateLimitUserApiConst.TOGGLE_FAVOURITE;
  if (path.startsWith("/api/user/testing")) return RateLimitUserApiConst.UPLOAD_IMAGE;
  if (path.startsWith("/api/user/log-out")) return RateLimitUserApiConst.LOGOUT;
  
  // Handle dynamic routes
  if (path.match(/^\/api\/user\/[^\/]+$/)) {
    // Check HTTP method for the appropriate rate limit
    return RateLimitUserApiConst.UPDATE_USER; // Default to update, we'll differentiate by method in the middleware
  }
  
  return "default";
}

// Apply rate limiting to user API routes
export async function applyUserRateLimit(
  request: NextRequest
): Promise<{ success: boolean; response?: Response }> {
  const path = request.nextUrl.pathname;
  const method = request.method;
  
  // Check if route is exempt from rate limiting
  if (EXEMPT_USER_ROUTES.includes(path)) {
    return { success: true };
  }

  // Get specific endpoint key for this route
  let endpointKey = getEndpointKey(path);
  
  // For dynamic routes, adjust based on HTTP method
  if (path.match(/^\/api\/user\/[^\/]+$/) && endpointKey === RateLimitUserApiConst.UPDATE_USER) {
    if (method === "DELETE") endpointKey = RateLimitUserApiConst.DELETE_USER;
    else if (method === "POST") endpointKey = RateLimitUserApiConst.CREATE_USER;
  }
  
  // For the main user endpoint POST, set to CREATE_USER
  if (path === "/api/user" && method === "POST") {
    endpointKey = RateLimitUserApiConst.CREATE_USER;
  }
  
  // Get rate limiter for this endpoint
  const rateLimiter = createUserRateLimiter(endpointKey);
  
  // Use IP as identifier for rate limiting
  const ip = request.headers.get(RateLimitHeaderConst.X_FORWARDED_FOR) || RateLimitDefaultConst.ANONYMOUS;
  
  try {
    const { success, limit, reset, remaining } = await rateLimiter.limit(`${ip}:${method}`);
    
    // If rate limit is exceeded
    if (!success) {
      return {
        success: false,
        response: responseUnauthorized(
          `Rate limit exceeded for ${endpointKey}. Try again in ${Math.ceil(
            (reset - Date.now()) / 1000
          )} seconds. Remaining requests: ${remaining}.`
        ),
      };
    }
    
    return { success: true };
  } catch (error) {
    console.error("User API rate limiting error:", error);
    // Fail open - allow the request if Redis fails
    return { success: true };
  }
}

// Middleware function for user API routes
export async function userApiRateLimit(
  request: NextRequest
): Promise<{ success: boolean; response?: Response }> {
  return applyUserRateLimit(request);
} 