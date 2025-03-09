import {dbConnect} from "@/lib/dbConnect";
import {responseBadRequest, responseSuccessful, responseSuccessfulWithData} from "@/helpers/responseHelpers";
import UserModel from "@/model/User";
import {verifyPassword} from "@/helpers/utils";
import {use} from "react";
import {ConstantsForMainUser} from "@/helpers/string_const";

export async function POST(request: Request){
    await dbConnect();
    console.log("::: form sign in :::");
    try {
        const {email,password} = await request.json();
        console.log(email);
        console.log(password);
        const user = await UserModel.findOne({email});
        console.log(user);
        if (!user) {
            return responseBadRequest("user not found");
        }

        if (!user.isVerified){
            return responseBadRequest("user not verified please hit forget password verify yourself");
        }

        const isPasswordCorrect = await verifyPassword({
            password,
            hashedPassword: user.password,
        })

        if (!isPasswordCorrect) {
            return responseBadRequest("wrong password");
        }

        return responseSuccessfulWithData({
            message: "User Verified succesfully",
            body: {
                [ConstantsForMainUser.USER_NAME]: user.username
            }
        });

    }catch (error) {
        console.error(error);
        return responseBadRequest("error in sign in");
    }
}