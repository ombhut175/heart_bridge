import {getServerSession, Session} from "next-auth";
import { NextResponse } from "next/server";
import {authOptions} from "@/app/api/auth/[...nextauth]/options";

export async function authenticate(req: Request) {
    const session:Session | null = await getServerSession(authOptions);

    if (!session) {
        return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    return session; // Return session if authenticated
}