import {NextRequest} from "next/server";
import {getUserDetailsFromCookies} from "@/helpers/token_management";
import UserModel from "@/model/User";

export async function getUserFromDatabase(request:NextRequest | Request){
  const userFromCookies = await getUserDetailsFromCookies(request);

  const userFromDb = await UserModel.findById(
    userFromCookies!._id
  );

  if (!userFromDb) throw new Error('No user from database');

  return userFromDb!;
}