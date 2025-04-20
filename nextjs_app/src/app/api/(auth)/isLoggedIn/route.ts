import { responseBadRequest, responseSuccessful, responseSuccessfulWithData } from "@/helpers/responseHelpers";
import { getUserDetailsFromCookies, getUserEmailFromCookies } from "@/helpers/token_management";
import { dbConnect } from "@/lib/dbConnect";
import {getUserFromDatabase} from "@/helpers/user_db";
import {ConstantsForMainUser} from "@/helpers/string_const";

export async function GET(request: Request) {
   await dbConnect();

   try {
      const user = await getUserFromDatabase(request);

      if (!user) {
         return responseBadRequest("User is not logged in");
      }


      return responseSuccessful("User is logged in");
   }catch (error) {
      console.error();
      return responseBadRequest("User is not logged in");
   }
}