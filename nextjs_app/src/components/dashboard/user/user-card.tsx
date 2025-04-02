'use client';

import { useState } from 'react';
import { motion } from 'framer-motion';
import { Heart, Trash2, MapPin, Phone, User } from 'lucide-react';
import { Button } from '@/components/ui/button';
import {
  Card,
  CardContent,
  CardFooter,
  CardHeader,
} from '@/components/ui/card';
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from '@/components/ui/alert-dialog';

interface UserCardProps {
  user: {
    id: string;
    name: string;
    city: string;
    phone: string;
    gender: string;
    isFavorite: boolean;
  };
  onToggleFavorite: () => void;
  onDelete: () => void;
}

export function UserCard({ user, onToggleFavorite, onDelete }: UserCardProps) {
  const [isHovered, setIsHovered] = useState(false);

  // Get first letter of name for avatar
  const firstLetter = user.name.charAt(0).toUpperCase();

  // Determine background color based on gender
  const avatarBgColor =
    user.gender === 'Male'
      ? 'bg-blue-100 text-blue-600'
      : 'bg-pink-100 text-pink-600';

  return (
    <motion.div
      whileHover={{ y: -5 }}
      transition={{ type: 'spring', stiffness: 300 }}
      onHoverStart={() => setIsHovered(true)}
      onHoverEnd={() => setIsHovered(false)}
    >
      <Card className="overflow-hidden border border-border">
        <CardHeader className="p-0">
          <div
            className={`h-24 flex items-center justify-center ${avatarBgColor}`}
          >
            <span className="text-5xl font-bold">{firstLetter}</span>
          </div>
        </CardHeader>
        <CardContent className="p-6">
          <div className="space-y-4">
            <div>
              <h3 className="text-xl font-semibold">{user.name}</h3>
              <p className="text-sm text-muted-foreground">{user.gender}</p>
            </div>

            <div className="space-y-2">
              <div className="flex items-center text-sm">
                <MapPin className="h-4 w-4 mr-2 text-muted-foreground" />
                <span>{user.city}</span>
              </div>
              <div className="flex items-center text-sm">
                <Phone className="h-4 w-4 mr-2 text-muted-foreground" />
                <span>{user.phone}</span>
              </div>
            </div>
          </div>
        </CardContent>
        <CardFooter className="p-4 pt-0 flex justify-between">
          <Button
            variant="ghost"
            size="icon"
            className={
              user.isFavorite
                ? 'text-red-500 hover:text-red-600'
                : 'text-muted-foreground hover:text-primary'
            }
            onClick={onToggleFavorite}
          >
            <Heart
              className={`h-5 w-5 ${user.isFavorite ? 'fill-current' : ''}`}
            />
          </Button>

          <AlertDialog>
            <AlertDialogTrigger asChild>
              <Button
                variant="ghost"
                size="icon"
                className="text-muted-foreground hover:text-red-500"
              >
                <Trash2 className="h-5 w-5" />
              </Button>
            </AlertDialogTrigger>
            <AlertDialogContent>
              <AlertDialogHeader>
                <AlertDialogTitle>Are you sure?</AlertDialogTitle>
                <AlertDialogDescription>
                  This action cannot be undone. This will permanently delete{' '}
                  {user.name}'s profile.
                </AlertDialogDescription>
              </AlertDialogHeader>
              <AlertDialogFooter>
                <AlertDialogCancel>Cancel</AlertDialogCancel>
                <AlertDialogAction
                  onClick={onDelete}
                  className="bg-red-500 hover:bg-red-600"
                >
                  Delete
                </AlertDialogAction>
              </AlertDialogFooter>
            </AlertDialogContent>
          </AlertDialog>
        </CardFooter>
      </Card>
    </motion.div>
  );
}
