import { create } from 'zustand';
import { devtools, persist, subscribeWithSelector } from 'zustand/middleware';
import { immer } from 'zustand/middleware/immer';
import {createUserSlice, UserSlice} from './slices/user-slice';
import {createMatrimonyUserSlice} from "@/store/slices/matrimony-user-slice";
import {Store} from "@/types/store/store";
import {STORE} from "@/helpers/string_const";


export const useStore = create<Store>()(
	devtools(
		persist(
			subscribeWithSelector(
				immer((...a) => ({
					...(createUserSlice as any)(...a),
					...(createMatrimonyUserSlice as any)(...a),
				}))
			),
			{
				name: STORE.LOCAL_STORAGE,
			}
		)
	)
);
