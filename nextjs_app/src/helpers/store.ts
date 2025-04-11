import {useStore} from "@/store/store";
import {useShallow} from "zustand/react/shallow";
import {ConstantsForMainUser, ConstantsForMatrimonyUser} from "@/helpers/string_const";

export function useGetStore(){
    return useStore(
        useShallow(state => ({
            email: state.email,
            userName: state.username,
            isLoggedIn: state.isLoggedIn,
            fetchUserData: state.fetchUserData,
            loading: state.loading,
            addUser: state.addUser,
            logOutUser: state.logOutUser,
        }))
    );
}

export function useGetUsers(){
    return useStore(
        useShallow(state => ({
            users: state.users,
            setUsers: state.setUsers
        }))
    );
}