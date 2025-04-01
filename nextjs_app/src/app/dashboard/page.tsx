'use client';

import { DashboardNavbar } from '@/components/dashboard/navbar';


export default function DashboardPage() {

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
