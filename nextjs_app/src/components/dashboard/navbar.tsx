"use client"

import { use, useEffect, useState } from "react"
import Link from "next/link"
import { motion, AnimatePresence } from "framer-motion"
import { usePathname, useRouter } from "next/navigation"
import { Heart, Users, User, Bell, LogOut, Menu, X } from "lucide-react"
import { Button } from "@/components/ui/button"
import { ThemeToggle } from "@/components/ui/theme-toggle"
import {CONSTANTS, RouteConst} from "@/helpers/string_const";
import { useGetStore } from "@/hooks/store"
import { showLoadingBar } from "@/helpers/ui/uiHelpers"
import {handleError, postRequest} from "@/helpers/ui/handlers";
import isUserLoggedIn from "@/services/functions/auth";

export function DashboardNavbar() {
  const router = useRouter();
  const pathname = usePathname()
  const [showMobileMenu, setShowMobileMenu] = useState(false)
  const [showProfileMenu, setShowProfileMenu] = useState(false);
  
  const {
    fetchUserData,
      userName,
      email,
      logOutUser
  } = useGetStore();
  
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    setLoaded(true);
  },[]);

  useEffect(() => {
    async function fetchData() {


      try {
        await isUserLoggedIn();

        await fetchUserData();

      }catch (error) {
        router.replace(RouteConst.LOGIN);
      }
    }

    fetchData();
  }, [fetchUserData, router]);



  const handleLogOut = async () => {
    try {
      console.log("::: log out :::");

      const response = await postRequest("/api/user/log-out");

      router.replace("/login");

      logOutUser();
    }catch (error) {
      handleError(error);
    }
  }

  const navLinks = [
    {
      name: "Users",
      href: `/dashboard/users/${CONSTANTS.ALL}`,
      icon: Users,
    },
    {
      name: "Favorites",
      href: `/dashboard/users/${CONSTANTS.FAVOURITE}`,
      icon: Heart,
    },
    {
      name: "Testing",
      href: `/dashboard/testing`,
      icon: Heart,
    },
  ]

  const isActive = (path: string) => {
    return pathname === path || pathname?.startsWith(path)
  }

  if(!loaded) return showLoadingBar();

  return (
    <header className="sticky top-0 z-50 w-full border-b border-border/40 bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div className="container flex h-16 items-center">
        <div className="mr-4 flex">
          <Link href="/dashboard" className="flex items-center space-x-2">
            <Heart className="h-6 w-6 text-primary" fill="currentColor" />
            <span className="hidden font-bold sm:inline-block">
              <span className="text-primary">Heart</span>Bridge
            </span>
          </Link>
        </div>

        {/* Mobile menu button */}
        <Button
          variant="ghost"
          size="icon"
          className="mr-2 md:hidden"
          onClick={() => setShowMobileMenu(!showMobileMenu)}
        >
          {showMobileMenu ? <X className="h-5 w-5" /> : <Menu className="h-5 w-5" />}
          <span className="sr-only">Toggle menu</span>
        </Button>

        {/* Desktop navigation */}
        <nav className="hidden md:flex md:flex-1 md:items-center md:justify-between">
          <div className="flex items-center space-x-1">
            {navLinks.map((link) => (
              <Link
                key={link.href}
                href={link.href}
                className={`group flex items-center px-3 py-2 text-sm font-medium transition-colors hover:text-primary ${
                  isActive(link.href) ? "text-primary" : "text-muted-foreground"
                }`}
              >
                <link.icon className="mr-2 h-4 w-4" />
                {link.name}
                {isActive(link.href) && (
                  <motion.div
                    className="absolute bottom-0 left-0 h-0.5 w-full bg-primary"
                    layoutId="navbar-indicator"
                    transition={{ type: "spring", bounce: 0.25 }}
                  />
                )}
              </Link>
            ))}
          </div>

          <div className="flex items-center space-x-2">
            <ThemeToggle />
            <div className="relative">
              <Button
                variant="ghost"
                size="icon"
                className="relative h-8 w-8 rounded-full border border-border"
                onClick={() => setShowProfileMenu(!showProfileMenu)}
              >
                <User className="h-4 w-4" />
                <span className="sr-only">Open profile menu</span>
              </Button>

              <AnimatePresence>
                {showProfileMenu && (
                  <motion.div
                    initial={{ opacity: 0, y: 5 }}
                    animate={{ opacity: 1, y: 0 }}
                    exit={{ opacity: 0, y: 5 }}
                    transition={{ duration: 0.2 }}
                    className="absolute right-0 mt-2 w-48 origin-top-right rounded-md border border-border bg-card shadow-lg"
                  >
                    <div className="p-2">
                      <div className="border-b border-border px-4 py-2">
                        <p className="text-sm font-medium">{userName}</p>
                        <p className="text-xs text-muted-foreground truncate">{email}</p>
                      </div>
                      <div className="py-1">
                        <Link
                          href="/dashboard/profile"
                          className="flex items-center px-4 py-2 text-sm hover:bg-accent rounded-md"
                          onClick={() => setShowProfileMenu(false)}
                        >
                          <User className="mr-2 h-4 w-4" />
                          Profile
                        </Link>
                        <div
                          className="flex items-center px-4 py-2 text-sm text-destructive hover:bg-accent rounded-md cursor-pointer"
                          onClick={handleLogOut}
                        >
                          <LogOut className="mr-2 h-4 w-4"/>
                          Sign out
                        </div>
                      </div>
                    </div>
                  </motion.div>
                )}
              </AnimatePresence>
            </div>
          </div>
        </nav>

        {/* Mobile navigation */}
        <AnimatePresence>
          {showMobileMenu && (
            <motion.div
              initial={{ opacity: 0, height: 0 }}
              animate={{ opacity: 1, height: "auto" }}
              exit={{ opacity: 0, height: 0 }}
              transition={{ duration: 0.2 }}
              className="fixed inset-x-0 top-16 z-50 border-b border-border bg-background md:hidden"
            >
              <div className="container py-4">
                <nav className="flex flex-col space-y-1">
                  {navLinks.map((link) => (
                    <Link
                      key={link.href}
                      href={link.href}
                      className={`flex items-center rounded-md px-3 py-2 text-sm font-medium ${
                        isActive(link.href) ? "bg-primary/10 text-primary" : "text-muted-foreground hover:bg-accent"
                      }`}
                      onClick={() => setShowMobileMenu(false)}
                    >
                      <link.icon className="mr-2 h-4 w-4" />
                      {link.name}
                    </Link>
                  ))}
                  <Link
                    href="/dashboard/profile"
                    className="flex items-center rounded-md px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-accent"
                    onClick={() => setShowMobileMenu(false)}
                  >
                    <User className="mr-2 h-4 w-4" />
                    Profile
                  </Link>
                  <div className="pt-2 border-t border-border mt-2">
                    <Link
                      href="/login"
                      className="flex items-center rounded-md px-3 py-2 text-sm font-medium text-destructive hover:bg-accent"
                      onClick={() => setShowMobileMenu(false)}
                    >
                      <LogOut className="mr-2 h-4 w-4" />
                      Sign out
                    </Link>
                  </div>
                </nav>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </header>
  )
}

