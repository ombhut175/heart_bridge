import {MatrimonyUserType, User} from "@/types/store/user";

type UserState = MatrimonyUserType;


type UserActions = {
    addUser: (user: MatrimonyUserType) => void;
    editUser: (userId: string, user: MatrimonyUserType) => void;
    deleteUser: (userId: string) => void;
};

export type UserSlice = UserState & UserActions;

// export const createUserSlice: StateCreator<
//     UserSlice,
//     [['zustand/immer', never]],
//     [],
//     UserSlice
// > = (set) => ({
//
// });