import { responseBadRequest, responseSuccessfulWithData } from "@/helpers/responseHelpers";
import { dbConnect } from "@/lib/dbConnect";
import {getUserFromDatabase} from "@/helpers/user_db";
import {ConstantsForMainUser} from "@/helpers/string_const";
import {use} from "react";

export async function GET(request: Request) {
    console.log("::: get user info :::");


    await dbConnect();

    try {
        const user = await getUserFromDatabase(request);

        console.log("::: user = :::");
        console.log(user);

        if (!user) {
            return responseBadRequest("User is not logged in");
        }


        return responseSuccessfulWithData({
            message: "User is logged in",
            body: {
                [ConstantsForMainUser.USER_NAME]: user.username,
                [ConstantsForMainUser.ADMIN_EMAIL]:
                user.email,
                [ConstantsForMainUser.PROFILE_PICTURE_URL] : user.profilePictureUrl,
            },
        });
    }catch (error) {
        console.error();
        return responseBadRequest("User is not logged in");
    }
}