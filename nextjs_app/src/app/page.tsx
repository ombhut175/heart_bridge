import Link from "next/link"
import { Button } from "@/components/ui/button"

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-6 bg-gradient-to-b from-background to-muted">
      <div className="max-w-md w-full space-y-8 text-center">
        <div className="space-y-2">
          <h1 className="text-4xl font-bold tracking-tight">Matrimony App</h1>
          <p className="text-muted-foreground">Find your perfect life partner</p>
        </div>

        <div className="flex flex-col space-y-4 pt-4">
          <Button asChild size="lg" className="h-12">
            <Link href="/login">Login</Link>
          </Button>

          <Button asChild variant="outline" size="lg" className="h-12">
            <Link href="/signup">Create Account</Link>
          </Button>
        </div>

        <div className="pt-8 text-sm text-muted-foreground">
          <p>
            Already have an account?{" "}
            <Link href="/login" className="text-primary hover:underline">
              Sign in
            </Link>
          </p>
          <p className="mt-2">
            Forgot your password?{" "}
            <Link href="/forgot-password" className="text-primary hover:underline">
              Reset it here
            </Link>
          </p>
        </div>
      </div>
    </main>
  )
}

