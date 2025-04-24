// React & Next
export type React = typeof import('react');
export { useState, useEffect, useRef } from 'react';
export { useRouter, useSearchParams } from 'next/navigation';
export { default as Link }
    from 'next/link';

// Framer Motion
export { motion, AnimatePresence } from 'framer-motion';

// UI Components
export { Input } from '@/components/ui/input';
export { Button } from '@/components/ui/button';
export { Label } from '@/components/ui/label';
export { Checkbox } from '@/components/ui/checkbox';

// Icons from lucide-react
export {
    ArrowLeft,
    Mail,
    Lock,
    CheckCircle,
    Eye,
    EyeOff,
    EyeIcon,
    EyeOffIcon,
    User
} from 'lucide-react';

// Helpers
export { handleError } from '@/helpers/ui/handlers';
export { showLoadingBar } from '@/helpers/ui/uiHelpers';

// Constants & Interfaces
export { RouteConst, CONSTANTS, ConstantsForMainUser } from '@/helpers/string_const';


// Hooks
export { useGetStore } from '@/hooks/store';

// Toast
export { toast } from 'react-toastify';
