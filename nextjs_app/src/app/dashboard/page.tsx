'use client'; // Add this directive at the top

import type { Metadata } from 'next';
import { DashboardNavbar } from '@/components/dashboard/navbar';
import {useStore} from "@/store/store";
import {useShallow} from "zustand/react/shallow";

// Metadata can't be exported from client components in Next.js
// You'll need to move this to a separate layout file or use other methods
// export const metadata: Metadata = {
//   title: 'Dashboard | Matrimony App',
//   description: 'Find your perfect match',
// };

export default function DashboardPage() {
    const {email} = useStore(
        useShallow(state => ({
            addUser: state.addUser,
            email: state.email,
        }))
    );
    console.log(email);
  return (
    <div className="min-h-screen bg-background">
      <DashboardNavbar />
      <main className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-6">Dashboard</h1>
        <p className="text-muted-foreground">
          Welcome to your matrimony dashboard. Start exploring potential
          matches!
        </p>
      </main>
    </div>
  );
}
