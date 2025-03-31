import type { Metadata } from "next"
import { DashboardNavbar } from "@/components/dashboard/navbar"
import { UsersList } from "@/components/dashboard/users-list"

export const metadata: Metadata = {
  title: "Users | Matrimony App",
  description: "Browse potential matches",
}

export default function UsersPage() {
  return (
    <div className="min-h-screen bg-background">
      <DashboardNavbar />
      <main className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-2">Users</h1>
        <p className="text-muted-foreground mb-8">Browse potential matches and find your perfect partner.</p>

        <UsersList />
      </main>
    </div>
  )
}

