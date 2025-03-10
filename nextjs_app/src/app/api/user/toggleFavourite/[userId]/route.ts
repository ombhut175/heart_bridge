import { responseBadRequest, responseSuccessful } from "@/helpers/responseHelpers";
import { dbConnect } from "@/lib/dbConnect";
import MatrimonyUsersModel from "@/model/MatrimonyUser";
import { convertToMongoObjectId } from "@/helpers/utils";

export async function PATCH(
    request: Request,
    context: { params: Promise<{ userId: string }> }
) {
    await dbConnect();
    console.log("::: from toggle favourite");

    try {
        const { createdByAdminEmail } = await request.json();
        console.log(createdByAdminEmail);

        if (!createdByAdminEmail) {
            return responseBadRequest("User not found");
        }

        // Await the params to resolve the promise
        const { userId } = await context.params;
        const objectId = convertToMongoObjectId(userId);

        const user = await MatrimonyUsersModel.findById(objectId);

        if (!user) {
            return responseBadRequest("User in list not found");
        }

        user.isFavourite = user.isFavourite === 0 ? 1 : 0;
        await user.save();

        return responseSuccessful("User toggled successfully");
    } catch (error) {
        console.error(error);
        return responseBadRequest("Error in toggling favourite");
    }
}
