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


export enum ApiAuthRouteConst{
    LOGIN = "/api/sign-in",
    IS_LOGGED_IN="/api/isLoggedIn",
    SIGN_UP = "/api/sign-up",
    RESET_PASSWORD = "/api/reset-password",
    VERIFY_OTP = "/api/verify-otp",
    RESEND_OTP = "/api/resend-otp",
}

export enum ApiRouteConst{
    GET_USER = "/api/user",
    UPDATE_PROFILE = "/api/user/update-profile",
    GET_USER_INFO = "/api/user/get-user-info",
}

export enum RouteConst{
    DASHBOARD = "/dashboard",
    VERIFY_OTP = "/verify-otp",
    LOGIN = "/login",
}

// Rate limiting related constants
export enum RateLimitRedisUrlConst {
    HTTPS = "https://",
}

export enum RateLimitEnvConst {
    PRODUCTION = "production",
}

export enum RateLimitNameConst {
    AUTH_RATE_LIMIT = "authRateLimit",
    AUTH = "auth",
}

export enum RateLimitIdentifierConst {
    IP = "ip",
}

export enum RateLimitHeaderConst {
    X_FORWARDED_FOR = "x-forwarded-for",
    USERNAME = "username",
}

export enum RateLimitCookieConst {
    SESSION_ID = "sessionId",
}

export enum RateLimitDefaultConst {
    ANONYMOUS = "anonymous",
    SLIDING_WINDOW_SUFFIX = " s",
}

export enum RateLimitBodyKeyConst {
    EMAIL = "email",
    PHONE = "phone",
    USERNAME = "username",
}

export enum RateLimitAuthEndpointConst {
    SIGN_IN = "sign-in",
    SIGN_UP = "sign-up",
    VERIFY_OTP = "verify-otp",
    RESEND_OTP = "resend-otp",
    RESET_PASSWORD = "reset-password",
    IS_LOGGED_IN = "isLoggedIn",
}

// User API routes rate limiting constants
export enum RateLimitUserApiConst {
    // General operations - mid-level restriction
    GET_USERS = "get-users", // Main user listing endpoint
    GET_USER_INFO = "get-user-info", // Check own user info

    // Write operations - more restricted
    UPDATE_PROFILE = "update-profile", // Profile update with potential image upload
    CREATE_USER = "create-user", // Adding new matrimony users
    UPDATE_USER = "update-user", // Update matrimony user details
    DELETE_USER = "delete-user", // Delete matrimony user

    // Toggle operations - can be called frequently
    TOGGLE_FAVOURITE = "toggle-favourite", // Toggle favorite status

    // Session operations - different security model
    LOGOUT = "log-out", // User logout operation

    // Resource-intensive operations
    UPLOAD_IMAGE = "upload-image", // Image upload testing route

    // Rate limit window durations in seconds
    HIGH_SECURITY_DURATION = 3600, // 1 hour 
    MEDIUM_SECURITY_DURATION = 300, // 5 minutes
    LOW_SECURITY_DURATION = 60, // 1 minute

    // Rate limit request counts
    HIGH_SECURITY_REQUESTS = 3, // Very limited requests
    MEDIUM_SECURITY_REQUESTS = 30, // Moderate number of requests
    LOW_SECURITY_REQUESTS = 60, // Higher number of requests
}