import {dbConnect} from "@/lib/dbConnect";
import {responseBadRequest, responseSuccessful, responseSuccessfulWithData} from "@/helpers/responseHelpers";
import UserModel from "@/model/User";
import {ConstantsForMainUser, ConstantsForMatrimonyUser} from "@/helpers/string_const";
import MatrimonyUser from "@/model/MatrimonyUser";
import {getUserDetailsFromCookies, getUserEmailFromCookies} from "@/helpers/token_management";


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


export async function GET(request: Request) {
    await dbConnect();
    console.log("::: from get matrimony users :::");
    try {

        const { searchParams } = new URL(request.url);

        // const {adminEmail} = await request.json();
        console.log(searchParams);

        const adminEmail = searchParams.get(ConstantsForMainUser.ADMIN_EMAIL);

        console.log(adminEmail);

        const users = await MatrimonyUser.find({[CREATED_BY_ADMIN_EMAIL]: adminEmail});

        if (!users) {
            return responseBadRequest("No User Found");
        }

        return responseSuccessfulWithData({
            message: "Fetched Users Successfully",
            body: users,
        })
    } catch (error) {
        console.error(error);
        return responseBadRequest("error from getUsers");
    }

}

export async function POST(request: Request) {
    await dbConnect();
    console.log("::: from user/add/POST :::");
    try {
        const requestData = await request.json();


        // const {createdByAdminEmail} = requestData;

        const createdByAdminEmail = await getUserEmailFromCookies(request);


        const user = await UserModel.findOne({email: createdByAdminEmail});

        if (!user) {
            return responseBadRequest("User not found");
        }

        console.log(requestData);
        console.log(requestData[MOBILE_NUMBER]);


        const newUserData = {
            [CREATED_BY_ADMIN_EMAIL]: createdByAdminEmail,
            [FULL_NAME]: requestData[FULL_NAME],
            [EMAIL]: requestData[EMAIL],
            mobileNumber: requestData[MOBILE_NUMBER],
            [DOB]: requestData[DOB],
            [GENDER]: requestData[GENDER],
            [CITY]: requestData[CITY],
            [HOBBIES]: requestData[HOBBIES],
            [CREATED_AT]: new Date(),
        };

        console.log(newUserData);

        const existingUser = await MatrimonyUser.findOne({[EMAIL]: newUserData[EMAIL] ,[CREATED_BY_ADMIN_EMAIL]: newUserData[CREATED_BY_ADMIN_EMAIL]});

        if (existingUser) {
            return responseBadRequest("User with this email already exists");
        }

        // Insert new user into MongoDB
        const newUser = new MatrimonyUser(newUserData);
        await newUser.save();

        console.log(newUser);

        return responseSuccessful("User added successfully!");

    } catch (error) {
        console.error(error);
        return responseBadRequest("error in user/add");
    }
}