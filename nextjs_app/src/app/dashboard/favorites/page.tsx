import type { Metadata } from 'next';
import { DashboardNavbar } from '@/components/dashboard/navbar';
import { FavoritesList } from '@/components/dashboard/favorites-list';

export const metadata: Metadata = {
  title: 'Favorites | Matrimony App',
  description: 'Your favorite matches',
};

export default function FavoritesPage() {
  return (
    <div className="min-h-screen bg-background">
      <DashboardNavbar />
      <main className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-2">Favorites</h1>
        <p className="text-muted-foreground mb-8">
          View and manage your favorite profiles.
        </p>

        <FavoritesList />
      </main>
    </div>
  );
}
