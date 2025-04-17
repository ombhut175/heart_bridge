import { NextRequest, NextResponse } from 'next/server';
import { getToken, getUser } from '@/helpers/token_management';
import { responseBadRequest } from '@/helpers/responseHelpers';


// const allowedOrigins = [
//     process.env.BACKEND_URL,
//     process.env.SECRET_HEADER,
// ];

export async function middleware(req: NextRequest) {
  let res = NextResponse.next();

  console.log("::: middleware :::");


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

  if (pathname.startsWith('/api/user')) {
    console.log("::: middleware before get token :::");

    let token = getToken(req);

    console.log("::: middleware after get token :::");


    console.log("token = ",token);

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

  return res; // Always return response with headers
}

// Apply middleware to all API routes
export const config = {
  matcher: '/api/:path*',
};
