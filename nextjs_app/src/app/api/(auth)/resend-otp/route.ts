import { dbConnect } from '@/lib/dbConnect';
import {
  responseBadRequest,
  responseInternalServerError,
  responseSuccessful,
} from '@/helpers/responseHelpers';
import UserModel from '@/model/User';
import TempUser from '@/model/TempUser';
import { sendVerificationEmail } from '@/helpers/sendVerificationEmail';
import { UserInterface } from '@/model/User';
import { TempUserInterface } from '@/model/TempUser';
import {
  generateFourDigitOtpToken,
  verifyCodeExpiryAfterTenMinutes,
} from '@/helpers/utils';
import { ConstantsForMainUser } from '@/helpers/string_const';

export async function POST(request: Request) {
  await dbConnect();

  try {
    const { email, verificationType } = await request.json();

    const user: UserInterface | TempUserInterface | null =
      verificationType === ConstantsForMainUser.FORGOT_PASSWORD
        ? await UserModel.findOne({ email })
        : await TempUser.findOne({ email });

    if (!user) {
      return responseBadRequest('user not found');
    }

    const verifyCode = generateFourDigitOtpToken();

    const emailResponse = await sendVerificationEmail({
      email,
      username: user.username,
      verifyCode,
    });

    if (!emailResponse.success) {
      return responseInternalServerError(
        'error in sending verification otp in email',
      );
    }

    user.verifyCode = verifyCode;
    user.verifyCodeExpiry = verifyCodeExpiryAfterTenMinutes();

    await user.save();

    return responseSuccessful('otp sent successfully');
  } catch (error) {
    console.error(error);
    return responseBadRequest('error in resend otp');
  }
}
