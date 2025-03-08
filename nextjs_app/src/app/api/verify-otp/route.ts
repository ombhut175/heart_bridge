import {TempUserInterface} from "@/model/TempUser";
import {UserInterface} from "@/model/User";
import {dbConnect} from "@/lib/dbConnect";
import {responseBadRequest, responseSuccessful} from "@/helpers/responseHelpers";
import TempUser from "@/model/TempUser";
import UserModel from "@/model/User";
import {FORGOT_PASSWORD, SIGN_UP} from "@/helpers/string_const";


export async function POST(request: Request): Promise<Response> {
    await dbConnect();
    try {
        console.log("::: from verify_otp :::");
        const {email, otp, verificationType} = await request.json();
        console.log(`email = ${email}`);
        console.log(`verification type = ${verificationType}`);
        const user: UserInterface | TempUserInterface | null =
            verificationType === SIGN_UP
                ? await TempUser.findOne({ email })
                : await UserModel.findOne({ email });



        if (!user) {
            return responseBadRequest("No User Found Please Sign In Again");
        }
        console.log(user);
        console.log(`otp from model = ${user.verifyCode}`);
        console.log(`otp expiry model = ${user.verifyCodeExpiry}`);
        if (user.verifyCodeExpiry.getTime() < Date.now()) {
            await user.deleteOne(
                {
                    email,
                }
            );

            return responseBadRequest("Otp Has Expired Please sign in again");
        }

        if (user.verifyCode !== otp) {
            return responseBadRequest("Incorrect Otp");
        }

        if (verificationType === SIGN_UP) {
            const newUser = await UserModel.create({
                email,
                username: user.username,
                password: user.password,
                isVerified: true,
                // verifyCode: user.verifyCode,
                // verifyCodeExpiry: user.verifyCodeExpiry
            });

            await user.deleteOne({email});
            await newUser.save();
        }else if (verificationType === FORGOT_PASSWORD) {
            if ("isVerified" in user) {
                user.isVerified = true;
            }
                await user.save();
        }else{
            return responseBadRequest("Invalid verification type");
        }

        return responseSuccessful("User verified successfully");
    } catch (error) {
        console.error(error);
        return responseBadRequest(
            "Error in verifying OTP",
        )
    }

}