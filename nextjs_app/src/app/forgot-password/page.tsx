import type { Metadata } from "next"
import { ForgotPasswordForm } from "@/components/auth/forgot-password-form"
import { AuthLayout } from "@/components/shared/auth-layout"

export const metadata: Metadata = {
  title: "Forgot Password | Matrimony App",
  description: "Reset your matrimony account password",
}

export default function ForgotPasswordPage() {
  return (
    <AuthLayout
      title="Forgot Password?"
      subtitle="Don't worry, we'll help you reset your password"
      image="/auth-images/forgot-password-image.jpg"
      imageAlt="Person using phone"
    >
      <ForgotPasswordForm />
    </AuthLayout>
  )
}

