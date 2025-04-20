import {responseBadRequest, responseSuccessful} from "@/helpers/responseHelpers";
import { ConstantsForMainUser } from "@/helpers/string_const";
import { dbConnect } from "@/lib/dbConnect";
import UserModel from "@/model/User";
import {getUserFromDatabase} from "@/helpers/user_db";
import { v2 as cloudinary } from 'cloudinary';
import {NextRequest, NextResponse} from "next/server";
import {join} from "path";
import {existsSync} from "fs";
import {mkdir, writeFile} from "fs/promises";
import {Readable} from "stream";

export const dynamic = 'force-dynamic';

cloudinary.config({
    cloud_name: process.env.CLOUDINARY_CLOUD_NAME!,
    api_key: process.env.CLOUDINARY_API_KEY!,
    api_secret: process.env.CLOUDINARY_API_SECRET!,
});

export async function POST(req: NextRequest) {
    try {
        await dbConnect();
        console.log("::: testing image uploader :::");


        const user = await getUserFromDatabase(req);

        console.log("::: user :::");

        console.log(user);

        let updatedUser = {
            username:"",
            profilePictureUrl: "",
        }

        // Create a temporary directory for file uploads if it doesn't exist
        const uploadDir = join(process.cwd(), 'tmp');
        if (!existsSync(uploadDir)) {
            await mkdir(uploadDir, { recursive: true });
        }

        // Get the form data from the request
        const formData = await req.formData();
        const file = formData.get('image') as File;

        // Extract username from form data
        const username = formData.get('username') as string;

        if (!username){
            return responseBadRequest("Username is required");
        }

        updatedUser.username = username;
        console.log("::: Username received :::", username);

        if (file) {
            // Save the file to a temporary location

            const bytes = await file.arrayBuffer();

            const buffer = Buffer.from(bytes);
            const tempFilePath = join(uploadDir, file.name);

            console.log("::: temp file path = :::");

            console.log(tempFilePath);
            await writeFile(tempFilePath, buffer);

            // Upload to Cloudinary
            try {
                const result = await new Promise((resolve, reject) => {
                    // You can use the username in the folder path if needed
                    const folderPath = username
                        ? `uploads/testing/${user._id}`
                        : 'uploads/testing';

                    const uploadStream = cloudinary.uploader.upload_stream(
                        {
                            folder: folderPath,
                            // You can also add username as a tag or context metadata
                            tags: username ? [username] : undefined,
                            context: username ? { username } : undefined,
                            public_id: user._id.toString(),
                        },
                        (error, result) => {
                            if (error) reject(error);
                            else resolve(result);
                        }
                    );

                    // Create a readable stream from the buffer and pipe it to Cloudinary
                    const readableStream = new Readable();
                    readableStream.push(buffer);
                    readableStream.push(null);
                    readableStream.pipe(uploadStream);
                });

                console.log("::: image uploaded :::");

                // @ts-ignore
                updatedUser.profilePictureUrl = result.secure_url;

            } catch (error) {
                console.error('Cloudinary upload error:', error);

                return responseBadRequest("Cloudinary upload error");
            }
        }



        user.username = updatedUser.username;
        user.profilePictureUrl = updatedUser.profilePictureUrl;

        await user.save();

        console.log("::: saved user :::");

        console.log(user);

        return responseSuccessful("User updated successfully");

    } catch (error) {
        console.error('Server error:', error);
        return NextResponse.json({ error: 'Server error' }, { status: 500 });
    }
}