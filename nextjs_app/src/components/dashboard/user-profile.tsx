"use client"

import type React from "react"

import { useState } from "react"
import { motion, AnimatePresence } from "framer-motion"
import { User, Mail, Edit, Save, X, Camera, Calendar, MapPin, Phone } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Separator } from "@/components/ui/separator"

// Sample user data
const initialUserData = {
  name: "John Doe",
  email: "john.doe@example.com",
  phone: "+1 (555) 123-4567",
  birthdate: "1990-05-15",
  gender: "Male",
  location: "New York, NY",
  bio: "Looking for a life partner who shares my values and interests. I enjoy hiking, reading, and trying new restaurants.",
  occupation: "Software Engineer",
  education: "Master's in Computer Science",
  interests: ["Hiking", "Reading", "Cooking", "Travel"],
}

export function UserProfile() {
  const [userData, setUserData] = useState(initialUserData)
  const [isEditing, setIsEditing] = useState(false)
  const [editedData, setEditedData] = useState(userData)

  const handleEditToggle = () => {
    if (isEditing) {
      // Cancel editing
      setEditedData(userData)
    }
    setIsEditing(!isEditing)
  }

  const handleSave = () => {
    setUserData(editedData)
    setIsEditing(false)
  }

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { name, value } = e.target
    setEditedData((prev) => ({
      ...prev,
      [name]: value,
    }))
  }

  return (
    <div className="max-w-4xl mx-auto">
      <div className="bg-card rounded-xl border border-border shadow-sm overflow-hidden">
        {/* Profile Header */}
        <div className="relative h-48 bg-gradient-to-r from-primary/80 to-primary/40">
          <Button
            variant="outline"
            size="icon"
            className="absolute right-4 top-4 bg-background/80 backdrop-blur-sm hover:bg-background"
          >
            <Camera className="h-4 w-4" />
            <span className="sr-only">Change cover photo</span>
          </Button>
        </div>

        {/* Profile Info Section */}
        <div className="px-6 sm:px-8 pb-8 -mt-16 relative">
          {/* Avatar */}
          <div className="flex flex-col sm:flex-row items-center sm:items-end mb-6">
            <div className="relative">
              <div className="w-32 h-32 rounded-full border-4 border-card bg-blue-100 dark:bg-blue-950 flex items-center justify-center text-blue-500 dark:text-blue-300">
                <span className="text-4xl font-bold">{userData.name.charAt(0)}</span>
              </div>
              <Button
                variant="outline"
                size="icon"
                className="absolute bottom-0 right-0 h-8 w-8 rounded-full bg-background shadow-md hover:bg-accent"
              >
                <Camera className="h-4 w-4" />
                <span className="sr-only">Change profile photo</span>
              </Button>
            </div>

            <div className="mt-4 sm:mt-0 sm:ml-6 flex flex-col sm:flex-row items-center sm:items-end sm:justify-between w-full">
              <div className="text-center sm:text-left">
                <h2 className="text-2xl font-bold">{userData.name}</h2>
                <p className="text-muted-foreground">{userData.email}</p>
              </div>

              <div className="mt-4 sm:mt-0">
                <Button
                  onClick={handleEditToggle}
                  variant={isEditing ? "outline" : "default"}
                  className="flex items-center gap-2"
                >
                  {isEditing ? (
                    <>
                      <X className="h-4 w-4" />
                      Cancel
                    </>
                  ) : (
                    <>
                      <Edit className="h-4 w-4" />
                      Edit Profile
                    </>
                  )}
                </Button>
              </div>
            </div>
          </div>

          <Separator className="my-6" />

          {/* Profile Content */}
          <AnimatePresence mode="wait">
            {isEditing ? (
              <motion.div
                key="edit-form"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                transition={{ duration: 0.2 }}
              >
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div className="space-y-4">
                    <div className="space-y-2">
                      <Label htmlFor="name">Full Name</Label>
                      <Input id="name" name="name" value={editedData.name} onChange={handleChange} />
                    </div>

                    <div className="space-y-2">
                      <Label htmlFor="email">Email</Label>
                      <Input id="email" name="email" type="email" value={editedData.email} onChange={handleChange} />
                    </div>

                    <div className="space-y-2">
                      <Label htmlFor="phone">Phone Number</Label>
                      <Input id="phone" name="phone" value={editedData.phone} onChange={handleChange} />
                    </div>

                    <div className="space-y-2">
                      <Label htmlFor="birthdate">Date of Birth</Label>
                      <Input
                        id="birthdate"
                        name="birthdate"
                        type="date"
                        value={editedData.birthdate}
                        onChange={handleChange}
                      />
                    </div>
                  </div>

                  <div className="space-y-4">
                    <div className="space-y-2">
                      <Label htmlFor="gender">Gender</Label>
                      <Input id="gender" name="gender" value={editedData.gender} onChange={handleChange} />
                    </div>

                    <div className="space-y-2">
                      <Label htmlFor="location">Location</Label>
                      <Input id="location" name="location" value={editedData.location} onChange={handleChange} />
                    </div>

                    <div className="space-y-2">
                      <Label htmlFor="occupation">Occupation</Label>
                      <Input id="occupation" name="occupation" value={editedData.occupation} onChange={handleChange} />
                    </div>

                    <div className="space-y-2">
                      <Label htmlFor="education">Education</Label>
                      <Input id="education" name="education" value={editedData.education} onChange={handleChange} />
                    </div>
                  </div>
                </div>

                <div className="space-y-2 mt-6">
                  <Label htmlFor="bio">About Me</Label>
                  <textarea
                    id="bio"
                    name="bio"
                    value={editedData.bio}
                    onChange={handleChange}
                    rows={4}
                    className="w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
                  />
                </div>

                <div className="mt-8 flex justify-end">
                  <Button onClick={handleSave} className="flex items-center gap-2">
                    <Save className="h-4 w-4" />
                    Save Changes
                  </Button>
                </div>
              </motion.div>
            ) : (
              <motion.div
                key="profile-view"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                transition={{ duration: 0.2 }}
              >
                <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                  <div className="space-y-6">
                    <div>
                      <h3 className="text-lg font-medium mb-4">Personal Information</h3>

                      <div className="space-y-4">
                        <div className="flex items-center gap-3">
                          <User className="h-5 w-5 text-muted-foreground" />
                          <div>
                            <p className="text-sm text-muted-foreground">Full Name</p>
                            <p className="font-medium">{userData.name}</p>
                          </div>
                        </div>

                        <div className="flex items-center gap-3">
                          <Mail className="h-5 w-5 text-muted-foreground" />
                          <div>
                            <p className="text-sm text-muted-foreground">Email</p>
                            <p className="font-medium">{userData.email}</p>
                          </div>
                        </div>

                        <div className="flex items-center gap-3">
                          <Phone className="h-5 w-5 text-muted-foreground" />
                          <div>
                            <p className="text-sm text-muted-foreground">Phone</p>
                            <p className="font-medium">{userData.phone}</p>
                          </div>
                        </div>

                        <div className="flex items-center gap-3">
                          <Calendar className="h-5 w-5 text-muted-foreground" />
                          <div>
                            <p className="text-sm text-muted-foreground">Date of Birth</p>
                            <p className="font-medium">
                              {new Date(userData.birthdate).toLocaleDateString("en-US", {
                                year: "numeric",
                                month: "long",
                                day: "numeric",
                              })}
                            </p>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div>
                      <h3 className="text-lg font-medium mb-4">Location</h3>
                      <div className="flex items-center gap-3">
                        <MapPin className="h-5 w-5 text-muted-foreground" />
                        <div>
                          <p className="text-sm text-muted-foreground">Current Location</p>
                          <p className="font-medium">{userData.location}</p>
                        </div>
                      </div>
                    </div>
                  </div>

                  <div className="space-y-6">
                    <div>
                      <h3 className="text-lg font-medium mb-4">About Me</h3>
                      <p className="text-muted-foreground">{userData.bio}</p>
                    </div>

                    <div>
                      <h3 className="text-lg font-medium mb-4">Professional Details</h3>
                      <div className="space-y-3">
                        <div>
                          <p className="text-sm text-muted-foreground">Occupation</p>
                          <p className="font-medium">{userData.occupation}</p>
                        </div>
                        <div>
                          <p className="text-sm text-muted-foreground">Education</p>
                          <p className="font-medium">{userData.education}</p>
                        </div>
                      </div>
                    </div>

                    <div>
                      <h3 className="text-lg font-medium mb-4">Interests</h3>
                      <div className="flex flex-wrap gap-2">
                        {userData.interests.map((interest, index) => (
                          <span key={index} className="px-3 py-1 bg-primary/10 text-primary rounded-full text-sm">
                            {interest}
                          </span>
                        ))}
                      </div>
                    </div>
                  </div>
                </div>
              </motion.div>
            )}
          </AnimatePresence>
        </div>
      </div>
    </div>
  )
}

