import type { Metadata } from "next"
import { SignupForm } from "@/components/auth/signup-form"
import { AuthLayout } from "@/components/shared/auth-layout"

export const metadata: Metadata = {
  title: "Sign Up | Matrimony App",
  description: "Create your matrimony account",
}

export default function SignupPage() {
  return (
    <AuthLayout
      title="Begin Your Journey"
      subtitle="Create an account to find your perfect life partner"
      image="/auth-images/signup-image.jpg"
      imageAlt="Wedding ceremony"
    >
      <SignupForm />
    </AuthLayout>
  )
}

