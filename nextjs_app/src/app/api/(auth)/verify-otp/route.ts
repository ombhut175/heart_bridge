import { TempUserInterface } from '@/model/TempUser';
import { UserInterface } from '@/model/User';
import { dbConnect } from '@/lib/dbConnect';
import {
  responseBadRequest,
  responseSuccessful,
  responseSuccessfulForPost,
  responseSuccessfulForPostWithData,
  responseSuccessfulWithData,
} from '@/helpers/responseHelpers';
import TempUser from '@/model/TempUser';
import UserModel from '@/model/User';
import { AUTHENTICATION, ConstantsForMainUser } from '@/helpers/string_const';
import {getCookieHeader, getToken, setUser} from '@/helpers/token_management';

export async function POST(request: Request): Promise<Response> {
  await dbConnect();
  try {
    console.log('::: from verify_otp :::');
    const { email, otp, verificationType } = await request.json();
    const user: UserInterface | TempUserInterface | null =
      verificationType === ConstantsForMainUser.SIGN_UP
        ? await TempUser.findOne({ email })
        : await UserModel.findOne({ email });

    if (!user) {
      return responseBadRequest('No User Found Please Sign In Again');
    }
    if (user.verifyCodeExpiry.getTime() < Date.now()) {
      await user.deleteOne({
        email,
      });

      return responseBadRequest('Otp Has Expired Please sign in again');
    }

    if (user.verifyCode !== otp) {
      return responseBadRequest('Incorrect Otp');
    }

    if (verificationType === ConstantsForMainUser.SIGN_UP) {
      const newUser = await UserModel.create({
        email,
        username: user.username,
        password: user.password,
        isVerified: true,
        // verifyCode: user.verifyCode,
        // verifyCodeExpiry: user.verifyCodeExpiry
      });

      await user.deleteOne({ email });
      await newUser.save();
    } else if (verificationType === ConstantsForMainUser.FORGOT_PASSWORD) {
      if ('isVerified' in user) {
        user.isVerified = true;
      }
      await user.save();
    } else {
      return responseBadRequest('Invalid verification type');
    }

     const userFromToken = await setUser(user as UserInterface);

    return responseSuccessfulWithData({
      message: 'User Verified successfully',
      body: {
        [AUTHENTICATION.USER_TOKEN]: userFromToken,
      },
      headers: await getCookieHeader({
        userToken: userFromToken,
      })
    });
    
  } catch (error) {
    console.error(error);
    return responseBadRequest('Error in verifying OTP');
  }
}
