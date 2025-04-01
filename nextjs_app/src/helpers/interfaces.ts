import {ConstantsForMainUser} from "@/helpers/string_const";

const {
  SIGN_UP,
    VERIFICATION_TYPE,
    ADMIN_EMAIL,
    FORGOT_PASSWORD,
    PASSWORD,
    LOGIN,
    USER_NAME
} = ConstantsForMainUser;

export interface UserIdParamsInterface {
  params: {
    userId: string;
  };
}


export interface otpDataInterface{
  [VERIFICATION_TYPE] : string;
  [ADMIN_EMAIL]: string,
  [USER_NAME]: string,
}