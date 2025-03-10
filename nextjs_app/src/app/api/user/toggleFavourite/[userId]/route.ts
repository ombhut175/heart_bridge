import {UserIdParamsInterface} from "@/helpers/interfaces";
import {responseBadRequest, responseSuccessful} from "@/helpers/responseHelpers";
import {dbConnect} from "@/lib/dbConnect";
import MatrimonyUsersModel from "@/model/MatrimonyUser";
import {convertToMongoObjectId} from "@/helpers/utils";
import {ConstantsForMatrimonyUser} from "@/helpers/string_const";

export async function PATCH(request:Request,{params}:UserIdParamsInterface){
    await dbConnect();

    try {
        const {adminEmail} = await request.json();

        if (!adminEmail) {
            return responseBadRequest("User not found");
        }

        const userId = convertToMongoObjectId(params);

        const user = await MatrimonyUsersModel.findById(userId);

        if (!user) {
            return responseBadRequest("User in list not found");
        }

        user.isFavourite = !user.isFavourite;

        await user.save();

        responseSuccessful("User toggled successfully");

    }catch (error) {
        console.error(error);
        return responseBadRequest("error in toggle Favourite");
    }
}