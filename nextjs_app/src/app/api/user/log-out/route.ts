import {NextResponse} from "next/server";
import {AUTHENTICATION} from "@/helpers/string_const";

export async function POST() {
    const response = NextResponse.json({success: true, message: "Logged out successfully"});

    response.cookies.set(AUTHENTICATION.USER_TOKEN, "", {
        httpOnly: true,
        secure: process.env.NODE_ENV === "production",
        path: "/",
        expires: new Date(0),
    });

    return response;
}
