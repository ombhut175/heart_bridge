import { NextRequest, NextResponse } from "next/server";
import { userApiRateLimit } from "../lib/userRateLimit";
import { ApiRouteConst } from "../helpers/string_const";

// List of user API routes to apply rate limiting
const USER_API_ROUTES = [
  ApiRouteConst.GET_USER, // Main user route
  ApiRouteConst.UPDATE_PROFILE,
  ApiRouteConst.GET_USER_INFO,
  // Handle other paths with regex checks in the middleware
];

/**
 * User API rate limiting middleware
 * Applies tailored rate limits based on the specific endpoint and operation
 * Rate limits are defined in the userRateLimit module
 */
export async function userRateLimitMiddleware(
  request: NextRequest
): Promise<NextResponse | Response | undefined> {
  const path = request.nextUrl.pathname;
  
  // Apply rate limiting to user API routes
  if (path.startsWith(ApiRouteConst.GET_USER) || 
      USER_API_ROUTES.some(route => path === route) || 
      path.match(/^\/api\/user\/[^\/]+$/)) {
    
    console.log("::: user api rate limit middleware :::", path);
    
    const { success, response } = await userApiRateLimit(request);

    // If rate limit is exceeded, return the error response
    if (!success && response) {
      return response;
    }
  }

  // Allow the request to proceed
  return NextResponse.next();
} 