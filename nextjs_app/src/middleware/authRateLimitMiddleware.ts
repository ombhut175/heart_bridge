import { NextRequest, NextResponse } from "next/server";
import { authRateLimit } from "../utils/rateLimit";
import { ApiAuthRouteConst } from "../helpers/string_const";

// List of auth routes that should be rate limited
const AUTH_ROUTES = [
  ApiAuthRouteConst.LOGIN,
  ApiAuthRouteConst.SIGN_UP,
  ApiAuthRouteConst.RESET_PASSWORD,
  ApiAuthRouteConst.VERIFY_OTP,
  // Note: ApiAuthRouteConst.RESEND_OTP and ApiAuthRouteConst.IS_LOGGED_IN are exempted
];

/**
 * Authentication rate limiting middleware
 * Limits authentication routes to 3 requests per minute
 * Exempts critical paths like resend-OTP and isLoggedIn
 * Only active in production mode by default
 */
export async function authRateLimitMiddleware(
  request: NextRequest
): Promise<NextResponse | Response | undefined> {
  const path = request.nextUrl.pathname;

  console.log("::: auth rate limit middleware :::");
  console.log(AUTH_ROUTES.some(route => path === route));

  // Only apply rate limiting to auth routes
  if (AUTH_ROUTES.some(route => path === route)) {
    const { success, response } = await authRateLimit(request);

    // If rate limit is exceeded, return the error response
    if (!success && response) {
      return response;
    }
  }

  // Allow the request to proceed
  return NextResponse.next();
} 