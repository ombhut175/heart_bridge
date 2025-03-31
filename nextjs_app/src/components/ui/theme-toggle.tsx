"use client"

import { useTheme } from "next-themes"
import { useEffect, useState } from "react"
import { motion } from "framer-motion"
import { Moon, Sun } from "lucide-react"

export function ThemeToggle() {
  const { theme, setTheme } = useTheme()
  const [mounted, setMounted] = useState(false)

  // Avoid hydration mismatch
  useEffect(() => {
    setMounted(true)
  }, [])

  if (!mounted) {
    return null
  }

  const isDark = theme === "dark"

  return (
    <motion.button
      whileHover={{ scale: 1.05 }}
      whileTap={{ scale: 0.95 }}
      onClick={() => setTheme(isDark ? "light" : "dark")}
      className="relative h-10 w-10 rounded-full bg-muted flex items-center justify-center overflow-hidden"
      aria-label="Toggle theme"
    >
      <div className="relative w-full h-full">
        {/* Sun icon */}
        <motion.div
          className="absolute inset-0 flex items-center justify-center"
          initial={isDark ? { y: 0 } : { y: -30 }}
          animate={isDark ? { y: -30 } : { y: 0 }}
          transition={{ type: "spring", stiffness: 300, damping: 25 }}
        >
          <Sun className="h-5 w-5 text-yellow-500" />
        </motion.div>

        {/* Moon icon */}
        <motion.div
          className="absolute inset-0 flex items-center justify-center"
          initial={isDark ? { y: 30 } : { y: 0 }}
          animate={isDark ? { y: 0 } : { y: 30 }}
          transition={{ type: "spring", stiffness: 300, damping: 25 }}
        >
          <Moon className="h-5 w-5 text-blue-300" />
        </motion.div>
      </div>
    </motion.button>
  )
}

