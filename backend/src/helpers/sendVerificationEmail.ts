import {ApiResponse} from "@/types/ApiResponse";
import {transporter} from "@/lib/nodemailer";

export async function sendVerificationEmail(
        email: string,
        username: string,
        verifyCode: string
    ):Promise<ApiResponse>{
    try {
       const response = await sendTextToMail(email,"Verify your email",`<h1>Your Verification code is ${verifyCode}</h1>`)
        return { success: true, message: 'Verification email sent successfully.' };
    }catch (error) {
        console.error('Error sending verification email:', error);
        return {
            success:false,
            message: 'Failed to send verification email'
        }
    }
}


export async function sendWelcomeEmail(email:string,username:string):Promise<ApiResponse>{
    try{
        const response = await sendTextToMail(email,"Welcome to our Matrimony App",`<h1>Welcome ${username} to our Matrimony App</h1>`)
        return { success: true, message: 'Successfully sent welcome email'};
    }catch (e) {
        console.log('error at welcome = '+e)
        return {
            success:false,
            message:"Error in sending welcome email"
        }
    }
}

async function sendTextToMail(
    email:string,
    subject:string,
    text:string
):Promise<void>{
    await transporter.sendMail({
        from: '"OmPatel" <process.env.EMAIL_FV>', // sender address
        to: email, // list of receivers
        subject: subject, // Subject line
        text: subject, // plain text body
        html: "<h1>"+text+"</h1>", // html body
    })
}