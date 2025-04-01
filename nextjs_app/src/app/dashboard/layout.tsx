import type { Metadata } from 'next';
import {ToastContainer} from "react-toastify";

export const metadata: Metadata = {
  title: 'Dashboard | Matrimony App',
  description: 'Find your perfect match',
};

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <>
    {children}
    <ToastContainer />
  </>;
}