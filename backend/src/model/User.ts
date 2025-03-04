import mongoose, {Document, Schema} from "mongoose";

export interface User extends Document {
    username: string;
    email: string;
    password: string;
    verifyCode: string;
    verifyCodeExpiry: Date;
    isVerified: boolean;
}


const UserSchema:Schema<User> = new mongoose.Schema({
   email:{
       type: String,
       required: true,
   } ,
    password:{
       type:String
    },
    username:{
       type:String,
        required: true,
    },
    verifyCode: {
        type: String,
        required: [true, 'Verify Code is required'],
    },
    verifyCodeExpiry: {
        type: Date,
        required: [true, 'Verify Code Expiry is required'],
    },
    isVerified: {
        type: Boolean,
        default: false,
    }
});


const UserModel =
    (mongoose.models.User as mongoose.Model<User>) ||
    mongoose.model<User>('User', UserSchema);

export default UserModel;