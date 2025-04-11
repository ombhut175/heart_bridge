'use client';

import React, {useEffect} from 'react';
import {useState} from 'react';
import {motion} from 'framer-motion';
import Link from 'next/link';
import {Input} from '@/components/ui/input';
import {Button} from '@/components/ui/button';
import {Label} from '@/components/ui/label';
import {Checkbox} from '@/components/ui/checkbox';
import {EyeIcon, EyeOffIcon, User, Mail, Lock} from 'lucide-react';
import useSWRMutation from "swr/mutation";
import {handleError, postRequest} from "@/helpers/ui/handlers";
import {showLoadingBar} from "@/helpers/ui/uiHelpers";
import {ConstantsForMainUser} from "@/helpers/string_const";
import {useRouter} from "next/navigation";
import {otpDataInterface} from "@/helpers/interfaces";
import {toast} from "react-toastify";
import {AxiosError} from "axios";
import {getEncodedUrl} from "@/helpers/ui/utils";

const signUpFetcher = async (url: string, {arg}: {
    arg: { email: string; password: string; username: string; }
}) => {
    return await postRequest(url, {
        [ConstantsForMainUser.ADMIN_EMAIL]: arg.email,
        [ConstantsForMainUser.PASSWORD]: arg.password,
        [ConstantsForMainUser.USER_NAME]: arg.username,
    });
}


export function SignupForm() {
    const router = useRouter();
    const [isLoading, setIsLoading] = useState(false);
    const [showPassword, setShowPassword] = useState(false);
    const [formState, setFormState] = useState({
        username: '',
        email: '',
        password: '',
    });

    const {
        trigger, isMutating, error
    } = useSWRMutation('/api/sign-up', signUpFetcher,{
        throwOnError: true,
    });

    useEffect(() => {
        toast("Welcome ");
    },[]);

    console.log("::: signup form :::");

    if (error) handleError(error);

    if (isMutating) return showLoadingBar();

    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        setFormState({
            ...formState,
            [e.target.id]: e.target.value,
        });
    };




    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault(); // Prevent default form submission behavior
        
        try {
            setIsLoading(true); // Set loading state
            
            const response = await trigger({
                email: formState.email,
                password: formState.password,
                username: formState.username,
            });

            const data: otpDataInterface = {
                [ConstantsForMainUser.VERIFICATION_TYPE]: ConstantsForMainUser.SIGN_UP,
                [ConstantsForMainUser.ADMIN_EMAIL]: formState.email,
                [ConstantsForMainUser.USER_NAME]: formState.username,
            };

            const encodedUrl = getEncodedUrl({
                data,
                route: '/verify-otp'
            });
            
            // Navigate to OTP verification page

            router.replace(encodedUrl);

        } catch (error:AxiosError | any) {
            handleError(error);
        } finally {
            setIsLoading(false); // Reset loading state
        }
    };

    return (
        <motion.div
            initial={{opacity: 0, y: 10}}
            animate={{opacity: 1, y: 0}}
            transition={{duration: 0.4}}
        >
            <form onSubmit={handleSubmit} className="space-y-5">
                <div className="space-y-2">
                    <Label
                        htmlFor="username"
                        className="text-base flex items-center gap-2"
                    >
                        <User className="h-4 w-4 text-muted-foreground"/>
                        Full Name
                    </Label>
                    <div className="relative group">
                        <Input
                            id="username"
                            type="text"
                            value={formState.username}
                            onChange={handleChange}
                            placeholder="Enter your full name"
                            required
                            className="h-12 transition-all duration-300 border-input group-hover:border-primary/50 focus:border-primary"
                        />
                        <motion.span
                            className="absolute bottom-0 left-0 h-[2px] bg-primary rounded-full"
                            initial={{width: 0}}
                            animate={{width: formState.username ? '100%' : 0}}
                            transition={{duration: 0.3}}
                        />
                    </div>
                </div>

                <div className="space-y-2">
                    <Label htmlFor="email" className="text-base flex items-center gap-2">
                        <Mail className="h-4 w-4 text-muted-foreground"/>
                        Email
                    </Label>
                    <div className="relative group">
                        <Input
                            id="email"
                            type="email"
                            value={formState.email}
                            onChange={handleChange}
                            placeholder="Enter your email"
                            required
                            className="h-12 transition-all duration-300 border-input group-hover:border-primary/50 focus:border-primary"
                        />
                        <motion.span
                            className="absolute bottom-0 left-0 h-[2px] bg-primary rounded-full"
                            initial={{width: 0}}
                            animate={{width: formState.email ? '100%' : 0}}
                            transition={{duration: 0.3}}
                        />
                    </div>
                </div>

                <div className="space-y-2">
                    <Label
                        htmlFor="password"
                        className="text-base flex items-center gap-2"
                    >
                        <Lock className="h-4 w-4 text-muted-foreground"/>
                        Password
                    </Label>
                    <div className="relative group">
                        <Input
                            id="password"
                            type={showPassword ? 'text' : 'password'}
                            value={formState.password}
                            onChange={handleChange}
                            placeholder="Create a password"
                            required
                            className="h-12 pr-10 transition-all duration-300 border-input group-hover:border-primary/50 focus:border-primary"
                        />
                        <button
                            type="button"
                            onClick={() => setShowPassword(!showPassword)}
                            className="absolute right-3 top-1/2 transform -translate-y-1/2 text-muted-foreground hover:text-foreground transition-colors"
                        >
                            {showPassword ? (
                                <EyeOffIcon className="h-5 w-5"/>
                            ) : (
                                <EyeIcon className="h-5 w-5"/>
                            )}
                        </button>
                        <motion.span
                            className="absolute bottom-0 left-0 h-[2px] bg-primary rounded-full"
                            initial={{width: 0}}
                            animate={{width: formState.password ? '100%' : 0}}
                            transition={{duration: 0.3}}
                        />
                    </div>
                    <p className="text-xs text-muted-foreground mt-1">
                        Password must be at least 8 characters long
                    </p>
                </div>

                <div className="flex items-start space-x-2 pt-2">
                    <Checkbox
                        id="terms"
                        className="mt-1 data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground"
                        required
                    />
                    <Label htmlFor="terms" className="text-sm font-normal">
                        I agree to the{' '}
                        <motion.span
                            whileHover={{scale: 1.05}}
                            whileTap={{scale: 0.95}}
                            className="inline-block"
                        >
                            <Link
                                href="/terms"
                                className="text-primary hover:underline transition-all"
                            >
                                Terms of Service
                            </Link>
                        </motion.span>
                        {' '}
                        and{' '}
                        <motion.span
                            whileHover={{scale: 1.05}}
                            whileTap={{scale: 0.95}}
                            className="inline-block"
                        >
                            <Link
                                href="/privacy"
                                className="text-primary hover:underline transition-all"
                            >
                                Privacy Policy
                            </Link>
                        </motion.span>
                    </Label>
                </div>

                <motion.div
                    whileHover={{scale: 1.01}}
                    whileTap={{scale: 0.99}}
                    transition={{type: 'spring', stiffness: 400, damping: 10}}
                    className="mt-2"
                >
                    <Button
                        type="submit"
                        className="w-full h-12 text-base relative overflow-hidden group"
                        disabled={isLoading}
                    >
            <span className="relative z-10">
              {isLoading ? (
                  <motion.div
                      animate={{rotate: 360}}
                      transition={{
                          duration: 1,
                          repeat: Number.POSITIVE_INFINITY,
                          ease: 'linear',
                      }}
                      className="w-5 h-5 border-2 border-white border-t-transparent rounded-full"
                  />
              ) : (
                  'Create Account'
              )}
            </span>
                        <span
                            className="absolute inset-0 bg-gradient-to-r from-primary to-primary/80 z-0 opacity-0 group-hover:opacity-100 transition-opacity duration-300"/>
                    </Button>
                </motion.div>

                <div className="text-center mt-6">
                    <p className="text-sm text-muted-foreground">
                        Already have an account?{' '}
                        <motion.span
                            whileHover={{scale: 1.05}}
                            whileTap={{scale: 0.95}}
                            className="inline-block"
                        >
                            <Link
                                href="/login"
                                className="text-primary font-medium hover:underline transition-all"
                            >
                                Sign in
                            </Link>
                        </motion.span>
                    </p>
                </div>
            </form>
        </motion.div>
    );
}
