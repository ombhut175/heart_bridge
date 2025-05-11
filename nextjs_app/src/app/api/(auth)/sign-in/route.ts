import {dbConnect} from '@/lib/dbConnect';
import {
    responseBadRequest,
    responseSuccessfulWithData,
} from '@/helpers/responseHelpers';
import UserModel from '@/model/User';
import {verifyPassword} from '@/helpers/utils';
import {AUTHENTICATION, ConstantsForMainUser} from '@/helpers/string_const';
import {
    getCookieHeader,
    getToken,
    getUserDetailsFromCookies,
    setUser,
} from '@/helpers/token_management';
import {JWTPayload} from 'jose';

export async function POST(request: Request) {
    await dbConnect();
    try {
        const {email, password} = await request.json();

        const user = await UserModel.findOne({email});

        if (!user) {
            return responseBadRequest('user not found');
        }

        if (!user.isVerified) {
            return responseBadRequest(
                'user not verified please hit forget password verify yourself',
            );
        }

        const isPasswordCorrect = await verifyPassword({
            password,
            hashedPassword: user.password,
        });

        if (!isPasswordCorrect) {
            return responseBadRequest('wrong password');
        }
        let userFromToken = getToken(request);

        console.log(userFromToken);

        if (!userFromToken || userFromToken == 'null') {
            console.log('::: user token regenerating :::');

            userFromToken = await setUser(user);

            console.log(userFromToken);
        }

        return responseSuccessfulWithData({
            message: 'User Verified successfully',
            body: {
                [ConstantsForMainUser.USER_NAME]: user.username,
                [AUTHENTICATION.USER_TOKEN]: userFromToken,
            },
            headers: await getCookieHeader({
                userToken: userFromToken,
            }),
        });
    } catch (error) {
        console.error(error);
        return responseBadRequest('error in sign in');
    }
}
