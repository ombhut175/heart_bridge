import { NextRequest, NextResponse } from 'next/server';
import { getToken, getUser } from '@/helpers/token_management';
import { responseBadRequest } from '@/helpers/responseHelpers';
import { ApiRouteConst } from '@/helpers/string_const';
import { authRateLimitMiddleware } from "./middleware/authRateLimitMiddleware";
import { userRateLimitMiddleware } from "./middleware/userRateLimitMiddleware";

// const allowedOrigins = [
//     process.env.BACKEND_URL,
//     process.env.SECRET_HEADER,
// ];

export async function middleware(req: NextRequest) {
  let res = NextResponse.next();



    const origin = req.headers.get(process.env.ORIGIN!) || '';


  const isAllowedOrigin = origin === process.env.SECRET_HEADER;


  if (isAllowedOrigin) {
    res.headers.set('Access-Control-Allow-Origin', '*');
    res.headers.set(
      'Access-Control-Allow-Methods',
      'GET, POST, PUT, DELETE,PATCH,OPTIONS',
    );
    res.headers.set(
      'Access-Control-Allow-Headers',
      'Content-Type, Authorization',
    );
    res.headers.set('Access-Control-Allow-Credentials', 'true');
  }


  // Handle OPTIONS method explicitly
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      status: 204,
      headers: res.headers,
    });
  }

  const { pathname } = req.nextUrl;

  if (pathname.startsWith(ApiRouteConst.GET_USER_INFO)) {


    let token = getToken(req);


    if (!token) {
      return responseBadRequest('Unauthorized user');
    }

    try {
      await getUser(token);
      return res;
    } catch (error) {
      console.error(error);
      return responseBadRequest('No Token Found');
    }
  }

  // Apply authentication rate limiting
  const authRateLimitResponse = await authRateLimitMiddleware(req);
  
  // If the auth rate limit middleware returned a response, use it
  if (authRateLimitResponse && !(authRateLimitResponse instanceof NextResponse)) {
    return authRateLimitResponse;
  }

  // Apply user API rate limiting
  const userRateLimitResponse = await userRateLimitMiddleware(req);
  
  // If the user rate limit middleware returned a response, use it
  if (userRateLimitResponse && !(userRateLimitResponse instanceof NextResponse)) {
    return userRateLimitResponse;
  }

  return res; // Always return response with headers
}

// Apply middleware to all API routes
export const config = {
  matcher: '/api/:path*',
};
