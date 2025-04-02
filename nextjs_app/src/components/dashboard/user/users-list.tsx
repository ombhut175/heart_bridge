"use client"

import type React from "react"

import { useState } from "react"
import { motion } from "framer-motion"
import { Heart, Trash2, MapPin, Phone, UserIcon, Plus, X, Mail, Check } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Badge } from "@/components/ui/badge"
import { Checkbox } from "@/components/ui/checkbox"
import { isValid, parse } from "date-fns"

// Sample user data
const initialUsers = [
  {
    id: 1,
    name: "sophia johnson",
    city: "New York, NY",
    phone: "5551234567",
    gender: "Female",
    isFavorite: false,
  },
  {
    id: 2,
    name: "ethan williams",
    city: "Los Angeles, CA",
    phone: "5559876543",
    gender: "Male",
    isFavorite: true,
  },
  {
    id: 3,
    name: "olivia davis",
    city: "Chicago, IL",
    phone: "5554567890",
    gender: "Female",
    isFavorite: false,
  },
  {
    id: 4,
    name: "noah martinez",
    city: "Houston, TX",
    phone: "5552345678",
    gender: "Male",
    isFavorite: false,
  },
  {
    id: 5,
    name: "ava thompson",
    city: "Phoenix, AZ",
    phone: "5558765432",
    gender: "Female",
    isFavorite: true,
  },
  {
    id: 6,
    name: "william anderson",
    city: "Philadelphia, PA",
    phone: "5553456789",
    gender: "Male",
    isFavorite: false,
  },
  {
    id: 7,
    name: "emma garcia",
    city: "San Antonio, TX",
    phone: "5556543210",
    gender: "Female",
    isFavorite: false,
  },
  {
    id: 8,
    name: "james rodriguez",
    city: "San Diego, CA",
    phone: "5557890123",
    gender: "Male",
    isFavorite: true,
  },
]

// Available cities for dropdown
const cities = ["New York, NY", "Los Angeles, CA", "Chicago, IL", "Houston, TX"]

// Available hobbies for selection
const availableHobbies = [
  "Reading",
  "Cooking",
  "Traveling",
  "Photography",
  "Hiking",
  "Painting",
  "Dancing",
  "Singing",
  "Gaming",
  "Swimming",
  "Yoga",
  "Gardening",
]

type User = (typeof initialUsers)[0]

interface FormData {
  name: string
  email: string
  phone: string
  dob: string
  gender: string
  city: string
  hobbies: string[]
}

interface FormErrors {
  name?: string
  email?: string
  phone?: string
  dob?: string
  gender?: string
  city?: string
}

export function UsersList() {
  const [users, setUsers] = useState(initialUsers)
  const [searchTerm, setSearchTerm] = useState("")
  const [isAddUserOpen, setIsAddUserOpen] = useState(false)

  // Form state
  const [formData, setFormData] = useState<FormData>({
    name: "",
    email: "",
    phone: "",
    dob: "",
    gender: "",
    city: "",
    hobbies: [],
  })

  const [formErrors, setFormErrors] = useState<FormErrors>({})

  // Filter users based on search term
  const filteredUsers = users.filter(
    (user) =>
      user.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      user.city.toLowerCase().includes(searchTerm.toLowerCase()),
  )

  // Toggle favorite status
  const toggleFavorite = (userId: number) => {
    setUsers(users.map((user) => (user.id === userId ? { ...user, isFavorite: !user.isFavorite } : user)))
  }

  // Delete user
  const deleteUser = (userId: number) => {
    setUsers(users.filter((user) => user.id !== userId))
  }

  // Get avatar color based on gender
  const getAvatarColor = (gender: string) => {
    return gender === "Female"
      ? "bg-pink-100 text-pink-500 dark:bg-pink-950 dark:text-pink-300"
      : "bg-blue-100 text-blue-500 dark:bg-blue-950 dark:text-blue-300"
  }

  // Handle form input changes
  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target

    // Validation for specific fields
    if (name === "name") {
      // Only allow lowercase letters, no digits
      if (/^[a-z\s]*$/.test(value)) {
        setFormData({ ...formData, [name]: value })
        setFormErrors({ ...formErrors, [name]: undefined })
      }
    } else if (name === "email") {
      // No whitespace allowed
      if (!/\s/.test(value)) {
        setFormData({ ...formData, [name]: value })
        setFormErrors({ ...formErrors, [name]: undefined })
      }
    } else if (name === "phone") {
      // Only allow digits, max 10
      if (/^\d{0,10}$/.test(value)) {
        setFormData({ ...formData, [name]: value })
        setFormErrors({ ...formErrors, [name]: undefined })
      }
    } else if (name === "dob") {
      setFormData({ ...formData, [name]: value })
      setFormErrors({ ...formErrors, [name]: undefined })
    } else {
      setFormData({ ...formData, [name]: value })
    }
  }

  // Handle select changes
  const handleSelectChange = (name: string, value: string) => {
    setFormData({ ...formData, [name]: value })
    setFormErrors({ ...formErrors, [name]: undefined })
  }

  // Toggle hobby selection
  const toggleHobby = (hobby: string) => {
    const updatedHobbies = formData.hobbies.includes(hobby)
      ? formData.hobbies.filter((h) => h !== hobby)
      : [...formData.hobbies, hobby]

    setFormData({ ...formData, hobbies: updatedHobbies })
  }

  // Reset form
  const resetForm = () => {
    setFormData({
      name: "",
      email: "",
      phone: "",
      dob: "",
      gender: "",
      city: "",
      hobbies: [],
    })
    setFormErrors({})
  }

  // Calculate min and max dates for age range 18-80
  const today = new Date()
  const maxDate = new Date(today.getFullYear() - 18, today.getMonth(), today.getDate())
  const minDate = new Date(today.getFullYear() - 80, today.getMonth(), today.getDate())

  // Validate form
  const validateForm = (): boolean => {
    const errors: FormErrors = {}

    if (!formData.name) {
      errors.name = "Name is required"
    }

    if (!formData.email) {
      errors.email = "Email is required"
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
      errors.email = "Invalid email format"
    }

    if (!formData.phone) {
      errors.phone = "Phone number is required"
    } else if (formData.phone.length !== 10) {
      errors.phone = "Phone number must be 10 digits"
    }

    if (!formData.dob) {
      errors.dob = "Date of birth is required"
    } else {
      // Validate date format and range
      try {
        const parsedDate = parse(formData.dob, "yyyy-MM-dd", new Date())
        if (!isValid(parsedDate)) {
          errors.dob = "Invalid date format"
        } else if (parsedDate > maxDate || parsedDate < minDate) {
          errors.dob = "Age must be between 18 and 80 years"
        }
      } catch (e) {
        errors.dob = "Invalid date format"
      }
    }

    if (!formData.gender) {
      errors.gender = "Gender is required"
    }

    if (!formData.city) {
      errors.city = "City is required"
    }

    setFormErrors(errors)
    return Object.keys(errors).length === 0
  }

  // Handle form submission
  const handleSubmit = () => {
    if (validateForm()) {
      // Create new user
      const newUser: User = {
        id: users.length > 0 ? Math.max(...users.map((user) => user.id)) + 1 : 1,
        name: formData.name,
        city: formData.city,
        phone: formData.phone,
        gender: formData.gender,
        isFavorite: false,
      }

      // Add to users list
      setUsers([...users, newUser])

      // Close modal and reset form
      setIsAddUserOpen(false)
      resetForm()
    }
  }

  // Generate year options for the date of birth select
  const yearOptions = []
  const currentYear = today.getFullYear()
  for (let year = currentYear - 18; year >= currentYear - 80; year--) {
    yearOptions.push(year)
  }

  // Generate month options
  const monthOptions = [
    { value: "01", label: "January" },
    { value: "02", label: "February" },
    { value: "03", label: "March" },
    { value: "04", label: "April" },
    { value: "05", label: "May" },
    { value: "06", label: "June" },
    { value: "07", label: "July" },
    { value: "08", label: "August" },
    { value: "09", label: "September" },
    { value: "10", label: "October" },
    { value: "11", label: "November" },
    { value: "12", label: "December" },
  ]

  // Generate day options (1-31)
  const dayOptions = Array.from({ length: 31 }, (_, i) => {
    const day = i + 1
    return { value: day < 10 ? `0${day}` : `${day}`, label: `${day}` }
  })

  // Handle date of birth selection
  const handleDateChange = (type: "year" | "month" | "day", value: string) => {
    const currentDate = formData.dob ? formData.dob.split("-") : ["", "", ""]

    if (type === "year") {
      currentDate[0] = value
    } else if (type === "month") {
      currentDate[1] = value
    } else if (type === "day") {
      currentDate[2] = value
    }

    const newDate = currentDate.join("-")
    setFormData({ ...formData, dob: newDate })
    setFormErrors({ ...formErrors, dob: undefined })
  }

  // Extract year, month, and day from the dob string
  const [year, month, day] = formData.dob ? formData.dob.split("-") : ["", "", ""]

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
        <div className="flex items-center gap-3">
          <div className="text-sm text-muted-foreground">
            Showing <span className="font-medium text-foreground">{filteredUsers.length}</span> users
          </div>
          <Button onClick={() => setIsAddUserOpen(true)} className="flex items-center gap-2">
            <Plus className="h-4 w-4" />
            Add User
          </Button>
        </div>
      </div>

      {filteredUsers.length === 0 ? (
        <div className="text-center py-12">
          <div className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-muted mb-4">
            <UserIcon className="h-8 w-8 text-muted-foreground" />
          </div>
          <h3 className="text-lg font-medium">No users found</h3>
          <p className="text-muted-foreground mt-1">Try adjusting your search terms</p>
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

      {/* Add User Dialog */}
      <Dialog open={isAddUserOpen} onOpenChange={setIsAddUserOpen}>
        <DialogContent className="sm:max-w-[600px] max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle className="text-xl">Add New User</DialogTitle>
          </DialogHeader>

          <div className="grid gap-6 py-4">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              {/* Full Name */}
              <div className="space-y-2">
                <Label htmlFor="name" className="flex items-center gap-1">
                  Full Name
                  <span className="text-destructive">*</span>
                </Label>
                <Input
                  id="name"
                  name="name"
                  value={formData.name}
                  onChange={handleInputChange}
                  placeholder="Enter full name (lowercase only)"
                  className={formErrors.name ? "border-destructive" : ""}
                />
                {formErrors.name && <p className="text-xs text-destructive">{formErrors.name}</p>}
                <p className="text-xs text-muted-foreground">Only lowercase letters allowed</p>
              </div>

              {/* Email */}
              <div className="space-y-2">
                <Label htmlFor="email" className="flex items-center gap-1">
                  Email
                  <span className="text-destructive">*</span>
                </Label>
                <div className="relative">
                  <Input
                    id="email"
                    name="email"
                    type="email"
                    value={formData.email}
                    onChange={handleInputChange}
                    placeholder="Enter email address"
                    className={`pl-9 ${formErrors.email ? "border-destructive" : ""}`}
                  />
                  <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                </div>
                {formErrors.email && <p className="text-xs text-destructive">{formErrors.email}</p>}
                <p className="text-xs text-muted-foreground">No whitespace allowed</p>
              </div>

              {/* Mobile Number */}
              <div className="space-y-2">
                <Label htmlFor="phone" className="flex items-center gap-1">
                  Mobile Number
                  <span className="text-destructive">*</span>
                </Label>
                <div className="relative">
                  <Input
                    id="phone"
                    name="phone"
                    value={formData.phone}
                    onChange={handleInputChange}
                    placeholder="Enter 10-digit number"
                    className={`pl-9 ${formErrors.phone ? "border-destructive" : ""}`}
                  />
                  <Phone className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                </div>
                {formErrors.phone && <p className="text-xs text-destructive">{formErrors.phone}</p>}
                <p className="text-xs text-muted-foreground">Maximum 10 digits</p>
              </div>

              {/* Date of Birth */}
              <div className="space-y-2">
                <Label htmlFor="dob" className="flex items-center gap-1">
                  Date of Birth
                  <span className="text-destructive">*</span>
                </Label>
                <div className="grid grid-cols-3 gap-2">
                  {/* Year */}
                  <Select value={year} onValueChange={(value) => handleDateChange("year", value)}>
                    <SelectTrigger className={formErrors.dob ? "border-destructive" : ""}>
                      <SelectValue placeholder="Year" />
                    </SelectTrigger>
                    <SelectContent className="max-h-[200px]">
                      {yearOptions.map((year) => (
                        <SelectItem key={year} value={year.toString()}>
                          {year}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>

                  {/* Month */}
                  <Select value={month} onValueChange={(value) => handleDateChange("month", value)}>
                    <SelectTrigger className={formErrors.dob ? "border-destructive" : ""}>
                      <SelectValue placeholder="Month" />
                    </SelectTrigger>
                    <SelectContent>
                      {monthOptions.map((month) => (
                        <SelectItem key={month.value} value={month.value}>
                          {month.label}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>

                  {/* Day */}
                  <Select value={day} onValueChange={(value) => handleDateChange("day", value)}>
                    <SelectTrigger className={formErrors.dob ? "border-destructive" : ""}>
                      <SelectValue placeholder="Day" />
                    </SelectTrigger>
                    <SelectContent>
                      {dayOptions.map((day) => (
                        <SelectItem key={day.value} value={day.value}>
                          {day.label}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
                {formErrors.dob && <p className="text-xs text-destructive">{formErrors.dob}</p>}
                <p className="text-xs text-muted-foreground">Age must be between 18 and 80 years</p>
              </div>

              {/* Gender */}
              <div className="space-y-2">
                <Label htmlFor="gender" className="flex items-center gap-1">
                  Gender
                  <span className="text-destructive">*</span>
                </Label>
                <Select value={formData.gender} onValueChange={(value) => handleSelectChange("gender", value)}>
                  <SelectTrigger className={formErrors.gender ? "border-destructive" : ""}>
                    <SelectValue placeholder="Select gender" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="Male">Male</SelectItem>
                    <SelectItem value="Female">Female</SelectItem>
                    <SelectItem value="Other">Other</SelectItem>
                  </SelectContent>
                </Select>
                {formErrors.gender && <p className="text-xs text-destructive">{formErrors.gender}</p>}
              </div>

              {/* City */}
              <div className="space-y-2">
                <Label htmlFor="city" className="flex items-center gap-1">
                  City
                  <span className="text-destructive">*</span>
                </Label>
                <Select value={formData.city} onValueChange={(value) => handleSelectChange("city", value)}>
                  <SelectTrigger className={formErrors.city ? "border-destructive" : ""}>
                    <SelectValue placeholder="Select city" />
                  </SelectTrigger>
                  <SelectContent>
                    {cities.map((city) => (
                      <SelectItem key={city} value={city}>
                        {city}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
                {formErrors.city && <p className="text-xs text-destructive">{formErrors.city}</p>}
              </div>
            </div>

            {/* Hobbies and Interests */}
            <div className="space-y-3">
              <Label className="flex items-center gap-1">Hobbies & Interests</Label>
              <div className="flex flex-wrap gap-2 mb-2">
                {formData.hobbies.map((hobby) => (
                  <Badge key={hobby} variant="secondary" className="flex items-center gap-1">
                    {hobby}
                    <X className="h-3 w-3 cursor-pointer" onClick={() => toggleHobby(hobby)} />
                  </Badge>
                ))}
              </div>
              <div className="grid grid-cols-2 sm:grid-cols-3 gap-2">
                {availableHobbies.map((hobby) => (
                  <div key={hobby} className="flex items-center space-x-2">
                    <Checkbox
                      id={`hobby-${hobby}`}
                      checked={formData.hobbies.includes(hobby)}
                      onCheckedChange={() => toggleHobby(hobby)}
                    />
                    <Label htmlFor={`hobby-${hobby}`} className="text-sm cursor-pointer">
                      {hobby}
                    </Label>
                  </div>
                ))}
              </div>
            </div>
          </div>

          <DialogFooter className="flex flex-col sm:flex-row gap-2">
            <Button type="button" variant="outline" onClick={resetForm} className="sm:order-1 order-2">
              Reset
            </Button>
            <Button type="button" onClick={handleSubmit} className="sm:order-2 order-1">
              <Check className="mr-2 h-4 w-4" />
              Submit
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}

interface UserCardProps {
  user: User
  onToggleFavorite: (id: number) => void
  onDelete: (id: number) => void
  avatarColor: string
}

function UserCard({ user, onToggleFavorite, onDelete, avatarColor }: UserCardProps) {
  const [isHovering, setIsHovering] = useState(false)

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
              <span className="text-lg font-semibold">{user.name.charAt(0)}</span>
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
              className={`h-8 w-8 rounded-full ${user.isFavorite ? "text-red-500 hover:text-red-600" : "text-muted-foreground hover:text-foreground"}`}
              onClick={() => onToggleFavorite(user.id)}
            >
              <Heart className="h-5 w-5" fill={user.isFavorite ? "currentColor" : "none"} />
              <span className="sr-only">{user.isFavorite ? "Remove from favorites" : "Add to favorites"}</span>
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
  )
}

