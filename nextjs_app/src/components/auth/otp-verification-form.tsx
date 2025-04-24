'use client';

import {
  React,
  useState,
  useEffect,
  useRef,
  useRouter,
  useSearchParams,
  motion,
  AnimatePresence,
  Link,
  Button,
  ArrowLeft,
  CheckCircle,
  handleError,
  showLoadingBar,
  CONSTANTS,
  useGetStore,
} from "@/helpers/exports/frontend/auth";

import {getDecodedData} from "@/helpers/ui/utils";
import {handleOtpSubmit, handleResendOtp} from "@/services/functions/auth";
import {useVerifyOtp} from "@/hooks/auth";
import {otpDataInterface} from "@/helpers/interfaces";

export function OtpVerificationForm() {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(false);
  const [otp, setOtp] = useState(['', '', '', '']);
  const [isVerified, setIsVerified] = useState(false);
  // Add state for resend timer
  const [resendTimer, setResendTimer] = useState(0);
  const timerRef = useRef<NodeJS.Timeout | null>(null);
  
  const inputRefs = [
    useRef<HTMLInputElement>(null),
    useRef<HTMLInputElement>(null),
    useRef<HTMLInputElement>(null),
    useRef<HTMLInputElement>(null),
  ];

  const {
    trigger, isMutating, error
  } = useVerifyOtp();

  const {
    addUser,
  } = useGetStore();

  const searchParams = useSearchParams();
  const encodedData = searchParams.get(CONSTANTS.DATA);
  const otpData:otpDataInterface | null = encodedData ? getDecodedData(encodedData) : null;

  // Function to start the resend timer
  const startResendTimer = () => {
    setResendTimer(60);
    
    if (timerRef.current) {
      clearInterval(timerRef.current);
    }
    
    timerRef.current = setInterval(() => {
      setResendTimer(prev => {
        if (prev <= 1) {
          if (timerRef.current) {
            clearInterval(timerRef.current);
          }
          return 0;
        }
        return prev - 1;
      });
    }, 1000);
  };

  // Clean up timer on component unmount
  useEffect(() => {
    return () => {
      if (timerRef.current) {
        clearInterval(timerRef.current);
      }
    };
  }, []);

  const handleChange = (index: number, value: string) => {
    // Only allow numbers
    if (!/^\d*$/.test(value)) return;

    const newOtp = [...otp];
    newOtp[index] = value.substring(0, 1);
    setOtp(newOtp);

    // Auto focus next input
    if (value && index < 3) {
      inputRefs[index + 1].current?.focus();
    }
  };

  const handleKeyDown = (
    index: number,
    e: React.KeyboardEvent<HTMLInputElement>,
  ) => {
    // Handle backspace
    if (e.key === 'Backspace') {
      if (!otp[index] && index > 0) {
        const newOtp = [...otp];
        newOtp[index - 1] = '';
        setOtp(newOtp);
        inputRefs[index - 1].current?.focus();
      }
    }
  };

  const handlePaste = (e: React.ClipboardEvent<HTMLInputElement>) => {
    e.preventDefault();
    const pastedData = e.clipboardData.getData('text/plain').trim();

    // Check if pasted content is a 4-digit number
    if (/^\d{4}$/.test(pastedData)) {
      const digits = pastedData.split('');
      setOtp(digits);
      inputRefs[3].current?.focus();
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    setIsLoading(true);
    try {
      await handleOtpSubmit({ e, trigger, otp, otpData: otpData!, addUser, router });
    } catch (error) {
      setIsLoading(false);
      handleError(error);
    }
  };

  const onResendOtp = async () => {
    setIsLoading(true);
    try {
      await handleResendOtp(otpData!, startResendTimer);
    } catch (error) {
      handleError(error);
    } finally {
      setIsLoading(false);
    }
  };

  // Auto-focus first input on mount
  useEffect(() => {
    inputRefs[0].current?.focus();

    if (!otpData) {
      handleError("url is not valid");
      router.replace('/login');
    }
  }, []);

  if (error) handleError(error);

  // Remove the showLoadingBar() and handle loading state within the component

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4 }}
      className="relative"
    >
      <AnimatePresence mode="wait">
        {!isVerified ? (
          <motion.form
            key="otp-form"
            onSubmit={handleSubmit}
            className="space-y-6"
            exit={{ opacity: 0, y: -20 }}
          >
            <div className="text-center mb-6">
              <p className="text-sm text-muted-foreground">
                We've sent a 4-digit verification code to your email
              </p>
            </div>

            <div className="flex justify-center gap-3 mb-8">
              {otp.map((digit, index) => (
                <motion.div
                  key={index}
                  whileTap={{ scale: 0.97 }}
                  whileFocus={{ scale: 1.05 }}
                  className="w-14 h-16"
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: index * 0.1 + 0.2 }}
                >
                  <input
                    ref={inputRefs[index]}
                    type="text"
                    inputMode="numeric"
                    maxLength={1}
                    value={digit}
                    onChange={(e) => handleChange(index, e.target.value)}
                    onKeyDown={(e) => handleKeyDown(index, e)}
                    onPaste={index === 0 ? handlePaste : undefined}
                    className="w-full h-full text-center text-2xl font-bold rounded-lg border border-input bg-background focus:border-primary focus:ring-2 focus:ring-primary/30 outline-none transition-all"
                  />
                </motion.div>
              ))}
            </div>

            <motion.div
              whileHover={{ scale: isLoading || isMutating ? 1 : 1.01 }}
              whileTap={{ scale: isLoading || isMutating ? 1 : 0.99 }}
              transition={{ type: 'spring', stiffness: 400, damping: 10 }}
            >
              <Button
                type="submit"
                className={`w-full h-12 text-base relative overflow-hidden group ${
                  (isLoading || isMutating || otp.join('').length !== 4) ? 'opacity-70 cursor-not-allowed' : ''
                }`}
                disabled={isLoading || isMutating || otp.join('').length !== 4}
              >
                <span className="relative z-10">
                  {(isLoading || isMutating) ? (
                    <motion.div
                      animate={{ rotate: 360 }}
                      transition={{
                        duration: 1,
                        repeat: Number.POSITIVE_INFINITY,
                        ease: 'linear',
                      }}
                      className="w-5 h-5 border-2 border-white border-t-transparent rounded-full"
                    />
                  ) : (
                    'Verify OTP'
                  )}
                </span>
                <span className={`absolute inset-0 bg-gradient-to-r from-primary to-primary/80 z-0 ${
                  (isLoading || isMutating) ? 'opacity-50' : 'opacity-0 group-hover:opacity-100'
                } transition-opacity duration-300`} />
              </Button>
            </motion.div>

            {/* Resend OTP section */}
            <div className="text-center mt-6">
              <p className="text-sm text-muted-foreground">
                Didn't receive the code?{' '}
                {resendTimer > 0 ? (
                  <span className="text-muted-foreground">
                    Resend in {resendTimer}s
                  </span>
                ) : (
                  <motion.button
                    type="button"
                    onClick={onResendOtp}
                    className={`text-primary font-medium hover:underline ${
                      isLoading || isMutating ? 'opacity-50 cursor-not-allowed' : ''
                    }`}
                    disabled={isLoading || isMutating}
                    whileHover={{ scale: isLoading || isMutating ? 1 : 1.05 }}
                    whileTap={{ scale: isLoading || isMutating ? 1 : 0.95 }}
                  >
                    Resend OTP
                  </motion.button>
                )}
              </p>
            </div>
          </motion.form>
        ) : (
          <motion.div
            key="success"
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ type: 'spring', stiffness: 100, damping: 15 }}
            className="text-center py-10"
          >
            <motion.div
              className="mx-auto w-20 h-20 bg-green-100 dark:bg-green-900/30 rounded-full flex items-center justify-center mb-6"
              initial={{ scale: 0.5, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              transition={{
                type: 'spring',
                stiffness: 200,
                damping: 15,
                delay: 0.2,
              }}
            >
              <CheckCircle className="h-10 w-10 text-green-600 dark:text-green-400" />
            </motion.div>

            <motion.h3
              className="text-xl font-semibold mb-2"
              initial={{ y: 20, opacity: 0 }}
              animate={{ y: 0, opacity: 1 }}
              transition={{ delay: 0.3 }}
            >
              Verification Successful
            </motion.h3>

            <motion.p
              className="text-muted-foreground"
              initial={{ y: 20, opacity: 0 }}
              animate={{ y: 0, opacity: 1 }}
              transition={{ delay: 0.4 }}
            >
              Redirecting you to login...
            </motion.p>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  );
}
