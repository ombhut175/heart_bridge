'use client';

import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { motion } from 'framer-motion';
import { Heart } from 'lucide-react';
import { use, useEffect, useState } from 'react';
import { showLoadingBar } from '@/helpers/ui/uiHelpers';

export default function FirstPage() {
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    setLoaded(true);
  },[]);


  const container = {
    hidden: { opacity: 0 },
    show: {
      opacity: 1,
      transition: {
        staggerChildren: 0.1,
        delayChildren: 0.3,
      },
    },
  };

  const item = {
    hidden: { opacity: 0, y: 20 },
    show: { opacity: 1, y: 0, transition: { type: 'spring', stiffness: 100 } },
  };

  if(!loaded) return showLoadingBar();

  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-6 relative overflow-hidden">
      {/* Background gradient */}
      <div className="absolute inset-0 -z-10 bg-[radial-gradient(ellipse_at_top,_var(--tw-gradient-stops))] from-primary/10 via-background to-background"></div>

      {/* Decorative elements */}
      <div className="absolute top-0 right-0 w-64 h-64 bg-primary/5 rounded-full -translate-y-1/2 translate-x-1/2 blur-3xl"></div>
      <div className="absolute bottom-0 left-0 w-64 h-64 bg-primary/5 rounded-full translate-y-1/2 -translate-x-1/2 blur-3xl"></div>

      <motion.div
        className="max-w-md w-full space-y-8 text-center"
        variants={container}
        initial="hidden"
        animate="show"
      >
        <motion.div variants={item} className="space-y-2">
          <div className="flex justify-center mb-6">
            <motion.div
              className="w-16 h-16 rounded-full bg-primary/10 flex items-center justify-center"
              whileHover={{ scale: 1.1, rotate: 5 }}
              transition={{ type: 'spring', stiffness: 400, damping: 10 }}
            >
              <Heart className="h-8 w-8 text-primary" />
            </motion.div>
          </div>
          <h1 className="text-4xl font-bold tracking-tight">Matrimony App</h1>
          <p className="text-muted-foreground">
            Find your perfect life partner
          </p>
        </motion.div>

        <motion.div variants={item} className="flex flex-col space-y-4 pt-4">
          <motion.div
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            transition={{ type: 'spring', stiffness: 400, damping: 10 }}
          >
            <Button
              asChild
              size="lg"
              className="h-12 w-full relative overflow-hidden group"
            >
              <Link href="/login">
                <span className="relative z-10">Login</span>
                <span className="absolute inset-0 bg-gradient-to-r from-primary to-primary/80 z-0 opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
              </Link>
            </Button>
          </motion.div>

          <motion.div
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            transition={{ type: 'spring', stiffness: 400, damping: 10 }}
          >
            <Button
              asChild
              variant="outline"
              size="lg"
              className="h-12 w-full border-primary/20 hover:border-primary/50 hover:bg-primary/5"
            >
              <Link href="/signup">Create Account</Link>
            </Button>
          </motion.div>

          <motion.div
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            transition={{ type: 'spring', stiffness: 400, damping: 10 }}
          >
            <a
              href="https://github.com/ombhut175/matrimony_app/releases/tag/v1.0.1-beta"
              target="_blank"
              rel="noopener noreferrer"
              className="block w-full h-12 rounded-md border border-primary/20 bg-primary/10 text-primary font-semibold flex items-center justify-center transition hover:bg-primary/20 hover:border-primary/50 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2"
              style={{ textDecoration: 'none' }}
            >
              Download HeartLink Mobile App
            </a>
          </motion.div>
        </motion.div>

        <motion.div
          variants={item}
          className="pt-8 text-sm text-muted-foreground"
        >
          <p>
            Already have an account?{' '}
            <motion.span
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              className="inline-block"
            >
              <Link href="/login" className="text-primary hover:underline">
                Sign in
              </Link>
            </motion.span>
          </p>
          <p className="mt-2">
            Forgot your password?{' '}
            <motion.span
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              className="inline-block"
            >
              <Link
                href="/forgot-password"
                className="text-primary hover:underline"
              >
                Reset it here
              </Link>
            </motion.span>
          </p>
        </motion.div>
      </motion.div>
    </main>
  );
}
