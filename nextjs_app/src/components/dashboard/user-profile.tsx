"use client"

import type React from "react"

import {useState, useRef} from "react"
import {motion, AnimatePresence} from "framer-motion"
import {User, Mail, Edit, Save, X, Camera, Calendar, MapPin, Phone} from "lucide-react"
import {Button} from "@/components/ui/button"
import {Input} from "@/components/ui/input"
import {Label} from "@/components/ui/label"
import {Separator} from "@/components/ui/separator"
import {useGetStore} from "@/hooks/store";
import {handleError} from "@/helpers/ui/handlers";
import {useEditMainUser} from "@/hooks/user";
import {handleSave as handleSaveForUser } from "@/services/functions/user";


export function UserProfile() {
    const {
        userName: name,
        email,
        profilePictureUrl,
        fetchUserData
    } = useGetStore();

    const [isEditing, setIsEditing] = useState(false)
    const [editedData, setEditedData] = useState({
        name,
        email,
    });

    // Simplified image upload states
    const [uploading, setUploading] = useState(false);
    const [uploadError, setUploadError] = useState<string | null>(null);
    const fileInputRef = useRef<HTMLInputElement>(null);
    const [selectedImage, setSelectedImage] = useState<File | null>(null);
    const [previewUrl, setPreviewUrl] = useState<string | null>(null);

    const {
        trigger, isMutating, error
    } = useEditMainUser();


    const handleSave = async (e: React.FormEvent) => {
        await handleSaveForUser({
            e,
            trigger,
            selectedImage,
            editedData,
            fetchUserData,
            setUploading,
            setIsEditing,
            setSelectedImage,
            setPreviewUrl,
            setUploadError,
        })
    }

    const handleEditToggle = () => {
        // Remove console logs that might be confusing the issue

        // Toggle editing state first
        const newEditingState = !isEditing;
        setIsEditing(newEditingState);

        // Then handle the consequences of that toggle
        if (!newEditingState) { // If we're switching from editing to not editing
            // Cancel editing - reset to original values
            setEditedData({
                name,
                email,
            });
            setSelectedImage(null);
            setPreviewUrl(null);
        } else {
            // Switching to editing mode - ensure editedData is current
            setEditedData({
                name,
                email,
            });
        }
    }

    const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
        const {name, value} = e.target;
        setEditedData((prev) => ({
            ...prev,
            [name]: value,
        }));
    }

    // Simplified image selection handler
    const handleProfileImageSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0];
        if (file) {
            setSelectedImage(file);
            // Create a temporary URL for preview
            const tempUrl = URL.createObjectURL(file);
            setPreviewUrl(tempUrl);

            // Clean up previous object URL if it exists
            return () => {
                if (previewUrl) URL.revokeObjectURL(previewUrl);
            };
        }
    };

    // Add function to trigger file input click
    const triggerFileInput = () => {
        fileInputRef.current?.click();
    };

    if (error) handleError(error);

    // Determine which image URL to display
    const displayImageUrl = isEditing && previewUrl ? previewUrl : profilePictureUrl;

    return (
        <div className="max-w-4xl mx-auto">
            <div className="bg-card rounded-xl border border-border shadow-sm overflow-hidden">
                {/* Profile Header */}
                <div className="relative h-48 bg-gradient-to-r from-primary/80 to-primary/40">
                </div>

                {/* Profile Info Section */}
                <div className="px-6 sm:px-8 pb-8 -mt-16 relative">
                    {/* Avatar */}
                    <div className="flex flex-col sm:flex-row items-center sm:items-end mb-6">
                        <div className="relative">
                            {displayImageUrl ? (
                                <div className="w-32 h-32 rounded-full border-4 border-card overflow-hidden">
                                    <img
                                        src={displayImageUrl}
                                        alt={name}
                                        className="w-full h-full object-cover"
                                    />
                                </div>
                            ) : (
                                <div
                                    className="w-32 h-32 rounded-full border-4 border-card bg-blue-100 dark:bg-blue-950 flex items-center justify-center text-blue-500 dark:text-blue-300">
                                    <span className="text-4xl font-bold">{name.charAt(0)}</span>
                                </div>
                            )}

                            {/* Hidden file input */}
                            <input
                                ref={fileInputRef}
                                type="file"
                                accept="image/*"
                                onChange={handleProfileImageSelect}
                                className="hidden"
                            />

                            {isEditing && (
                                <Button
                                    variant="outline"
                                    size="icon"
                                    onClick={triggerFileInput}
                                    disabled={uploading || isMutating}
                                    className="absolute bottom-0 right-0 h-8 w-8 rounded-full bg-background shadow-md hover:bg-accent"
                                >
                                    {uploading || isMutating ? (
                                        <span
                                            className="h-4 w-4 animate-spin rounded-full border-2 border-current border-t-transparent"/>
                                    ) : (
                                        <Camera className="h-4 w-4"/>
                                    )}
                                    <span className="sr-only">Change profile photo</span>
                                </Button>
                            )}
                        </div>

                        <div
                            className="mt-4 sm:mt-0 sm:ml-6 flex flex-col sm:flex-row items-center sm:items-end sm:justify-between w-full">
                            <div className="text-center sm:text-left">
                                <h2 className="text-2xl font-bold">{name}</h2>
                                <p className="text-muted-foreground">{email}</p>
                                {uploadError && (
                                    <p className="text-sm text-red-500 mt-1">{uploadError}</p>
                                )}
                            </div>

                            <div className="mt-4 sm:mt-0">
                                {isMutating ? (
                                    <div className="flex items-center justify-center w-[120px] h-[40px]">
                                        <span className="h-6 w-6 animate-spin rounded-full border-2 border-primary border-t-transparent"/>
                                    </div>
                                ) : (
                                    <Button
                                        onClick={handleEditToggle}
                                        variant={isEditing ? "outline" : "default"}
                                        className="flex items-center gap-2"
                                    >
                                        {isEditing ? (
                                            <>
                                                <X className="h-4 w-4"/>
                                                Cancel
                                            </>
                                        ) : (
                                            <>
                                                <Edit className="h-4 w-4"/>
                                                Edit Profile
                                            </>
                                        )}
                                    </Button>
                                )}
                            </div>
                        </div>
                    </div>

                    <Separator className="my-6"/>

                    {/* Profile Content */}
                    <AnimatePresence mode="wait">
                        {isEditing ? (
                            <motion.div
                                key="edit-form"
                                initial={{opacity: 0}}
                                animate={{opacity: 1}}
                                exit={{opacity: 0}}
                                transition={{duration: 0.2}}
                                className="min-h-[200px]" // Minimum height to maintain consistency
                            >
                                <div className="space-y-4 max-w-md">
                                    <div className="space-y-2">
                                        <Label htmlFor="name">Full Name</Label>
                                        <Input 
                                            id="name" 
                                            name="name" 
                                            value={editedData.name} 
                                            onChange={handleChange}
                                            disabled={isMutating}
                                        />
                                    </div>

                                    <div className="space-y-2">
                                        <Label htmlFor="email">Email</Label>
                                        <Input
                                            id="email"
                                            name="email"
                                            type="email"
                                            value={editedData.email}
                                            readOnly
                                            className="cursor-not-allowed opacity-70"
                                        />
                                    </div>
                                </div>

                                <div className="mt-8 flex justify-end">
                                    <Button 
                                        onClick={handleSave} 
                                        className="flex items-center gap-2"
                                        disabled={isMutating}
                                    >
                                        {isMutating ? (
                                            <>
                                                <span className="h-4 w-4 animate-spin rounded-full border-2 border-current border-t-transparent"/>
                                                Saving...
                                            </>
                                        ) : (
                                            <>
                                                <Save className="h-4 w-4"/>
                                                Save Changes
                                            </>
                                        )}
                                    </Button>
                                </div>
                            </motion.div>
                        ) : (
                            <motion.div
                                key="profile-view"
                                initial={{opacity: 0}}
                                animate={{opacity: 1}}
                                exit={{opacity: 0}}
                                transition={{duration: 0.2}}
                                className="min-h-[200px]" // Minimum height to maintain consistency
                            >
                                <div className="space-y-6 max-w-md">
                                    <div>
                                        <h3 className="text-lg font-medium mb-4">Personal Information</h3>

                                        <div className="space-y-4">
                                            <div className="flex items-center gap-3">
                                                <User className="h-5 w-5 text-muted-foreground"/>
                                                <div>
                                                    <p className="text-sm text-muted-foreground">Full Name</p>
                                                    <p className="font-medium">{name}</p>
                                                </div>
                                            </div>

                                            <div className="flex items-center gap-3">
                                                <Mail className="h-5 w-5 text-muted-foreground"/>
                                                <div>
                                                    <p className="text-sm text-muted-foreground">Email</p>
                                                    <p className="font-medium">{email}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </motion.div>
                        )}
                    </AnimatePresence>
                </div>
            </div>
        </div>
    )
}
