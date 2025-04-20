'use client';

import { useState } from 'react';

export default function UploadPage() {
    const [image, setImage] = useState<File | null>(null);
    const [uploading, setUploading] = useState(false);
    const [uploadedUrl, setUploadedUrl] = useState('');
    const [error, setError] = useState<string | null>(null);

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!image) {
            setError('Please select an image to upload');
            return;
        }

        setError(null);
        const formData = new FormData();
        formData.append('image', image);
        formData.append('username', "user name is here");

        setUploading(true);
        try {
            // Use the correct API endpoint
            const res = await fetch('/api/user/testing', {
                method: 'POST',
                body: formData,
            });

            if (!res.ok) {
                throw new Error('Failed to upload image');
            }

            const data = await res.json();
            setUploading(false);

            // Handle the response from our updated API
            if (data?.result?.secure_url) {
                setUploadedUrl(data.result.secure_url);
                
                // If you're using SWR to manage user data, you can invalidate the cache
                // to refresh the data after successful upload
                // mutate('/api/user/profile');
                
                console.log('Upload successful:', data);
            } else {
                setError('Upload completed but image URL not received');
            }
        } catch (err) {
            setUploading(false);
            setError(err instanceof Error ? err.message : 'An unknown error occurred');
            console.error('Upload error:', err);
        }
    };

    return (
        <div className="p-6">
            <h1 className="text-2xl mb-4 font-bold">Upload an Image</h1>
            
            {error && (
                <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                    <p>{error}</p>
                </div>
            )}
            
            <form onSubmit={handleSubmit} className="space-y-4">
                <div>
                    <label htmlFor="image-upload" className="block text-sm font-medium text-gray-700 mb-1">
                        Select Image
                    </label>
                    <input
                        id="image-upload"
                        type="file"
                        accept="image/*"
                        onChange={(e) => setImage(e.target.files?.[0] || null)}
                        className="block w-full text-sm text-gray-500
                                  file:mr-4 file:py-2 file:px-4
                                  file:rounded file:border-0
                                  file:text-sm file:font-semibold
                                  file:bg-blue-50 file:text-blue-700
                                  hover:file:bg-blue-100"
                    />
                </div>
                
                <button
                    type="submit"
                    disabled={uploading}
                    className={`px-4 py-2 rounded font-medium ${
                        uploading 
                            ? 'bg-gray-400 cursor-not-allowed' 
                            : 'bg-blue-600 hover:bg-blue-700 text-white'
                    }`}
                >
                    {uploading ? 'Uploading...' : 'Upload Image'}
                </button>
            </form>

            {uploadedUrl && (
                <div className="mt-6">
                    <h2 className="text-xl font-medium">Uploaded Image:</h2>
                    <div className="mt-2 border rounded p-2 inline-block">
                        <img src={uploadedUrl} alt="Uploaded" className="max-w-md max-h-64 object-contain" />
                    </div>
                    <p className="mt-2 text-sm text-gray-600">
                        Image URL: <a href={uploadedUrl} target="_blank" rel="noopener noreferrer" className="text-blue-600 break-all">{uploadedUrl}</a>
                    </p>
                </div>
            )}
        </div>
    );
}
