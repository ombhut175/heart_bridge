import { NextRequest, NextResponse } from 'next/server';
import { v2 as cloudinary } from 'cloudinary';
import { dbConnect } from "@/lib/dbConnect";
import { writeFile, mkdir } from 'fs/promises';
import { join } from 'path';
import { existsSync } from 'fs';
import { Readable } from 'stream';

// This is needed for Next.js App Router
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

        console.log("::: Username received :::", username);
        
        if (!file) {
            return NextResponse.json({ error: 'No file uploaded' }, { status: 400 });
        }

        // Save the file to a temporary location
        const bytes = await file.arrayBuffer();
        const buffer = Buffer.from(bytes);
        const tempFilePath = join(uploadDir, file.name);
        await writeFile(tempFilePath, buffer);

        // Upload to Cloudinary
        try {
            const result = await new Promise((resolve, reject) => {
                // You can use the username in the folder path if needed
                const folderPath = username 
                    ? `uploads/testing/${username}` 
                    : 'uploads/testing';
                    
                const uploadStream = cloudinary.uploader.upload_stream(
                    { 
                        folder: folderPath,
                        // You can also add username as a tag or context metadata
                        tags: username ? [username] : undefined,
                        context: username ? { username } : undefined
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
            console.log(result);
            // @ts-ignore
            console.log(result.secure_url);

            return NextResponse.json({ 
                message: 'Uploaded successfully',
                username: username || null, // Include username in the response
                result 
            });
        } catch (error) {
            console.error('Cloudinary upload error:', error);
            return NextResponse.json({ error: 'Cloudinary upload failed' }, { status: 500 });
        }
    } catch (error) {
        console.error('Server error:', error);
        return NextResponse.json({ error: 'Server error' }, { status: 500 });
    }
}
