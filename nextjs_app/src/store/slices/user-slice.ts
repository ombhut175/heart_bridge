import {User} from "@/types/store/user";
import {StateCreator} from "zustand";
import {ConstantsForMainUser, STORE} from "@/helpers/string_const";
import {getRequest, handleError} from "@/helpers/ui/handlers";
import {ca} from "date-fns/locale";

type UserState = User;

type UserActions = {
    addUser: (user: User) => void;
    fetchUserData: () => Promise<void>;
    logOutUser: () => void;
};

async function fetchUser() {

    const response = await getRequest("/api/user/get-user-info");

    const user: UserState = {
        username: response.body[ConstantsForMainUser.USER_NAME],
        email: response.body[ConstantsForMainUser.ADMIN_EMAIL],
        profilePictureUrl: response.body[ConstantsForMainUser.PROFILE_PICTURE_URL],
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
    email:'',
    username: '',
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
        } finally {
            set({loading: false});
        }
    },
    logOutUser: () => {
        // set({isLoggedIn: false})
        set(state => ({
            email: '',
            username: '',
            loading: false,
        }));

        if (typeof window !== "undefined") {
            localStorage.removeItem(STORE.LOCAL_STORAGE);
        }
    }
});