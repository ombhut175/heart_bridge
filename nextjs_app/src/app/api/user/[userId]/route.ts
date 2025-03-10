import {dbConnect} from "@/lib/dbConnect";
import {responseBadRequest, responseSuccessful} from "@/helpers/responseHelpers";
import {ConstantsForMatrimonyUser, ID} from "@/helpers/string_const";
import mongoose from "mongoose";
import MatrimonyUsersModel from "@/model/MatrimonyUser";
import {UserIdParamsInterface} from "@/helpers/interfaces";
import {convertToMongoObjectId} from "@/helpers/utils";

const {
    FULL_NAME,
    EMAIL,
    MOBILE_NUMBER,
    DOB,
    GENDER,
    CITY,
    HOBBIES,
    CREATED_AT,
    CREATED_BY_ADMIN_EMAIL
} = ConstantsForMatrimonyUser;



export async function DELETE(request: Request, { params }: UserIdParamsInterface) {
    await dbConnect();

    try {
        const {adminEmail} = await request.json();

        if (!adminEmail) {
            return responseBadRequest("User not found");
        }


        const mongoUserId =  convertToMongoObjectId(params);

        const deletedUser = await MatrimonyUsersModel.findByIdAndDelete(mongoUserId);

        if (!deletedUser) {
            return responseBadRequest("User not found");
        }

        return responseSuccessful("User deleted");

    }catch (error) {
        console.error(error);
        return responseBadRequest("Error deleting the request");
    }
}


export async function PATCH(request:Request,{params}:UserIdParamsInterface) {
    await dbConnect();

    try {
        const requestData = await request.json();

        const {adminEmail} = requestData;


        if (!adminEmail) {
            return responseBadRequest("No admin email found");
        }


        const mongoUserId =  convertToMongoObjectId(params);

        const newUserData = {
            [CREATED_BY_ADMIN_EMAIL]: adminEmail,
            [FULL_NAME]: requestData[FULL_NAME],
            [EMAIL]: requestData[EMAIL],
            [MOBILE_NUMBER]: requestData[MOBILE_NUMBER],
            [DOB]: requestData[DOB],
            [GENDER]: requestData[GENDER],
            [CITY]: requestData[CITY],
            [HOBBIES]: requestData[HOBBIES],
        };

        const updatedUser = await MatrimonyUsersModel.findByIdAndUpdate(mongoUserId,newUserData,{new: true});

        if (!updatedUser) {
            return responseBadRequest("User not found");
        }

        return responseSuccessful("User updated successfully");
    }catch(error){
        console.error(error);
        return responseBadRequest("error in editing user");
    }
}