import { dbConnect } from '@/lib/dbConnect';
import {
  responseBadRequest,
  responseSuccessful,
} from '@/helpers/responseHelpers';
import { ConstantsForMatrimonyUser } from '@/helpers/string_const';
import MatrimonyUsersModel from '@/model/MatrimonyUser';
import { convertToMongoObjectId } from '@/helpers/utils';
import { getUserEmailFromCookies } from '@/helpers/token_management';

const {
  FULL_NAME,
  EMAIL,
  MOBILE_NUMBER,
  DOB,
  GENDER,
  CITY,
  HOBBIES,
  CREATED_BY_ADMIN_EMAIL,
} = ConstantsForMatrimonyUser;

export async function DELETE(
  request: Request,
  context: { params: Promise<{ userId: string }> },
) {
  await dbConnect();

  try {
    const createdByAdminEmail = await getUserEmailFromCookies(request);

    if (!createdByAdminEmail) {
      return responseBadRequest('User not found');
    }

    // Await params to resolve the Promise
    const { userId } = await context.params;
    const mongoUserId = convertToMongoObjectId(userId);

    const deletedUser =
      await MatrimonyUsersModel.findByIdAndDelete(mongoUserId);

    if (!deletedUser) {
      return responseBadRequest('User not found');
    }

    return responseSuccessful('User deleted');
  } catch (error) {
    console.error(error);
    return responseBadRequest('Error deleting the request');
  }
}

export async function PUT(
  request: Request,
  context: { params: Promise<{ userId: string }> },
) {
  await dbConnect();
  console.log('::: from PUT request');

  try {
    const requestData = await request.json();
    // const { createdByAdminEmail } = requestData;

    const createdByAdminEmail = await getUserEmailFromCookies(request);

    if (!createdByAdminEmail) {
      return responseBadRequest('No admin email found');
    }

    // Await params to resolve the Promise
    const { userId } = await context.params;
    const mongoUserId = convertToMongoObjectId(userId);

    const newUserData = {
      [CREATED_BY_ADMIN_EMAIL]: createdByAdminEmail,
      [FULL_NAME]: requestData[FULL_NAME],
      [EMAIL]: requestData[EMAIL],
      [MOBILE_NUMBER]: requestData[MOBILE_NUMBER],
      [DOB]: requestData[DOB],
      [GENDER]: requestData[GENDER],
      [CITY]: requestData[CITY],
      [HOBBIES]: requestData[HOBBIES],
    };

    const updatedUser = await MatrimonyUsersModel.findByIdAndUpdate(
      mongoUserId,
      newUserData,
      { new: true },
    );

    if (!updatedUser) {
      return responseBadRequest('User not found');
    }

    return responseSuccessful('User updated successfully');
  } catch (error) {
    console.error(error);
    return responseBadRequest('Error in editing user');
  }
}
