export enum ConstantsForMainUser {
    SIGN_UP = 'signup',
    FORGOT_PASSWORD = 'forgotPassword',
    LOGIN = 'login',
    USER_NAME = 'username',
    ADMIN_EMAIL = 'email',
    PASSWORD = 'password',
    VERIFICATION_TYPE = 'verificationType',
    OTP = 'otp',
    IS_LOGGED_IN = 'isLoggedIn',
    PROFILE_PICTURE_URL="profilePictureUrl",
}

export enum ConstantsForMatrimonyUser {
    FULL_NAME = 'fullName',
    EMAIL = 'email',
    MOBILE_NUMBER = 'mobileNumber',
    DOB = 'dob',
    GENDER = 'gender',
    CITY = 'city',
    HOBBIES = 'hobbies',
    CREATED_AT = 'createdAt',
    CREATED_BY_ADMIN_EMAIL = 'createdByAdminEmail',
    IS_FAVOURITE = 'isFavourite',
}

export enum AUTHENTICATION {
    AUTHORIZATION = 'Authorization',
    BEARER = 'Bearer',
    USER_TOKEN = 'userToken',
}


export enum CONSTANTS {
    ID = '_id',
    DATA = "data",
    BODY = "body",
    FAVOURITE = "favourite",
    ALL = "all",
    PROFILE_PICTURE = "profilePicture",
    USER_NAME = "username",
}

export const PROJECT_NAME = 'Heart Bridge';

export enum STORE {
    LOCAL_STORAGE = "local-storage",
}


export enum ApiRouteConst{
    LOGIN = "/api/sign-in",
    IS_LOGGED_IN="/api/isLoggedIn",
    SIGN_UP = "/api/sign-up",
    RESET_PASSWORD = "/api/reset-password",
    VERIFY_OTP = "/api/verify-otp",
    RESEND_OTP = "/api/resend-otp",


}

export enum RouteConst{
    DASHBOARD = "/dashboard",
    VERIFY_OTP = "/verify-otp",
}