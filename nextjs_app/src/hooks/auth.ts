import {patchRequest, postRequest} from "@/helpers/ui/handlers";
import {ApiRouteConst, ConstantsForMainUser, RouteConst} from "@/helpers/string_const";
import useSWRMutation from "swr/mutation";
import {axiosInstance} from "@/services/fetcher";

const {
    SIGN_UP,
    VERIFY_OTP,
    LOGIN,
    RESET_PASSWORD,
} = ApiRouteConst;


const loginFetcher = async (url: string, {arg}: { arg: { email: string; password: string } }) => {
    return await postRequest(url, {
        [ConstantsForMainUser.ADMIN_EMAIL]: arg.email,
        [ConstantsForMainUser.PASSWORD]: arg.password,
    });
}

export function useLogin() {
    return useSWRMutation(LOGIN, loginFetcher);
}

const signUpFetcher = async (url: string, {arg}: {
    arg: { email: string; password: string; username: string; }
}) => {
    return await postRequest(url, {
        [ConstantsForMainUser.ADMIN_EMAIL]: arg.email,
        [ConstantsForMainUser.PASSWORD]: arg.password,
        [ConstantsForMainUser.USER_NAME]: arg.username,
    });
}

export function useSignUp() {
    return useSWRMutation(SIGN_UP, signUpFetcher, {
        throwOnError: true,
    });
}

const forgotPasswordFetcher = async (url: string, {arg}: {
    arg: { email: string; password: string; }
}) => {
    return await patchRequest(url, {
        [ConstantsForMainUser.ADMIN_EMAIL]: arg.email,
        [ConstantsForMainUser.PASSWORD]: arg.password,
    });
}

export function useForgotPassword() {
    return useSWRMutation(RESET_PASSWORD, forgotPasswordFetcher, {
        throwOnError: true,
    });
}

const verifyOtpFetcher = async (url: string, {arg}: {
    arg: { email: string; otp: string; verificationType: string; }
}) => {
    return await axiosInstance.post(url, {
        [ConstantsForMainUser.ADMIN_EMAIL]: arg.email,
        [ConstantsForMainUser.OTP]: arg.otp,
        [ConstantsForMainUser.VERIFICATION_TYPE]: arg.verificationType
    });
}

export function useVerifyOtp() {
    return useSWRMutation(VERIFY_OTP, verifyOtpFetcher);
}