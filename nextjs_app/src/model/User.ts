import mongoose, { Document, Schema } from 'mongoose';

export interface UserInterface extends Document {
  username: string;
  email: string;
  password: string;
  isVerified: boolean;
  createdAt: Date;
  verifyCode: string;
  verifyCodeExpiry: Date;
}

const UserSchema: Schema<UserInterface> = new mongoose.Schema({
  email: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
  },
  username: {
    type: String,
    required: true,
    unique: true,
  },
  isVerified: {
    type: Boolean,
    default: false,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  verifyCode: {
    type: String,
  },
  verifyCodeExpiry: {
    type: Date,
  },
});

const UserModel =
  (mongoose.models.User as mongoose.Model<UserInterface>) ||
  mongoose.model<UserInterface>('User', UserSchema);

export default UserModel;
