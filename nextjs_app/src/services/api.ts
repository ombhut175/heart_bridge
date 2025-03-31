import {ConstantsForMainUser} from "@/helpers/string_const";
import {axiosInstance} from "./fetcher"

export const loginFetcher = async (url: string, {arg}: { arg: { email: string; password: string } }) => {
    return await axiosInstance.post(url, {
        [ConstantsForMainUser.ADMIN_EMAIL]: arg.email,
        [ConstantsForMainUser.PASSWORD]: arg.password,
    });
}

export const signUpFetcher = async (url: string, {arg}: {
    arg: { email: string; password: string; username: string;}
}) => {
    return await axiosInstance.post(url, {
        [ConstantsForMainUser.ADMIN_EMAIL]: arg.email,
        [ConstantsForMainUser.PASSWORD]: arg.password,
        [ConstantsForMainUser.USER_NAME]: arg.username,
    });
}