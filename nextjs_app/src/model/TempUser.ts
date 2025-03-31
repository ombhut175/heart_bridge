import mongoose, { Document, Schema } from 'mongoose';

export interface TempUserInterface extends Document {
  username: string;
  email: string;
  password: string;
  verifyCode: string;
  verifyCodeExpiry: Date;
}

const TempUserSchema: Schema<TempUserInterface> = new mongoose.Schema({
  email: {
    type: String,
    required: true,
  },
  password: {
    type: String,
  },
  username: {
    type: String,
    required: true,
  },
  verifyCode: {
    type: String,
    required: [true, 'Verify Code is required'],
  },
  verifyCodeExpiry: {
    type: Date,
    required: [true, 'Verify Code Expiry is required'],
    index: {
      expires: '10m',
    },
  },
});

const TempUserModel =
  (mongoose.models.TempUser as mongoose.Model<TempUserInterface>) ||
  mongoose.model<TempUserInterface>('TempUser', TempUserSchema);

export default TempUserModel;
