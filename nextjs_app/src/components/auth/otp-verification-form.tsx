"use client"

import type React from "react"

import { useState, useRef, useEffect } from "react"
import { motion } from "framer-motion"
import Link from "next/link"
import { Button } from "@/components/ui/button"
import { ArrowLeft } from "lucide-react"

export function OtpVerificationForm() {
  const [isLoading, setIsLoading] = useState(false)
  const [otp, setOtp] = useState(["", "", "", ""])
  const inputRefs = [
    useRef<HTMLInputElement>(null),
    useRef<HTMLInputElement>(null),
    useRef<HTMLInputElement>(null),
    useRef<HTMLInputElement>(null),
  ]

  const handleChange = (index: number, value: string) => {
    // Only allow numbers
    if (!/^\d*$/.test(value)) return

    const newOtp = [...otp]
    newOtp[index] = value.substring(0, 1)
    setOtp(newOtp)

    // Auto focus next input
    if (value && index < 3) {
      inputRefs[index + 1].current?.focus()
    }
  }

  const handleKeyDown = (index: number, e: React.KeyboardEvent<HTMLInputElement>) => {
    // Handle backspace
    if (e.key === "Backspace") {
      if (!otp[index] && index > 0) {
        const newOtp = [...otp]
        newOtp[index - 1] = ""
        setOtp(newOtp)
        inputRefs[index - 1].current?.focus()
      }
    }
  }

  const handlePaste = (e: React.ClipboardEvent<HTMLInputElement>) => {
    e.preventDefault()
    const pastedData = e.clipboardData.getData("text/plain").trim()

    // Check if pasted content is a 4-digit number
    if (/^\d{4}$/.test(pastedData)) {
      const digits = pastedData.split("")
      setOtp(digits)
      inputRefs[3].current?.focus()
    }
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (otp.join("").length !== 4) return

    setIsLoading(true)
    // Simulate API call
    setTimeout(() => {
      setIsLoading(false)
      // Redirect to login or dashboard
      window.location.href = "/login"
    }, 1500)
  }

  // Auto-focus first input on mount
  useEffect(() => {
    inputRefs[0].current?.focus()
  }, [])

  return (
    <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.4 }}>
      <form onSubmit={handleSubmit} className="space-y-6">
        <div className="text-center mb-6">
          <p className="text-sm text-muted-foreground">We've sent a 4-digit verification code to your email</p>
        </div>

        <div className="flex justify-center gap-3 mb-8">
          {otp.map((digit, index) => (
            <motion.div key={index} whileTap={{ scale: 0.97 }} className="w-14 h-16">
              <input
                ref={inputRefs[index]}
                type="text"
                inputMode="numeric"
                maxLength={1}
                value={digit}
                onChange={(e) => handleChange(index, e.target.value)}
                onKeyDown={(e) => handleKeyDown(index, e)}
                onPaste={index === 0 ? handlePaste : undefined}
                className="w-full h-full text-center text-2xl font-bold rounded-lg border border-input bg-background focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-all"
              />
            </motion.div>
          ))}
        </div>

        <Button type="submit" className="w-full h-12 text-base" disabled={isLoading || otp.join("").length !== 4}>
          {isLoading ? (
            <motion.div
              animate={{ rotate: 360 }}
              transition={{ duration: 1, repeat: Number.POSITIVE_INFINITY, ease: "linear" }}
              className="w-5 h-5 border-2 border-white border-t-transparent rounded-full"
            />
          ) : (
            "Verify Code"
          )}
        </Button>

        <div className="text-center mt-6 space-y-4">
          <p className="text-sm text-muted-foreground">
            Didn't receive the code?{" "}
            <button type="button" className="text-primary font-medium hover:underline transition-all">
              Resend
            </button>
          </p>

          <Link
            href="/login"
            className="text-sm text-primary font-medium hover:underline inline-flex items-center transition-all"
          >
            <ArrowLeft className="mr-2 h-4 w-4" />
            Back to login
          </Link>
        </div>
      </form>
    </motion.div>
  )
}

