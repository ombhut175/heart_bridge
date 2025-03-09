import {dbConnect} from "@/lib/dbConnect";
import {responseBadRequest, responseSuccessful, responseSuccessfulWithData} from "@/helpers/responseHelpers";
import UserModel from "@/model/User";
import {ConstantsForMatrimonyUser} from "@/helpers/string_const";
import MatrimonyUser from "@/model/MatrimonyUser";


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
    try {
        const {adminEmail} = await request.json();

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

        const {adminEmail} = requestData;

        const user = await UserModel.findOne({email: adminEmail});

        if (!user) {
            return responseBadRequest("User not found");
        }

        const newUserData = {
            [CREATED_BY_ADMIN_EMAIL]: adminEmail,
            [FULL_NAME]: requestData[FULL_NAME],
            [EMAIL]: requestData[EMAIL],
            [MOBILE_NUMBER]: requestData[MOBILE_NUMBER],
            [DOB]: requestData[DOB],
            [GENDER]: requestData[GENDER],
            [CITY]: requestData[CITY],
            [HOBBIES]: requestData[HOBBIES],
            [CREATED_AT]: new Date(), // Automatically set createdAt
        };

        const existingUser = await MatrimonyUser.findOne({[EMAIL]: newUserData[EMAIL]});

        if (existingUser) {
            return responseBadRequest("User with this email already exists");
        }

        // Insert new user into MongoDB
        const newUser = new MatrimonyUser(newUserData);
        await newUser.save();

        return responseSuccessful("User added successfully!");

    } catch (error) {
        console.error(error);
        return responseBadRequest("error in user/add");
    }
}