

export type User = {
  email: string;
  name?: string;
  isLoggedIn: boolean;
  loading?: boolean;
}

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
