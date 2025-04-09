import { DashboardNavbar } from '@/components/dashboard/navbar';
import { WelcomeBar } from '@/components/dashboard/welcome-bar';

export default function DashboardPage() {

  return (
    <div className="min-h-screen bg-background">
      <DashboardNavbar />
      <WelcomeBar />
    </div>
  );
}
