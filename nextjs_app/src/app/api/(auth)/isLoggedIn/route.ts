import { responseBadRequest, responseSuccessful } from "@/helpers/responseHelpers";
import { dbConnect } from "@/lib/dbConnect";
import {getUserFromDatabase} from "@/helpers/user_db";

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