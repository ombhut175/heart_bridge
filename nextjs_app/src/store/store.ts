import { create } from 'zustand';
import { devtools, persist, subscribeWithSelector } from 'zustand/middleware';
import { immer } from 'zustand/middleware/immer';
import { createUserSlice } from './slices/user-slice';
import { Store } from '@/types/store/store';


export const useStore = create<Store>()(
	devtools(
		persist(
			subscribeWithSelector(
				immer((...a) => ({
					...createUserSlice(...a),
				}))
			),
			{
				name: 'local-storage',
			}
		)
	)
);
