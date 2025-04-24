import { mutate } from "swr";
import { patchRequest, handleError, handleResponse } from "@/helpers/ui/handlers";
import { axiosInstance } from "@/services/fetcher";
import {format, isValid, parse} from "date-fns";
import {CONSTANTS} from "@/helpers/string_const";


// Refetch users
export const refetchUsers = () => {
    mutate("/api/user");
};

// Toggle favorite status
export const toggleFavorite = async (
    userId: number,
    setLoadingFavoriteId: (id: number | null) => void
) => {
    try {
        setLoadingFavoriteId(userId);
        await patchRequest(`/api/user/toggleFavourite/${userId}`);
        refetchUsers();
    } catch (error) {
        handleError(error);
    } finally {
        setLoadingFavoriteId(null);
    }
};

// Delete user
export const deleteUser = async (
    userId: number,
    setLoadingDeleteId: (id: number | null) => void
) => {
    try {
        setLoadingDeleteId(userId);
        const response = await axiosInstance.delete(`/api/user/${userId}`);
        handleResponse(response);
        refetchUsers();
    } catch (error) {
        handleError(error);
    } finally {
        setLoadingDeleteId(null);
    }
};


interface UserFormData {
    fullName: string;
    email: string;
    mobileNumber: string;
    dob: string;
    gender: string;
    city: string;
    hobbies: string[];
}

export const handleUserSubmit = async ({
                                           formData,
                                           isEditing,
                                           editUserTrigger,
                                           addUserTrigger,
                                           onOpenChange,
                                       }: {
    formData: UserFormData;
    isEditing: boolean;
    editUserTrigger: ({ user }: { user: UserFormData }) => Promise<any>;
    addUserTrigger: ({ user }: { user: UserFormData }) => Promise<any>;
    onOpenChange: (open: boolean) => void;
}) => {
    try {
        const formDataToSubmit = { ...formData };

        if (formDataToSubmit.dob) {
            const parsedDate = parse(formDataToSubmit.dob, "yyyy-MM-dd", new Date());
            if (isValid(parsedDate)) {
                formDataToSubmit.dob = format(parsedDate, "dd MMM yyyy");
            }
        }

        let responseBody;
        if (isEditing) {
            responseBody = await editUserTrigger({ user: formDataToSubmit });
        } else {
            responseBody = await addUserTrigger({ user: formDataToSubmit });
        }

        onOpenChange(false);
        mutate("/api/user");

        return responseBody;
    } catch (error) {
        handleError(error);
    }
};

interface HandleSaveParams {
    e: React.FormEvent;
    trigger: ({ formData }: { formData: FormData }) => Promise<any>;
    selectedImage: File | null;
    editedData: { name: string };
    fetchUserData: () => Promise<void>;
    setUploading: (val: boolean) => void;
    setIsEditing: (val: boolean) => void;
    setSelectedImage: (file: File | null) => void;
    setPreviewUrl: (url: string | null) => void;
    setUploadError: (error: string | null) => void;
}

export const handleSave = async ({
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
                                 }: HandleSaveParams) => {
    e.preventDefault();

    const formData = new FormData();

    if (selectedImage) {
        formData.append(CONSTANTS.PROFILE_PICTURE, selectedImage);
    }

    formData.append(CONSTANTS.USER_NAME, editedData.name);

    setUploading(true);
    try {
        await trigger({ formData });

        setUploading(false);
        await fetchUserData();
        setIsEditing(false);
        setSelectedImage(null);
        setPreviewUrl(null);
        console.log("Profile update successful");
    } catch (err) {
        setUploading(false);
        const msg = err instanceof Error ? err.message : "An unknown error occurred";
        setUploadError(msg);
        console.error("Update error:", err);
        handleError(err);
    }
};