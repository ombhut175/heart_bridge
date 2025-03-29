import type { Metadata } from "next"
import { LoginForm } from "@/components/auth/login-form"
import { AuthLayout } from "@/components/shared/auth-layout"

export const metadata: Metadata = {
  title: "Login | Matrimony App",
  description: "Login to your matrimony account",
}

export default function LoginPage() {
  return (
    <AuthLayout
      title="Welcome Back"
      subtitle="Sign in to continue your journey to find your perfect match"
      image="/auth-images/login-image.jpg"
      imageAlt="Couple holding hands"
    >
      <LoginForm />
    </AuthLayout>
  )
}

