import {ConstantsForMainUser} from "@/helpers/string_const";


export type User = {
  email: string;
  username: string;
  // isLoggedIn: boolean;
  loading?: boolean;
  profilePictureUrl? : string;
  // [ConstantsForMainUser.USER_NAME]: string;
}

// export type User = {
//   email: string;
//   name?: string;
//   isLoggedIn: boolean;
//   loading?: boolean;
// }

export type MatrimonyUserType = {
  _id: any,
  fullName: string;
  email: string;
  mobileNumber: string;
  dob: string;
  gender: string;
  city: string;
  hobbies: string[];
  createdAt: string;
  createdByAdminEmail: string;
  isFavourite: number;
};
