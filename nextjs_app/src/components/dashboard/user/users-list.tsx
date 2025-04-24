"use client"

import React, {useEffect} from "react"

import { useState } from "react"
import { motion } from "framer-motion"
import { Heart, Trash2, MapPin, Phone, UserIcon, Plus, Mail, Calendar } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import {AddUserDialog} from "@/components/dashboard/user/add-user-dialog";
import {getRequest, handleError, handleResponse, patchRequest} from "@/helpers/ui/handlers";
import useSWR, {mutate} from "swr";
import {showLoadingBar} from "@/helpers/ui/uiHelpers";
import {useGetUsers} from "@/hooks/store";
import {MatrimonyUserType} from "@/types/store/user";
// Add these imports for the confirmation dialog
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import {axiosInstance} from "@/services/fetcher";
import { useRouter } from "next/navigation"

const userFetcher = async (url: string) => await getRequest(url);



// Sample user data matching backend schema
const initialUsers = [
  {
    _id: 1,
    fullName: "Sophia Johnson",
    email: "sophia.j@example.com",
    mobileNumber: "5551234567",
    dob: "1992-05-15",
    gender: "Female",
    city: "New York, NY",
    hobbies: "Reading, Hiking",
    createdAt: "2023-01-15",
    createdByAdminEmail: "admin@example.com",
    isFavourite: false,
  },
  {
    id: 2,
    fullName: "Ethan Williams",
    email: "ethan.w@example.com",
    mobileNumber: "5559876543",
    dob: "1990-08-22",
    gender: "Male",
    city: "Los Angeles, CA",
    hobbies: "Photography, Surfing",
    createdAt: "2023-01-20",
    createdByAdminEmail: "admin@example.com",
    isFavourite: true,
  },
  {
    id: 3,
    fullName: "Olivia Davis",
    email: "olivia.d@example.com",
    mobileNumber: "5554567890",
    dob: "1995-03-10",
    gender: "Female",
    city: "Chicago, IL",
    hobbies: "Painting, Yoga",
    createdAt: "2023-02-05",
    createdByAdminEmail: "admin@example.com",
    isFavourite: false,
  },
  {
    id: 4,
    fullName: "Noah Martinez",
    email: "noah.m@example.com",
    mobileNumber: "5552345678",
    dob: "1988-11-30",
    gender: "Male",
    city: "Houston, TX",
    hobbies: "Gaming, Cooking",
    createdAt: "2023-02-10",
    createdByAdminEmail: "admin@example.com",
    isFavourite: false,
  },
  {
    id: 5,
    fullName: "Ava Thompson",
    email: "ava.t@example.com",
    mobileNumber: "5558765432",
    dob: "1993-07-25",
    gender: "Female",
    city: "Phoenix, AZ",
    hobbies: "Dancing, Traveling",
    createdAt: "2023-02-15",
    createdByAdminEmail: "admin@example.com",
    isFavourite: true,
  },
  {
    id: 6,
    fullName: "William Anderson",
    email: "william.a@example.com",
    mobileNumber: "5553456789",
    dob: "1991-04-18",
    gender: "Male",
    city: "Philadelphia, PA",
    hobbies: "Running, Music",
    createdAt: "2023-03-01",
    createdByAdminEmail: "admin@example.com",
    isFavourite: false,
  },
  {
    id: 7,
    fullName: "Emma Garcia",
    email: "emma.g@example.com",
    mobileNumber: "5556543210",
    dob: "1994-09-12",
    gender: "Female",
    city: "San Antonio, TX",
    hobbies: "Writing, Swimming",
    createdAt: "2023-03-10",
    createdByAdminEmail: "admin@example.com",
    isFavourite: false,
  },
  {
    id: 8,
    fullName: "James Rodriguez",
    email: "james.r@example.com",
    mobileNumber: "5557890123",
    dob: "1989-12-05",
    gender: "Male",
    city: "San Diego, CA",
    hobbies: "Basketball, Fishing",
    createdAt: "2023-03-15",
    createdByAdminEmail: "admin@example.com",
    isFavourite: true,
  },
]


interface UsersListProps {
  isFavourite?: boolean;
}

export function UsersList({ isFavourite = false }: UsersListProps) {
  const router = useRouter();
  const [searchTerm, setSearchTerm] = useState("")
  const [isAddUserOpen, setIsAddUserOpen] = useState(false);
  const [editingUser, setEditingUser] = useState<MatrimonyUserType | null>(null);
  const [isEditUserOpen, setIsEditUserOpen] = useState(false);
  // Add loading states for actions
  const [loadingFavoriteId, setLoadingFavoriteId] = useState<number | null>(null);
  const [loadingDeleteId, setLoadingDeleteId] = useState<number | null>(null);
  
  const handleEditUser = (user: MatrimonyUserType) => {
    setEditingUser(user)
    setIsEditUserOpen(true)
  }

  const {
    data,
      error,
      isLoading,
  } = useSWR('/api/user',userFetcher);

  const {
    users,
      setUsers,
  } = useGetUsers();


  useEffect(() => {
    if (data && data.body && data.body.length>0) {
      setUsers(data.body);
    }
  }, [data]);


  console.log("::: users :::");
  

  // Filter users based on search term and favorite status if needed
  const filteredUsers = users && users.length>0? users.filter(
      (user) => {
        // First filter by favorite status if isFavourite prop is true
        if (isFavourite && user.isFavourite !== 1) {
          return false;
        }
        
        // Then filter by search term
        return user.fullName.toLowerCase().includes(searchTerm.toLowerCase()) ||
          user.city.toLowerCase().includes(searchTerm.toLowerCase()) ||
          user.email.toLowerCase().includes(searchTerm.toLowerCase())
      }
  ) : [];

  // Toggle favorite status
  const toggleFavorite = async (userId: number) => {
    try {
      setLoadingFavoriteId(userId); // Set loading state for this specific user
      const response = await patchRequest(`/api/user/toggleFavourite/${userId}`);
      refetchUsers();
    } catch (error) {
      handleError(error);
    } finally {
      setLoadingFavoriteId(null); // Clear loading state when done
    }
  }

  const refetchUsers = () => {
    mutate("/api/user");
  };

  // Delete user
  const deleteUser = async (userId: number) => {

    console.log("::: delete user :::");

    try {
      setLoadingDeleteId(userId); // Set loading state for this specific user
      const response = await axiosInstance.delete(`/api/user/${userId}`);
      handleResponse(response);
      refetchUsers();
    } catch (error) {
      handleError(error);
    } finally {
      setLoadingDeleteId(null); // Clear loading state when done
    }

  }

  // Get avatar color based on gender
  const getAvatarColor = (gender: string) => {
    return gender === "Female"
        ? "bg-pink-100 text-pink-500 dark:bg-pink-950 dark:text-pink-300"
        : "bg-blue-100 text-blue-500 dark:bg-blue-950 dark:text-blue-300"
  }


  // Add this useEffect to handle errors
  useEffect(() => {
    if (error) {
      handleError(error);
      router.replace('/login');
    }
  }, [error, router]);
  
  // Remove the direct error handling in render
  // if (error) {
  //   handleError(error);
  //   router.replace('/login');
  // };
  
  if (isLoading) return showLoadingBar();

  return (
      <div className="space-y-6">
        <div className="flex flex-col sm:flex-row gap-4 items-start sm:items-center justify-between">
          <div className="relative w-full sm:w-72">
            <Input
                type="text"
                placeholder="Search by name, email or city..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="pl-10"
            />
            <UserIcon className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          </div>
          <div className="flex items-center gap-3">
            <div className="text-sm text-muted-foreground">
              Showing <span className="font-medium text-foreground">{filteredUsers.length}</span> {isFavourite ? "favorite" : ""} users
            </div>
            {!isFavourite && (
              <Button onClick={() => setIsAddUserOpen(true)} className="flex items-center gap-2">
                <Plus className="h-4 w-4" />
                Add User
              </Button>
            )}
          </div>
        </div>

        {filteredUsers.length === 0 ? (
            <div className="text-center py-12">
              <div className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-muted mb-4">
                <UserIcon className="h-8 w-8 text-muted-foreground" />
              </div>
              <h3 className="text-lg font-medium">No {isFavourite ? "favorite" : ""} users found</h3>
              <p className="text-muted-foreground mt-1">
                {isFavourite 
                  ? "Try adding some users to your favorites" 
                  : "Try adjusting your search terms"}
              </p>
            </div>
        ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {filteredUsers.map((user) => (
                  <UserCard
                      key={user._id}
                      user={user}
                      onToggleFavorite={toggleFavorite}
                      onDelete={deleteUser}
                      avatarColor={getAvatarColor(user.gender)}
                      onEdit={handleEditUser}
                      isLoadingFavorite={loadingFavoriteId === user._id}
                      isLoadingDelete={loadingDeleteId === user._id}
                  />
              ))}
            </div>
        )}

        {/* Add User Dialog */}
        <AddUserDialog
        isOpen={isAddUserOpen}
        onOpenChange={setIsAddUserOpen}
        />

        {/* Edit User Dialog */}
        {editingUser && (
          <AddUserDialog
            isOpen={isEditUserOpen}
            onOpenChange={setIsEditUserOpen}
            user={editingUser}
            isEditing={true}
          />
        )}
      </div>
  )
}

interface UserCardProps {
  user: MatrimonyUserType
  onToggleFavorite: (id: number) => void
  onDelete: (id: number) => void
  onEdit: (user: MatrimonyUserType) => void 
  avatarColor: string
  isLoadingFavorite: boolean
  isLoadingDelete: boolean
}

function UserCard({ 
  user, 
  onToggleFavorite, 
  onDelete, 
  avatarColor, 
  onEdit, 
  isLoadingFavorite, 
  isLoadingDelete 
}: UserCardProps) {
  const [isHovering, setIsHovering] = useState(false)
  const [isDeleteDialogOpen, setIsDeleteDialogOpen] = useState(false)

  // Format date for display
  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
  };

  // Check if user is favorite (handles both boolean and numeric values)
  const isFavorite = user.isFavourite === 1;

  // Handle delete confirmation
  const handleDeleteConfirm = () => {
    onDelete(user._id!);
    setIsDeleteDialogOpen(false);
  };

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
              <div className={`flex items-center justify-center w-12 h-12 rounded-full ${avatarColor}`}>
                <span className="text-lg font-semibold">{user.fullName.charAt(0)}</span>
              </div>
              <div>
                <h3 className="text-lg font-semibold">{user.fullName}</h3>
                <p className="text-sm text-muted-foreground">{user.gender}</p>
              </div>
            </div>
            <div className="flex space-x-1">
              <Button
                  variant="ghost"
                  size="icon"
                  className={`h-8 w-8 rounded-full ${isFavorite ? "text-red-500 hover:text-red-600" : "text-muted-foreground hover:text-foreground"}`}
                  onClick={() => onToggleFavorite(user._id!)}
                  disabled={isLoadingFavorite || isLoadingDelete}
              >
                {isLoadingFavorite ? (
                  <div className="h-5 w-5 animate-spin rounded-full border-2 border-current border-t-transparent" />
                ) : (
                  <Heart className="h-5 w-5" fill={isFavorite ? "currentColor" : "none"} />
                )}
                <span className="sr-only">{isFavorite ? "Remove from favorites" : "Add to favorites"}</span>
              </Button>
              <Button
                  variant="ghost"
                  size="icon"
                  className="h-8 w-8 rounded-full text-muted-foreground hover:text-destructive"
                  onClick={() => setIsDeleteDialogOpen(true)}
                  disabled={isLoadingFavorite || isLoadingDelete}
              >
                {isLoadingDelete ? (
                  <div className="h-5 w-5 animate-spin rounded-full border-2 border-current border-t-transparent" />
                ) : (
                  <Trash2 className="h-5 w-5" />
                )}
                <span className="sr-only">Delete</span>
              </Button>
            </div>
          </div>

          <div className="mt-4 space-y-2">
            <div className="flex items-center text-sm">
              <Mail className="h-4 w-4 mr-2 text-muted-foreground" />
              <span>{user.email}</span>
            </div>
            <div className="flex items-center text-sm">
              <Phone className="h-4 w-4 mr-2 text-muted-foreground" />
              <span>{user.mobileNumber}</span>
            </div>
            <div className="flex items-center text-sm">
              <MapPin className="h-4 w-4 mr-2 text-muted-foreground" />
              <span>{user.city}</span>
            </div>
            <div className="flex items-center text-sm">
              <Calendar className="h-4 w-4 mr-2 text-muted-foreground" />
              <span>Born: {formatDate(user.dob)}</span>
            </div>
          {/* user hobbies */}
            {/* {user.hobbies && (
              <div className="text-sm mt-2">
                <span className="text-muted-foreground">Hobbies:</span> {user.hobbies}
              </div>
            )} */}
          </div>

          <div className="mt-5 pt-4 border-t border-border">
            <Button 
              size="sm" 
              className="w-full"
              onClick={() => onEdit(user)}
              disabled={isLoadingFavorite || isLoadingDelete}
            >
              Edit Profile
            </Button>
          </div>
        </div>

        {/* Delete Confirmation Dialog */}
        <Dialog open={isDeleteDialogOpen} onOpenChange={setIsDeleteDialogOpen}>
          <DialogContent className="sm:max-w-[425px]">
            <DialogHeader>
              <DialogTitle>Confirm Deletion</DialogTitle>
              <DialogDescription>
                Are you sure you want to delete {user.fullName}'s profile? This action cannot be undone.
              </DialogDescription>
            </DialogHeader>
            <DialogFooter className="flex space-x-2 pt-4">
              <Button variant="outline" onClick={() => setIsDeleteDialogOpen(false)} disabled={isLoadingDelete}>
                Cancel
              </Button>
              <Button 
                variant="destructive" 
                onClick={handleDeleteConfirm} 
                disabled={isLoadingDelete}
              >
                {isLoadingDelete ? (
                  <div className="mr-2 h-4 w-4 animate-spin rounded-full border-2 border-current border-t-transparent" />
                ) : null}
                Yes, Delete
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      </motion.div>
  )
}
