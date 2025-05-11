import { Ratelimit } from "@upstash/ratelimit";
import { Redis } from "@upstash/redis";
import { NextRequest } from "next/server";
import { responseUnauthorized } from "../helpers/responseHelpers";
import {
  ApiAuthRouteConst,
  RateLimitRedisUrlConst,
  RateLimitEnvConst,
  RateLimitNameConst,
  RateLimitIdentifierConst,
  RateLimitHeaderConst,
  RateLimitCookieConst,
  RateLimitDefaultConst,
  RateLimitBodyKeyConst,
  RateLimitAuthEndpointConst,
} from "../helpers/string_const";

// Configure Redis client for rate limiting
const redis = new Redis({
  url: process.env.UPSTASH_REDIS_REST_URL
    ? (process.env.UPSTASH_REDIS_REST_URL.startsWith(RateLimitRedisUrlConst.HTTPS)
      ? process.env.UPSTASH_REDIS_REST_URL
      : `${RateLimitRedisUrlConst.HTTPS}${process.env.UPSTASH_REDIS_REST_URL}`)
    : "",
  token: process.env.UPSTASH_REDIS_REST_TOKEN || "",
});

// Exempt routes from rate limiting
const EXEMPT_ROUTES = [
  ApiAuthRouteConst.RESEND_OTP,
  ApiAuthRouteConst.IS_LOGGED_IN,
];

// Default rate limit configuration
const DEFAULT_RATE_LIMIT = {
  requests: 5,
  duration: 60, // 60 seconds (1 minute)
};

// Rate limit enforcement configuration
// Set this to true to force enable rate limiting in any environment (for testing)
export const FORCE_ENABLE_RATE_LIMIT = false;

// Set this to true to force disable rate limiting in any environment (for emergencies)
export const FORCE_DISABLE_RATE_LIMIT = false;

// Environment check function - easily modifiable for testing
export const isRateLimitingEnabled = () => {
  // Force enable/disable takes precedence
  if (FORCE_ENABLE_RATE_LIMIT) return true;
  if (FORCE_DISABLE_RATE_LIMIT) return false;
  
  // Default behavior: only enable in production
  return process.env.NODE_ENV === RateLimitEnvConst.PRODUCTION;
};

// Create a reusable rate limiter
export const createRateLimiter = (
  name: string,
  requests: number = DEFAULT_RATE_LIMIT.requests,
  duration: number = DEFAULT_RATE_LIMIT.duration
) => {
  return new Ratelimit({
    redis,
    limiter: Ratelimit.slidingWindow(requests, `${duration}${RateLimitDefaultConst.SLIDING_WINDOW_SUFFIX}`),
    analytics: true,
    prefix: name,
  });
};

// Auth rate limiter instance
const authRateLimiter = createRateLimiter(RateLimitNameConst.AUTH_RATE_LIMIT);

// Middleware function for rate limiting
export async function applyRateLimit(
  request: NextRequest,
  identifier: string = RateLimitIdentifierConst.IP
): Promise<{ success: boolean; response?: Response }> {
  // Skip rate limiting if not enabled
  if (!isRateLimitingEnabled()) {
    return { success: true };
  }

  const path = request.nextUrl.pathname;
  
  // Check if route is exempt from rate limiting
  if (Array.isArray(EXEMPT_ROUTES) && EXEMPT_ROUTES.some(route => route === path)) {
    return { success: true };
  }

  // Use IP as default identifier, but can be customized (e.g., for user ID)
  const ip = identifier === RateLimitIdentifierConst.IP
    ? request.headers.get(RateLimitHeaderConst.X_FORWARDED_FOR) || RateLimitDefaultConst.ANONYMOUS
    : identifier;

  try {
    const { success, limit, reset, remaining } = await authRateLimiter.limit(ip);
    
    
    // If rate limit is exceeded
    if (!success) {
      return {
        success: false,
        response: responseUnauthorized(
          `Rate limit exceeded. Try again in ${Math.ceil(
            (reset - Date.now()) / 1000
          )} seconds. Remaining requests: ${remaining}.`
        ),
      };
    }
    
    return { success: true };
  } catch (error) {
    console.error("Rate limiting error:", error);
    // Fail open - allow the request if Redis fails
    return { success: true };
  }
}

// Auth routes specific rate limiting middleware
export async function authRateLimit(
  request: NextRequest
): Promise<{ success: boolean; response?: Response }> {
  return applyRateLimit(request);
}

// Request identifier utility functions
const requestToIp = (request: NextRequest): string => {
  return request.headers.get(RateLimitHeaderConst.X_FORWARDED_FOR) || RateLimitDefaultConst.ANONYMOUS;
};

const requestToUsernameAndIp = (request: NextRequest): string => {
  const ip = requestToIp(request);
  const username = request.headers.get(RateLimitHeaderConst.USERNAME) || "";
  try {
    // Try to get username from request body if it exists
    const body = request.body ? JSON.parse(request.body.toString()) : {};
    return `${body[RateLimitBodyKeyConst.USERNAME] || username}:${ip}`;
  } catch (e) {
    return `${username}:${ip}`;
  }
};

const requestToSessionIdentifier = (request: NextRequest): string => {
  const ip = requestToIp(request);
  const sessionId = request.cookies.get(RateLimitCookieConst.SESSION_ID)?.value || "";
  return `${sessionId}:${ip}`;
};

const requestToEmailOrPhone = (request: NextRequest): string => {
  const ip = requestToIp(request);
  try {
    // Try to get email/phone from request body
    const body = request.body ? JSON.parse(request.body.toString()) : {};
    return `${body[RateLimitBodyKeyConst.EMAIL] || body[RateLimitBodyKeyConst.PHONE] || ""}:${ip}`;
  } catch (e) {
    return ip;
  }
};

const requestToIpAndEmail = (request: NextRequest): string => {
  const ip = requestToIp(request);
  try {
    // Try to get email from request body
    const body = request.body ? JSON.parse(request.body.toString()) : {};
    return `${body[RateLimitBodyKeyConst.EMAIL] || ""}:${ip}`;
  } catch (e) {
    return ip;
  }
};

// Custom rate limiter factory for different authentication endpoints
export function createAuthRateLimiter(endpoint: string) {
  const config = {
    [RateLimitAuthEndpointConst.SIGN_IN]: { 
      requests: 10, 
      duration: 5 * 60, // 5 minutes
      identifier: requestToUsernameAndIp 
    },
    [RateLimitAuthEndpointConst.SIGN_UP]: { 
      requests: 5, 
      duration: 60 * 60, // 1 hour
      identifier: requestToIp 
    },
    [RateLimitAuthEndpointConst.VERIFY_OTP]: { 
      requests: 10, 
      duration: 10 * 60, // 10 minutes
      identifier: requestToSessionIdentifier 
    },
    [RateLimitAuthEndpointConst.RESEND_OTP]: { 
      requests: 3, 
      duration: 10 * 60, // 10 minutes
      identifier: requestToEmailOrPhone,
      cooldown: 60 // 60 seconds minimum between requests
    },
    [RateLimitAuthEndpointConst.RESET_PASSWORD]: { 
      requests: 3, 
      duration: 30 * 60, // 30 minutes
      identifier: requestToIpAndEmail 
    },
    [RateLimitAuthEndpointConst.IS_LOGGED_IN]: { 
      requests: 30, 
      duration: 60, // 1 minute
      identifier: requestToIp 
    }
  };

  const endpointConfig = config[endpoint as keyof typeof config] || { requests: 5, duration: 60, identifier: requestToIp };
  
  return new Ratelimit({
    redis,
    limiter: Ratelimit.slidingWindow(endpointConfig.requests, `${endpointConfig.duration}${RateLimitDefaultConst.SLIDING_WINDOW_SUFFIX}`),
    analytics: true,
    prefix: `${RateLimitNameConst.AUTH}:${endpoint}`,
    ephemeralCache: new Map(),
  });
} 