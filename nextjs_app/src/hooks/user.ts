import {getRequest, handleError, postRequest, putRequest} from "@/helpers/ui/handlers";
import useSWR from "swr";
import useSWRMutation from "swr/mutation";
import {UserFormData} from "@/components/dashboard/user/add-user-dialog";
import {ApiRouteConst} from "@/helpers/string_const";

const {
    UPDATE_PROFILE,
    GET_USER
} = ApiRouteConst;

const userFetcher = async (url: string) => await getRequest(url);

export function useFetchUsers() {
    return useSWR(GET_USER,userFetcher);
}

const addUserFetcher = async (url: string, {arg}: { arg: { user: UserFormData } }) => {
    return await postRequest(url, arg.user);
}

const editUserFetcher = async (url: string, {arg}: { arg: { user: UserFormData } }) => {
    return await putRequest(url, arg.user);

}


// @ts-ignore
export function useEditUser(userId){
    return useSWRMutation(`${GET_USER}/${userId}`, editUserFetcher);
}

export function useAddUser(){
    return useSWRMutation(GET_USER, addUserFetcher);
}

const editMainUserFetcher = async (url: string, {arg}: { arg: { formData: FormData } }) => {
    return await postRequest(url, arg.formData);
}

export function useEditMainUser(){
   return useSWRMutation(UPDATE_PROFILE, editMainUserFetcher);
}


