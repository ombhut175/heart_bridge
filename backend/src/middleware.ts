import { NextRequest, NextResponse } from "next/server";

export function middleware(req: NextRequest) {
    const res = NextResponse.next();

    // Allow CORS for all requests
    res.headers.set("Access-Control-Allow-Origin", "*");
    res.headers.set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
    res.headers.set("Access-Control-Allow-Headers", "Content-Type, Authorization");

    // Handle OPTIONS method explicitly
    if (req.method === "OPTIONS") {
        return new Response(null, {
            status: 204,
            headers: res.headers,
        });
    }

    return res;
}

// Apply middleware to all API routes
export const config = {
    matcher: "/api/:path*",
};
