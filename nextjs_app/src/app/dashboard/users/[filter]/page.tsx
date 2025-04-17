import type { Metadata } from 'next';
import { DashboardNavbar } from '@/components/dashboard/navbar';
import { UsersList } from '@/components/dashboard/user/users-list';
import { CONSTANTS } from "@/helpers/string_const";

type Props = {
  params: { filter: string };
};

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const isFavourites = params.filter === CONSTANTS.FAVOURITE;

  return {
    title: isFavourites ? "Favourite Users - Dashboard" : "All Users - Dashboard",
    description: isFavourites
      ? "View your favourite users in the dashboard."
      : "Browse all users in the dashboard.",
  };
}

export default function UsersPage({ params }: Props) {
  const isFavourite = params.filter === CONSTANTS.FAVOURITE;
  
  return (
    <div className="min-h-screen bg-background">
      <DashboardNavbar />
      <main className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-2">Users</h1>
        <p className="text-muted-foreground mb-8">
          Browse potential matches and find your perfect partner.
        </p>

        <UsersList isFavourite={isFavourite}/>
      </main>
    </div>
  );
}
