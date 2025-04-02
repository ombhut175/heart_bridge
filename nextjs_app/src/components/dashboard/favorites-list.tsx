"use client"

import { useState } from "react"
import { motion } from "framer-motion"
import { Heart, MapPin, Phone } from "lucide-react"
import { Button } from "@/components/ui/button"

// Sample favorite users data
const initialFavorites = [
  {
    id: 2,
    name: "Ethan Williams",
    city: "Los Angeles, CA",
    phone: "+1 (555) 987-6543",
    gender: "Male",
    isFavorite: true,
  },
  {
    id: 5,
    name: "Ava Thompson",
    city: "Phoenix, AZ",
    phone: "+1 (555) 876-5432",
    gender: "Female",
    isFavorite: true,
  },
  {
    id: 8,
    name: "James Rodriguez",
    city: "San Diego, CA",
    phone: "+1 (555) 789-0123",
    gender: "Male",
    isFavorite: true,
  },
]

type User = (typeof initialFavorites)[0]

export function FavoritesList() {
  const [favorites, setFavorites] = useState(initialFavorites)

  // Remove from favorites
  const removeFromFavorites = (userId: number) => {
    setFavorites(favorites.filter((user) => user.id !== userId))
  }

  // Get avatar color based on gender
  const getAvatarColor = (gender: string) => {
    return gender === "Female"
      ? "bg-pink-100 text-pink-500 dark:bg-pink-950 dark:text-pink-300"
      : "bg-blue-100 text-blue-500 dark:bg-blue-950 dark:text-blue-300"
  }

  return (
    <div className="space-y-6">
      {favorites.length === 0 ? (
        <div className="text-center py-12">
          <div className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-muted mb-4">
            <Heart className="h-8 w-8 text-muted-foreground" />
          </div>
          <h3 className="text-lg font-medium">No favorites yet</h3>
          <p className="text-muted-foreground mt-1">Add profiles to your favorites to see them here</p>
          <Button className="mt-4" asChild>
            <a href="/dashboard/users">Browse Users</a>
          </Button>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {favorites.map((user) => (
            <FavoriteCard
              key={user.id}
              user={user}
              onRemove={removeFromFavorites}
              avatarColor={getAvatarColor(user.gender)}
            />
          ))}
        </div>
      )}
    </div>
  )
}

interface FavoriteCardProps {
  user: User
  onRemove: (id: number) => void
  avatarColor: string
}

function FavoriteCard({ user, onRemove, avatarColor }: FavoriteCardProps) {
  return (
    <motion.div
      layout
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, scale: 0.9 }}
      transition={{ duration: 0.2 }}
      className="bg-card rounded-lg border border-border overflow-hidden shadow-sm hover:shadow-md transition-shadow"
    >
      <div className="p-6">
        <div className="flex items-start justify-between">
          <div className="flex items-center space-x-4">
            <div className={`flex items-center justify-center w-12 h-12 rounded-full ${avatarColor}`}>
              <span className="text-lg font-semibold">{user.name.charAt(0)}</span>
            </div>
            <div>
              <h3 className="text-lg font-semibold">{user.name}</h3>
              <p className="text-sm text-muted-foreground">{user.gender}</p>
            </div>
          </div>
          <Button
            variant="ghost"
            size="icon"
            className="h-8 w-8 rounded-full text-red-500 hover:text-red-600"
            onClick={() => onRemove(user.id)}
          >
            <Heart className="h-5 w-5" fill="currentColor" />
            <span className="sr-only">Remove from favorites</span>
          </Button>
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
  )
}

