"use client";

import { useEffect, useState } from "react";
import {showLoadingBar} from "@/helpers/ui/uiHelpers";

export const WelcomeBar = () => {
    const [loaded, setLoaded] = useState(false);


    useEffect(() => {
        setLoaded(true);
    },[]);

    if (!loaded) return showLoadingBar();

  return (
    <main className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-6">Dashboard</h1>
        <p className="text-muted-foreground">
          Welcome to your matrimony dashboard. Start exploring potential
          matches!
        </p>
      </main>
  );
};