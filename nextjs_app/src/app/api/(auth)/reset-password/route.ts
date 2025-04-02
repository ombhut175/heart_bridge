import { dbConnect } from '@/lib/dbConnect';
import {
  responseBadRequest,
  responseSuccessful,
  responseSuccessfulWithData,
} from '@/helpers/responseHelpers';
import UserModel from '@/model/User';
import {
  generateFourDigitOtpToken,
  hashPassword,
  verifyCodeExpiryAfterTenMinutes,
} from '@/helpers/utils';
import { sendVerificationEmail } from '@/helpers/sendVerificationEmail';
import { use } from 'react';
import { ConstantsForMainUser } from '@/helpers/string_const';

export async function PATCH(request: Request) {
  await dbConnect();
  console.log(':::from reset-password:::');
  try {
    const { email, password } = await request.json();
    const user = await UserModel.findOne({ email });
    if (!user) {
      return responseBadRequest('user not found');
    }

    const verifyCode = generateFourDigitOtpToken();

    const emailResponse = await sendVerificationEmail({
      email,
      verifyCode,
      username: user.username,
    });

    if (!emailResponse.success) {
      return responseBadRequest('error in reset password');
    }

    const newUser = await UserModel.findOneAndUpdate(
      { email },
      {
        verifyCode,
        verifyCodeExpiry: verifyCodeExpiryAfterTenMinutes(),
        password: await hashPassword(password),
        isVerified: false
      },
      { new: true, runValidators: true },
    );

    if (!newUser) {
      return responseBadRequest('error in reset password');
    }

    // Mark fields as modified
    newUser.markModified('verifyCode');
    newUser.markModified('verifyCodeExpiry');

    console.log(newUser);
    return responseSuccessfulWithData({
      message: 'Successfully sent verification code',
      body: {
        [ConstantsForMainUser.USER_NAME]: user.username,
      },
    });
  } catch (error) {
    console.error(error);
    return responseBadRequest('error in reset password');
  }
}
