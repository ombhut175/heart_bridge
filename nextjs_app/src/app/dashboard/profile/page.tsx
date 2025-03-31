import type { Metadata } from "next"
import { DashboardNavbar } from "@/components/dashboard/navbar"
import { UserProfile } from "@/components/dashboard/user-profile"

export const metadata: Metadata = {
  title: "Profile | Matrimony App",
  description: "Manage your profile",
}

export default function ProfilePage() {
  return (
    <div className="min-h-screen bg-background">
      <DashboardNavbar />
      <main className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-2">Your Profile</h1>
        <p className="text-muted-foreground mb-8">Manage your profile information and preferences.</p>

        <UserProfile />
      </main>
    </div>
  )
}

