import mongoose, {Document, Schema,Types} from "mongoose";
import {ConstantsForMatrimonyUser} from "@/helpers/string_const";

const { FULL_NAME, EMAIL, MOBILE_NUMBER, DOB, GENDER, CITY, HOBBIES, CREATED_AT ,CREATED_BY_ADMIN_EMAIL} = ConstantsForMatrimonyUser;

export interface MatrimonyUserInterface extends Document {
    [FULL_NAME]: string;
    [EMAIL]: string;
    [MOBILE_NUMBER]: string;
    [DOB]: string;
    [GENDER]: string;
    [CITY]: string;
    [HOBBIES]: string[];
    [CREATED_AT]: Date;
    [CREATED_BY_ADMIN_EMAIL] : string
}

const UserSchema: Schema<MatrimonyUserInterface> = new mongoose.Schema({
    [CREATED_BY_ADMIN_EMAIL]:{
        type: String,
        required: true,
    },
    [EMAIL]: {
        type: String,
        required: true,
        unique: true
    },
    [FULL_NAME]: {
        type: String,
        required: true,
    },
    [CITY]: {
        type: String,
        required: true,
    },
    [DOB]: {
        type: String,
        required: true,
    },
    [GENDER]: {
        type: String,
        required: true,
        enum: ["male", "female"],
    },
    [HOBBIES]: {
        type: [String],
        required: false,
    },
    [CREATED_AT]: {
        type: Date,
        default: Date.now,
    },
});


const MatrimonyUsersModel =
    (mongoose.models.MatrimonyUsers as mongoose.Model<MatrimonyUserInterface>) ||
    mongoose.model<MatrimonyUserInterface>('MatrimonyUsers', UserSchema);

export default MatrimonyUsersModel;