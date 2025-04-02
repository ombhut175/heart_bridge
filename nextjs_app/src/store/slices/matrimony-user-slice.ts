import {MatrimonyUserType} from "@/types/store/user";
import {StateCreator} from "zustand";



type MatrimonyUserState = {
    users: MatrimonyUserType[];
};


type MatrimonyUserActions = {
    setUsers: (users: MatrimonyUserType[]) => void
};

export type MatrimonyUserSlice = MatrimonyUserState & MatrimonyUserActions;

export const createMatrimonyUserSlice: StateCreator<
    MatrimonyUserSlice,
    [['zustand/immer', never]],
    [],
    MatrimonyUserSlice
> = (set) => ({
    users: [],
    setUsers: users => set({users}),
});