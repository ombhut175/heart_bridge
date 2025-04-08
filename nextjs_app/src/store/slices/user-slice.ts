import { User } from "@/types/store/user";
import { StateCreator } from "zustand";
import {ConstantsForMainUser} from "@/helpers/string_const";

type UserState = User;


type UserActions = {
	addUser: (user: User) => void;
};

export type UserSlice = UserState & UserActions;

export const createUserSlice: StateCreator<
	UserSlice,
	[['zustand/immer', never]],
	[],
	UserSlice
> = (set) => ({
	[ConstantsForMainUser.ADMIN_EMAIL]: '',
	[ConstantsForMainUser.USER_NAME] : '',
	[ConstantsForMainUser.IS_LOGGED_IN]: false,
    addUser: (user) => {
        set(user);	
    }
});