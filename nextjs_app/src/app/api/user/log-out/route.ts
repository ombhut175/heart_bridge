export async function POST() {
    const response = Response.json({ message: "Logged out successfully" });

    response.headers.append(
        "Set-Cookie",
        "token=; Path=/; HttpOnly; Secure; SameSite=Strict; Expires=Thu, 01 Jan 1970 00:00:00 GMT"
    );
    return response;
}
