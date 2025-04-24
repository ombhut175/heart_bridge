import {getRequest, handleError, handleSuccess} from "@/helpers/ui/handlers";
import {ApiAuthRouteConst, ConstantsForMainUser, RouteConst} from "@/helpers/string_const";
import React from "react";
import {axiosInstance} from "@/services/fetcher";
import {getEncodedUrl} from "@/helpers/ui/utils";
import {otpDataInterface} from "@/helpers/interfaces";


const {
    IS_LOGGED_IN,
    RESEND_OTP
} = ApiAuthRouteConst;

const {
    DASHBOARD,
    VERIFY_OTP: ROUTE_VERIFY_OTP,
} = RouteConst;

export default async function isUserLoggedIn() {
    const response = await getRequest(IS_LOGGED_IN);
}

interface HandleLoginSubmitParams {
    e: React.FormEvent;
    trigger: (args: { email: string; password: string }) => Promise<any>;
    formState: { email: string; password: string };
    addUser: (user: any) => void;
    router: any;
}

export const handleLoginSubmit = async ({
                                            e, trigger, formState, addUser, router,
                                        }: HandleLoginSubmitParams) => {
    e.preventDefault();

    try {
        const response = await trigger({
            email: formState.email,
            password: formState.password,
        });

        const user = {
            [ConstantsForMainUser.USER_NAME]: response.body.username,
            [ConstantsForMainUser.ADMIN_EMAIL]: formState.email,
            [ConstantsForMainUser.IS_LOGGED_IN]: true,
        };

        console.log(user);
        addUser(user);
        router.replace(DASHBOARD);
    } catch (error) {
        handleError(error);
    }
};

interface HandleSignupSubmitParams {
    e: React.FormEvent;
    trigger: (args: { email: string; password: string; username: string }) => Promise<any>;
    formState: { email: string; password: string; username: string };
    setIsLoading: (loading: boolean) => void;
    router: any;
}

export const handleSignupSubmit = async ({
                                             e, trigger, formState, setIsLoading, router
                                         }: HandleSignupSubmitParams) => {
    e.preventDefault();

    try {
        setIsLoading(true);

        const response = await trigger({
            email: formState.email,
            password: formState.password,
            username: formState.username,
        });

        const data: otpDataInterface = {
            [ConstantsForMainUser.VERIFICATION_TYPE]: ConstantsForMainUser.SIGN_UP,
            [ConstantsForMainUser.ADMIN_EMAIL]: formState.email,
            [ConstantsForMainUser.USER_NAME]: formState.username,
        };

        const encodedUrl = getEncodedUrl({
            data,
            route: ROUTE_VERIFY_OTP,
        });

        router.replace(encodedUrl);
    } catch (error) {
        handleError(error);
    } finally {
        setIsLoading(false);
    }
};

interface HandleForgotPasswordSubmitParams {
    e: React.FormEvent;
    trigger: (args: { email: string; password: string }) => Promise<any>;
    email: string;
    password: string;
    validatePassword: (value: string) => boolean;
    setIsLoading: (loading: boolean) => void;
    router: any;
}

export const handleForgotPasswordSubmit = async ({
                                                     e, trigger, email, password, validatePassword, setIsLoading, router
                                                 }: HandleForgotPasswordSubmitParams) => {
    e.preventDefault();

    if (!validatePassword(password)) {
        return;
    }

    setIsLoading(true);

    try {
        const responseData = await trigger({
            email,
            password
        });

        const data: otpDataInterface = {
            [ConstantsForMainUser.VERIFICATION_TYPE]: ConstantsForMainUser.FORGOT_PASSWORD,
            [ConstantsForMainUser.ADMIN_EMAIL]: email,
            [ConstantsForMainUser.USER_NAME]: responseData.body[ConstantsForMainUser.USER_NAME],
        };

        const encodedUrl = getEncodedUrl({
            data,
            route: ROUTE_VERIFY_OTP,
        });

        router.replace(encodedUrl);
    } catch (error) {
        setIsLoading(false);
        handleError(error);
    }
};

interface HandleOtpSubmitParams {
    e: React.FormEvent;
    trigger: (args: { email: string; otp: string; verificationType: string }) => Promise<any>;
    otp: string[];
    otpData: otpDataInterface;
    addUser: (user: any) => void;
    router: any;
}

export const handleOtpSubmit = async ({
                                          e, trigger, otp, otpData, addUser, router
                                      }: HandleOtpSubmitParams) => {
    e.preventDefault();
    const otpToSubmit = otp.join('');

    if (otpToSubmit.length !== 4) return handleError("Otp must be of 4 digits");

    try {
        const response = await trigger({
            email: otpData.email,
            otp: otpToSubmit,
            verificationType: otpData[ConstantsForMainUser.VERIFICATION_TYPE],
        });

        const user = {
            [ConstantsForMainUser.USER_NAME]: otpData[ConstantsForMainUser.USER_NAME],
            [ConstantsForMainUser.ADMIN_EMAIL]: otpData[ConstantsForMainUser.ADMIN_EMAIL],
            [ConstantsForMainUser.IS_LOGGED_IN]: true,
        };

        addUser(user);

        handleSuccess(response.data);

        router.replace(DASHBOARD);
    } catch (error) {
        handleError(error);
    }
};

export const handleResendOtp = async (otpData: otpDataInterface, startResendTimer: () => void) => {
    startResendTimer();

    try {
        const responseBody = await axiosInstance.post(RESEND_OTP, {
            [ConstantsForMainUser.ADMIN_EMAIL]: otpData[ConstantsForMainUser.ADMIN_EMAIL],
            [ConstantsForMainUser.VERIFICATION_TYPE]: otpData[ConstantsForMainUser.VERIFICATION_TYPE],
        });

        handleSuccess(responseBody.data);
    } catch (error) {
        handleError(error);
    }
};