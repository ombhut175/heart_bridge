'use client';

import {
  React,
  useState,
  useRouter,
  motion,
  Link,
  Input,
  Button,
  Label,
  ArrowLeft,
  Mail,
  Lock,
  CheckCircle,
  Eye,
  EyeOff,
  handleError,
  showLoadingBar,
} from "@/helpers/exports/frontend/auth";
import {handleForgotPasswordSubmit} from "@/services/functions/auth";
import {useForgotPassword} from "@/hooks/auth";

export function ForgotPasswordForm() {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(false);
  const [emailSent, setEmailSent] = useState(false);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [passwordError, setPasswordError] = useState('');
  const [showPassword, setShowPassword] = useState(false);

  const {
    trigger, isMutating, error
  } = useForgotPassword();

  const validatePassword = (value: string) => {
    if (value.length < 6) {
      setPasswordError('Password must be at least 6 characters');
      return false;
    }
    setPasswordError('');
    return true;
  };

  const handlePasswordChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value;
    setPassword(value);
    validatePassword(value);
  };

  const togglePasswordVisibility = () => {
    setShowPassword(!showPassword);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    try {
      await handleForgotPasswordSubmit({ 
        e, 
        trigger, 
        email, 
        password, 
        validatePassword, 
        setIsLoading, 
        router 
      });
    } catch (error) {
      setIsLoading(false);
      handleError(error);
    }
  };

  if (error) handleError(error);

  // Remove the showLoadingBar() and handle loading state within the component

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4 }}
    >
      {!emailSent ? (
        <form onSubmit={handleSubmit} className="space-y-6">
          <div className="space-y-2">
            <Label
              htmlFor="email"
              className="text-base flex items-center gap-2"
            >
              <Mail className="h-4 w-4 text-muted-foreground" />
              Email
            </Label>
            <div className="relative group">
              <Input
                id="email"
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="Enter your email"
                required
                className="h-12 transition-all duration-300 border-input group-hover:border-primary/50 focus:border-primary"
              />
              <motion.span
                className="absolute bottom-0 left-0 h-[2px] bg-primary rounded-full"
                initial={{ width: 0 }}
                animate={{ width: email ? '100%' : 0 }}
                transition={{ duration: 0.3 }}
              />
            </div>
            <p className="text-sm text-muted-foreground mt-1">
              We'll send you a verification code to reset your password
            </p>
          </div>

          <div className="space-y-2">
            <Label
              htmlFor="password"
              className="text-base flex items-center gap-2"
            >
              <Lock className="h-4 w-4 text-muted-foreground" />
              New Password
            </Label>
            <div className="relative group">
              <Input
                id="password"
                type={showPassword ? "text" : "password"}
                value={password}
                onChange={handlePasswordChange}
                placeholder="Enter new password"
                required
                className="h-12 transition-all duration-300 border-input group-hover:border-primary/50 focus:border-primary pr-10"
              />
              <button
                type="button"
                onClick={togglePasswordVisibility}
                className="absolute right-3 top-1/2 transform -translate-y-1/2 text-muted-foreground hover:text-foreground"
              >
                {showPassword ? (
                  <EyeOff className="h-5 w-5" />
                ) : (
                  <Eye className="h-5 w-5" />
                )}
              </button>
              <motion.span
                className="absolute bottom-0 left-0 h-[2px] bg-primary rounded-full"
                initial={{ width: 0 }}
                animate={{ width: password ? '100%' : 0 }}
                transition={{ duration: 0.3 }}
              />
            </div>
            {passwordError && (
              <p className="text-sm text-red-500 mt-1">{passwordError}</p>
            )}
            <p className="text-sm text-muted-foreground mt-1">
              Password must be at least 6 characters long
            </p>
          </div>

          <motion.div
            whileHover={{ scale: isLoading || isMutating ? 1 : 1.01 }}
            whileTap={{ scale: isLoading || isMutating ? 1 : 0.99 }}
            transition={{ type: 'spring', stiffness: 400, damping: 10 }}
          >
            <Button
              type="submit"
              className={`w-full h-12 text-base relative overflow-hidden group ${
                (isLoading || isMutating || password.length < 6) ? 'opacity-70 cursor-not-allowed' : ''
              }`}
              disabled={isLoading || isMutating || password.length < 6}
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
                  'Reset Password'
                )}
              </span>
              <span className={`absolute inset-0 bg-gradient-to-r from-primary to-primary/80 z-0 ${
                (isLoading || isMutating) ? 'opacity-50' : 'opacity-0 group-hover:opacity-100'
              } transition-opacity duration-300`} />
            </Button>
          </motion.div>

          <div className="text-center mt-6">
            <motion.div
              whileHover={{ x: -3 }}
              whileTap={{ scale: 0.97 }}
              transition={{ type: 'spring', stiffness: 400, damping: 10 }}
            >
              <Link
                href="/login"
                className="text-sm text-primary font-medium hover:underline inline-flex items-center transition-all"
              >
                <ArrowLeft className="mr-2 h-4 w-4" />
                Back to login
              </Link>
            </motion.div>
          </div>
        </form>
      ) : (
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ type: 'spring', stiffness: 100, damping: 15 }}
          className="text-center py-6"
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
            Check your email
          </motion.h3>

          <motion.p
            className="text-muted-foreground mb-8"
            initial={{ y: 20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ delay: 0.4 }}
          >
            We've sent a password reset code to your email address
          </motion.p>

          <motion.div
            initial={{ y: 20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ delay: 0.5 }}
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
          >
            <Button
              onClick={() => (window.location.href = '/verify-otp')}
              className="w-full h-12 relative overflow-hidden group"
            >
              <span className="relative z-10">Enter verification code</span>
              <span className="absolute inset-0 bg-gradient-to-r from-primary to-primary/80 z-0 opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
            </Button>
          </motion.div>

          <motion.p
            className="mt-6 text-sm text-muted-foreground"
            initial={{ y: 20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ delay: 0.6 }}
          >
            Didn't receive the email?{' '}
            <motion.button
              onClick={() => setEmailSent(false)}
              className="text-primary font-medium hover:underline"
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
            >
              Click to resend
            </motion.button>
          </motion.p>
        </motion.div>
      )}
    </motion.div>
  );
}
