import { UserSlice } from "@/store/slices/user-slice";
import {MatrimonyUserSlice} from "@/store/slices/matrimony-user-slice";


export type Store = UserSlice & MatrimonyUserSlice;