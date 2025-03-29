import type { Metadata } from "next"
import { OtpVerificationForm } from "@/components/auth/otp-verification-form"
import { AuthLayout } from "@/components/shared/auth-layout"

export const metadata: Metadata = {
  title: "Verify OTP | Matrimony App",
  description: "Verify your identity with OTP",
}

export default function VerifyOtpPage() {
  return (
    <AuthLayout
      title="Verify Your Identity"
      subtitle="Enter the 4-digit code sent to your email or phone"
      image="/auth-images/otp-image.jpg"
      imageAlt="Person checking phone"
    >
      <OtpVerificationForm />
    </AuthLayout>
  )
}

