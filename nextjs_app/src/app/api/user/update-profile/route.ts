import {responseBadRequest, responseSuccessful} from "@/helpers/responseHelpers";
import { ConstantsForMainUser } from "@/helpers/string_const";
import { dbConnect } from "@/lib/dbConnect";
import UserModel from "@/model/User";
import {getUserFromDatabase} from "@/helpers/user_db";

export async function PATCH(request:Request){
    await dbConnect();

    console.log("::: update profile :::");

    try{
        const body = await request.json();

        const user = await getUserFromDatabase(request);

        const newUserName = body[ConstantsForMainUser.USER_NAME];

        console.log("new user name = ",newUserName);
        if (!newUserName) throw new Error("No User Name Provided");

        const isExistingUser = await UserModel.findOne({username: newUserName});

        if (isExistingUser){
            return responseBadRequest("User with this userName already exists");
        }

        const newUser = await UserModel.findByIdAndUpdate(
            user._id,
            {username : newUserName},
            {new : true}
        );

        if (!newUser) {
            throw new Error("Error in updating user");
        }

        return responseSuccessful("Profile updated successfully");
    }catch(e){
        console.error(e);
        return responseBadRequest("Error in upating profile");
    }

}