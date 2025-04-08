import {useStore} from "@/store/store";
import {useShallow} from "zustand/react/shallow";

export function useGetStore(){
    return useStore(
        useShallow(state => ({
            addUser: state.addUser,
            email: state.email,
            name: state.name,
            isLoggedIn: state.isLoggedIn,
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