import { dbConnect } from '@/lib/dbConnect';
import {
  responseBadRequest,
  responseInternalServerError,
  responseSuccessfulForPost,
} from '@/helpers/responseHelpers';
import UserModel from '@/model/User';
import bcrypt from 'bcryptjs';
import { sendVerificationEmail } from '@/helpers/sendVerificationEmail';
import TempUser from '@/model/TempUser';
import {
  generateFourDigitOtpToken,
  hashPassword,
  verifyCodeExpiryAfterTenMinutes,
} from '@/helpers/utils';

export async function POST(req: Request): Promise<Response> {
  await dbConnect();

  try {
    const { username, email, password } = await req.json();
    const existingVerifiedUserByUsername = await UserModel.findOne({
      username,
      isVerified: true,
    });
    if (existingVerifiedUserByUsername) {
      return responseBadRequest('Username is already taken');
    }

    const existingUserByEmail = await UserModel.findOne({ email });

    const verifyCode = generateFourDigitOtpToken();

    if (existingUserByEmail) {
      if (existingUserByEmail.isVerified) {
        return responseBadRequest('User already exists with this email');
      }
      const hashedPassword = await hashPassword(password);

      const tempUser = await TempUser.create({
        username: existingUserByEmail.username,
        email: existingUserByEmail.email,
        password: hashedPassword,
        verifyCode,
        verifyCodeExpiry: verifyCodeExpiryAfterTenMinutes(),
      });

      await existingUserByEmail.deleteOne();
      await tempUser.save();
    } else {
      const hashedPassword = await bcrypt.hash(password, 10);

      const expiryDate = new Date();
      expiryDate.setHours(expiryDate.getHours() + 1);
      const newUser = new TempUser({
        username,
        email,
        password: hashedPassword,
        verifyCode,
        verifyCodeExpiry: expiryDate,
        isVerified: false,
      });
      await newUser.save();
    }

    const emailResponse = await sendVerificationEmail({
      email,
      username,
      verifyCode,
    });

    if (!emailResponse.success) {
      return responseInternalServerError('error in sendVerificationEmail');
    }

    return responseSuccessfulForPost('User registered successfully');
  } catch (e) {
    console.error(e);
    return responseBadRequest('error at signUp');
  }
}
