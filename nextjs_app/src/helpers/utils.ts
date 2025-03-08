import bcrypt from "bcryptjs";

export function generateFourDigitOtpToken(): string {
    return Math.floor(1000 + Math.random() * 9000).toString();
}

export function verifyCodeExpiryAfterTenMinutes(): Date {
    return new Date(Date.now() + 10 * 60 * 1000);
}


export async function hashPassword(password: string) {
    return await bcrypt.hash(password, 10);
}

