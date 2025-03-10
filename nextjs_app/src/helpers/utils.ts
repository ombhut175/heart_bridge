import bcrypt from "bcryptjs";
import {getServerSession, Session} from "next-auth";
import {NextResponse} from "next/server";
import {authOptions} from "@/app/api/(auth)/auth/[...nextauth]/options";
import {UserIdParamsInterface} from "@/helpers/interfaces";
import mongoose from "mongoose";

export function generateFourDigitOtpToken(): string {
    return Math.floor(1000 + Math.random() * 9000).toString();
}

export function verifyCodeExpiryAfterTenMinutes(): Date {
    return new Date(Date.now() + 10 * 60 * 1000);
}


export async function hashPassword(password: string) {
    return await bcrypt.hash(password, 10);
}

interface VerifyPassWord{
    password: string;
    hashedPassword: string;
}

export async function verifyPassword({password, hashedPassword}:VerifyPassWord): Promise<boolean> {
    return await bcrypt.compare(
        password, hashedPassword
    );
}

export async function giveUserIdFromSession(): Promise<string | null> {
    console.log("::: from giveUserIdFromSession :::");
    try {
        const session: Session | null = await getServerSession(authOptions);

        console.log(session);
        console.log(session?.user);
        if (!session) {
            return null;
        }

        return session.user?._id;
    } catch (error) {
        return null;
    }

}

export function convertToMongoObjectId(params:{userId:string}) {
    return new mongoose.Types.ObjectId(params.userId);
}