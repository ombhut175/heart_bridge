import {responseBadRequest, responseSuccessful} from "@/helpers/responseHelpers";
import {CONSTANTS, ConstantsForMainUser} from "@/helpers/string_const";
import { dbConnect } from "@/lib/dbConnect";
import {getUserFromDatabase} from "@/helpers/user_db";
import { v2 as cloudinary } from 'cloudinary';
import {NextRequest, NextResponse} from "next/server";
import {join} from "path";
import {existsSync} from "fs";
import {mkdir, writeFile, unlink} from "fs/promises";
import {Readable} from "stream";
import UserModel from "@/model/User";

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
        const file = formData.get(CONSTANTS.PROFILE_PICTURE) as File;

        // Extract username from form data
        const username = formData.get(CONSTANTS.USER_NAME) as string;

        if (!username){
            return responseBadRequest("Username is required");
        }

        const existingUser = await UserModel.findOne({username});

        if (existingUser) return responseBadRequest("Username already exists");

        updatedUser.username = username;

        let tempFilePath = '';
        
        if (file) {
            // Save the file to a temporary location
            const bytes = await file.arrayBuffer();
            const buffer = Buffer.from(bytes);
            tempFilePath = join(uploadDir, file.name);

            await writeFile(tempFilePath, buffer);

            // Upload to Cloudinary
            try {
                // Create a consistent public_id for the user
                const publicId = `user_profile_${user._id.toString()}`;
                
                const result = await new Promise((resolve, reject) => {
                    // Fixed folder path for all user profile images
                    const folderPath = 'profile_images';

                    const uploadStream = cloudinary.uploader.upload_stream(
                        {
                            folder: folderPath,
                            public_id: publicId,
                            overwrite: true, // Ensure it overwrites any existing image with the same public_id
                            tags: [username, 'profile_picture'],
                            context: { user_id: user._id.toString(), username },
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
                
                // Delete the temporary file after successful upload
                try {
                    await unlink(tempFilePath);
                    console.log("::: temporary file deleted :::", tempFilePath);
                } catch (deleteError) {
                    console.error('Error deleting temporary file:', deleteError);
                    // Continue execution even if file deletion fails
                }

            } catch (error) {
                console.error('Cloudinary upload error:', error);
                
                // Try to delete the temporary file even if upload failed
                try {
                    if (tempFilePath) {
                        await unlink(tempFilePath);
                        console.log("::: temporary file deleted after upload error :::");
                    }
                } catch (deleteError) {
                    console.error('Error deleting temporary file after upload error:', deleteError);
                }
                
                return responseBadRequest("Cloudinary upload error");
            }
        }

        user.username = updatedUser.username;
        if (updatedUser.profilePictureUrl) {
            user.profilePictureUrl = updatedUser.profilePictureUrl;
        }

        await user.save();

        console.log("::: saved user :::");
        console.log(user);

        return responseSuccessful("User updated successfully");

    } catch (error) {
        console.error('Server error:', error);
        return NextResponse.json({ error: 'Server error' }, { status: 500 });
    }
}