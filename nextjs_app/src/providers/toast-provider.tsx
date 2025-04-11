"use client"

import { ToastContainer, toast } from "react-toastify";
import 'react-toastify/dist/ReactToastify.css';
import { useTheme } from "next-themes";
import { useEffect, useState } from "react";

export const ToastProvider = () => {
  const { theme } = useTheme();
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) return null;

  return (
    <ToastContainer 
      position="bottom-right"
      autoClose={5000}
      hideProgressBar={false}
      newestOnTop={true}
      closeOnClick
      rtl={false}
      pauseOnHover
      draggable
      pauseOnFocusLoss
      limit={1}
      theme={theme === 'dark' ? 'dark' : 'light'}
    />
  );
}
