import { User } from "@/types/store/user";
import { StateCreator } from "zustand";
import {ConstantsForMainUser} from "@/helpers/string_const";
import { getRequest, handleError } from "@/helpers/ui/handlers";
import { ca } from "date-fns/locale";

type UserState = User;

type UserActions = {
	addUser: (user: User) => void;
	fetchUserData: () => Promise<void>;
    logOutUser: () => void;
};

async function fetchUser() {

		const response = await getRequest("/api/isLoggedIn");
    console.log(response.body);
		
		const user:UserState = {
            [ConstantsForMainUser.USER_NAME]:response.body[ConstantsForMainUser.USER_NAME],
			[ConstantsForMainUser.ADMIN_EMAIL]: response.body[ConstantsForMainUser.ADMIN_EMAIL],
			[ConstantsForMainUser.IS_LOGGED_IN]: true,
		};
		return user;
}

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
	loading: true,
    addUser: (user) => {
        set(user);	
    },
    fetchUserData: async () => {
        set({loading: true});

        try {
            const userData = await fetchUser();
            if (userData) {
                set(userData);
            }
        } catch (error) {
            handleError(error);
        }finally {
            set({loading: false});
        }
    },
    logOutUser : () => {
        set({isLoggedIn: false})
    }
});