"use client"

import type React from "react"

import Image from "next/image"
import { motion } from "framer-motion"
import { ThemeToggle } from "@/components/ui/theme-toggle"
import { useTheme } from "next-themes"
import { useEffect, useState } from "react"

interface AuthLayoutProps {
  children: React.ReactNode
  title: string
  subtitle: string
  image: string
  imageAlt: string
}

export function AuthLayout({ children, title, subtitle, image, imageAlt }: AuthLayoutProps) {
  const { theme } = useTheme()
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  const containerVariants = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: {
        staggerChildren: 0.1,
        delayChildren: 0.2,
      },
    },
  }

  const itemVariants = {
    hidden: { y: 20, opacity: 0 },
    visible: {
      y: 0,
      opacity: 1,
      transition: { type: "spring", stiffness: 100 },
    },
  }

  return (
    <div className="min-h-screen flex flex-col md:flex-row">
      {/* Image Section */}
      <motion.div
        initial={{ x: -100, opacity: 0 }}
        animate={{ x: 0, opacity: 1 }}
        transition={{ duration: 0.6, ease: "easeOut" }}
        className="hidden md:flex md:w-1/2 relative overflow-hidden"
      >
        <div className="absolute inset-0 bg-gradient-to-r from-primary/80 to-primary/40 z-10" />
        <Image
          src={image || "/placeholder.svg?height=1080&width=1080"}
          alt={imageAlt}
          fill
          className="object-cover"
          priority
        />
        <div className="absolute inset-0 z-20 flex flex-col justify-center items-center text-white p-12">
          <motion.div
            initial={{ y: 20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ delay: 0.5, duration: 0.8 }}
            className="max-w-md text-center"
          >
            <h1 className="text-4xl md:text-5xl font-bold mb-4">Find Your Perfect Match</h1>
            <p className="text-lg md:text-xl">
              Join thousands of couples who found their soulmate through our platform
            </p>
          </motion.div>
        </div>
      </motion.div>

      {/* Form Section */}
      <motion.div
        variants={containerVariants}
        initial="hidden"
        animate="visible"
        className="flex-1 flex flex-col p-6 md:p-12 justify-center items-center bg-background"
      >
        <div className="w-full max-w-md">
          <div className="flex justify-between items-center mb-8">
            <motion.div variants={itemVariants}>
              <h2 className="text-3xl font-bold text-primary">Matrimony</h2>
            </motion.div>
            {mounted && <ThemeToggle />}
          </div>

          <motion.div variants={itemVariants} className="mb-8">
            <h1 className="text-2xl md:text-3xl font-bold mb-2">{title}</h1>
            <p className="text-muted-foreground">{subtitle}</p>
          </motion.div>

          <motion.div variants={itemVariants}>{children}</motion.div>
        </div>
      </motion.div>
    </div>
  )
}

