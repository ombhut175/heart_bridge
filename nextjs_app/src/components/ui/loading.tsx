'use client';

import { Loader2 } from 'lucide-react';

export function LoadingSpinner() {
  return (
    <div className="flex justify-center items-center min-h-[200px]">
      <Loader2 className="h-8 w-8 animate-spin text-primary" />
      <span className="ml-2 text-muted-foreground">Loading...</span>
    </div>
  );
}