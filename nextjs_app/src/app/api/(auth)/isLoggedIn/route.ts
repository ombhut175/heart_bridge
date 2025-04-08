import { responseBadRequest, responseSuccessful, responseSuccessfulWithData } from "@/helpers/responseHelpers";
import { getUserDetailsFromCookies, getUserEmailFromCookies } from "@/helpers/token_management";
import { dbConnect } from "@/lib/dbConnect";

export async function GET(request: Request) {
   await dbConnect();

   try {
      const user = await getUserDetailsFromCookies(request);

      if (!user) {
         return responseBadRequest("User is not logged in");
      }


      return responseSuccessfulWithData({
         message: "User is logged in",
         body: user,
      });
   }catch (error) {
      console.error();
      return responseBadRequest("User is not logged in");
   }
}