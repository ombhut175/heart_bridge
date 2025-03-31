'use client';

import { useState } from 'react';
import { motion } from 'framer-motion';
import { Heart, Trash2, MapPin, Phone, UserIcon } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';

// Sample user data
const initialUsers = [
  {
    id: 1,
    name: 'Sophia Johnson',
    city: 'New York, NY',
    phone: '+1 (555) 123-4567',
    gender: 'Female',
    isFavorite: false,
  },
  {
    id: 2,
    name: 'Ethan Williams',
    city: 'Los Angeles, CA',
    phone: '+1 (555) 987-6543',
    gender: 'Male',
    isFavorite: true,
  },
  {
    id: 3,
    name: 'Olivia Davis',
    city: 'Chicago, IL',
    phone: '+1 (555) 456-7890',
    gender: 'Female',
    isFavorite: false,
  },
  {
    id: 4,
    name: 'Noah Martinez',
    city: 'Houston, TX',
    phone: '+1 (555) 234-5678',
    gender: 'Male',
    isFavorite: false,
  },
  {
    id: 5,
    name: 'Ava Thompson',
    city: 'Phoenix, AZ',
    phone: '+1 (555) 876-5432',
    gender: 'Female',
    isFavorite: true,
  },
  {
    id: 6,
    name: 'William Anderson',
    city: 'Philadelphia, PA',
    phone: '+1 (555) 345-6789',
    gender: 'Male',
    isFavorite: false,
  },
  {
    id: 7,
    name: 'Emma Garcia',
    city: 'San Antonio, TX',
    phone: '+1 (555) 654-3210',
    gender: 'Female',
    isFavorite: false,
  },
  {
    id: 8,
    name: 'James Rodriguez',
    city: 'San Diego, CA',
    phone: '+1 (555) 789-0123',
    gender: 'Male',
    isFavorite: true,
  },
];

type User = (typeof initialUsers)[0];

export function UsersList() {
  const [users, setUsers] = useState(initialUsers);
  const [searchTerm, setSearchTerm] = useState('');

  // Filter users based on search term
  const filteredUsers = users.filter(
    (user) =>
      user.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      user.city.toLowerCase().includes(searchTerm.toLowerCase()),
  );

  // Toggle favorite status
  const toggleFavorite = (userId: number) => {
    setUsers(
      users.map((user) =>
        user.id === userId ? { ...user, isFavorite: !user.isFavorite } : user,
      ),
    );
  };

  // Delete user
  const deleteUser = (userId: number) => {
    setUsers(users.filter((user) => user.id !== userId));
  };

  // Get avatar color based on gender
  const getAvatarColor = (gender: string) => {
    return gender === 'Female'
      ? 'bg-pink-100 text-pink-500 dark:bg-pink-950 dark:text-pink-300'
      : 'bg-blue-100 text-blue-500 dark:bg-blue-950 dark:text-blue-300';
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row gap-4 items-start sm:items-center justify-between">
        <div className="relative w-full sm:w-72">
          <Input
            type="text"
            placeholder="Search by name or city..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="pl-10"
          />
          <UserIcon className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
        </div>
        <div className="text-sm text-muted-foreground">
          Showing{' '}
          <span className="font-medium text-foreground">
            {filteredUsers.length}
          </span>{' '}
          users
        </div>
      </div>

      {filteredUsers.length === 0 ? (
        <div className="text-center py-12">
          <div className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-muted mb-4">
            <UserIcon className="h-8 w-8 text-muted-foreground" />
          </div>
          <h3 className="text-lg font-medium">No users found</h3>
          <p className="text-muted-foreground mt-1">
            Try adjusting your search terms
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredUsers.map((user) => (
            <UserCard
              key={user.id}
              user={user}
              onToggleFavorite={toggleFavorite}
              onDelete={deleteUser}
              avatarColor={getAvatarColor(user.gender)}
            />
          ))}
        </div>
      )}
    </div>
  );
}

interface UserCardProps {
  user: User;
  onToggleFavorite: (id: number) => void;
  onDelete: (id: number) => void;
  avatarColor: string;
}

function UserCard({
  user,
  onToggleFavorite,
  onDelete,
  avatarColor,
}: UserCardProps) {
  const [isHovering, setIsHovering] = useState(false);

  return (
    <motion.div
      layout
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, scale: 0.9 }}
      transition={{ duration: 0.2 }}
      className="bg-card rounded-lg border border-border overflow-hidden shadow-sm hover:shadow-md transition-shadow"
      onMouseEnter={() => setIsHovering(true)}
      onMouseLeave={() => setIsHovering(false)}
    >
      <div className="p-6">
        <div className="flex items-start justify-between">
          <div className="flex items-center space-x-4">
            <div
              className={`flex items-center justify-center w-12 h-12 rounded-full ${avatarColor}`}
            >
              <span className="text-lg font-semibold">
                {user.name.charAt(0)}
              </span>
            </div>
            <div>
              <h3 className="text-lg font-semibold">{user.name}</h3>
              <p className="text-sm text-muted-foreground">{user.gender}</p>
            </div>
          </div>
          <div className="flex space-x-1">
            <Button
              variant="ghost"
              size="icon"
              className={`h-8 w-8 rounded-full ${user.isFavorite ? 'text-red-500 hover:text-red-600' : 'text-muted-foreground hover:text-foreground'}`}
              onClick={() => onToggleFavorite(user.id)}
            >
              <Heart
                className="h-5 w-5"
                fill={user.isFavorite ? 'currentColor' : 'none'}
              />
              <span className="sr-only">
                {user.isFavorite ? 'Remove from favorites' : 'Add to favorites'}
              </span>
            </Button>
            <Button
              variant="ghost"
              size="icon"
              className="h-8 w-8 rounded-full text-muted-foreground hover:text-destructive"
              onClick={() => onDelete(user.id)}
            >
              <Trash2 className="h-5 w-5" />
              <span className="sr-only">Delete</span>
            </Button>
          </div>
        </div>

        <div className="mt-4 space-y-2">
          <div className="flex items-center text-sm">
            <MapPin className="h-4 w-4 mr-2 text-muted-foreground" />
            <span>{user.city}</span>
          </div>
          <div className="flex items-center text-sm">
            <Phone className="h-4 w-4 mr-2 text-muted-foreground" />
            <span>{user.phone}</span>
          </div>
        </div>

        <div className="mt-5 pt-4 border-t border-border flex justify-between">
          <Button variant="outline" size="sm" className="w-[48%]">
            Message
          </Button>
          <Button size="sm" className="w-[48%]">
            View Profile
          </Button>
        </div>
      </div>
    </motion.div>
  );
}
