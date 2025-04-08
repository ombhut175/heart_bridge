"use client"

import { useState } from "react"
import { Mail, Phone, X, Check } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Badge } from "@/components/ui/badge"
import { Checkbox } from "@/components/ui/checkbox"
import { format, isValid, parse, parseISO } from "date-fns"
import { MatrimonyUserType } from "@/types/store/user"
import { handleError, postRequest, putRequest } from "@/helpers/ui/handlers"
import useSWRMutation from "swr/mutation"
import { showLoadingBar } from "@/helpers/ui/uiHelpers"
import { mutate } from "swr"


const addUserFetcher = async (url: string, {arg}: { arg: { user: FormData } }) => {
    return await postRequest(url, arg.user);
  
}

const editUserFetcher = async (url: string, {arg}: { arg: { user: FormData } }) => {
  return await putRequest(url, arg.user);

}

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

export interface User {
  _id: number
  fullName: string
  email: string
  mobileNumber: string
  dob: string
  gender: string
  city: string
  hobbies: string
  createdAt: string
  createdByAdminEmail: string
  isFavourite: boolean
}

export interface FormData {
  fullName: string
  email: string
  mobileNumber: string
  dob: string
  gender: string
  city: string
  hobbies: string[]
}

export interface FormErrors {
  fullName?: string
  email?: string
  mobileNumber?: string
  dob?: string
  gender?: string
  city?: string
}

interface AddUserDialogProps {
  isOpen: boolean
  onOpenChange: (open: boolean) => void
  user?: MatrimonyUserType
  isEditing?: boolean
}

export function AddUserDialog({ isOpen, onOpenChange,isEditing,user }: AddUserDialogProps) {


  const {
    trigger:addUserTrigger, isMutating:creatingUser, error:addUserError,
      } = useSWRMutation('/api/user', addUserFetcher);

      const {
        trigger:editUserTrigger, isMutating:editingUser, error:editUserError,
    } = useSWRMutation(`/api/user/${user?._id}`, editUserFetcher);


  console.log("::: add user dialog");
  
  console.log(user);


  const formatDateForForm = (dateString: string | undefined): string => {
    if (!dateString) return "";
    
    try {
      // Try to parse the date from "dd MMM yyyy" format
      const parsedDate = parse(dateString, "dd MMM yyyy", new Date());
      
      // If valid, convert to "yyyy-MM-dd" format
      if (isValid(parsedDate)) {
        return format(parsedDate, "yyyy-MM-dd");
      }
      
      // If the above fails, try other common formats
      // Try ISO format
      const isoDate = parseISO(dateString);
      if (isValid(isoDate)) {
        return format(isoDate, "yyyy-MM-dd");
      }
      
      return dateString;
    } catch (error) {
      console.error("Error parsing date:", error);
      return dateString;
    }
  };

  // Form state
  const [formData, setFormData] = useState<FormData>({
    fullName: user?.fullName || "",
    email: user?.email || "",
    mobileNumber: user?.mobileNumber || "",
    dob: formatDateForForm(user?.dob) || "",
    gender: user?.gender || "",
    city: user?.city || "",
    hobbies: user?.hobbies ? user.hobbies : [],
  })

  console.log("::: form data :::");
  console.log(formData);
  

  const [formErrors, setFormErrors] = useState<FormErrors>({})

  

  // Calculate min and max dates for age range 18-80
  const today = new Date()
  const maxDate = new Date(today.getFullYear() - 18, today.getMonth(), today.getDate())
  const minDate = new Date(today.getFullYear() - 80, today.getMonth(), today.getDate())

  // Handle form input changes
  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target

    // Validation for specific fields
    if (name === "fullName") {
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
    } else if (name === "mobileNumber") {
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
      fullName: "",
      email: "",
      mobileNumber: "",
      dob: "",
      gender: "",
      city: "",
      hobbies: [],
    })
    setFormErrors({})
  }

  // Validate form
  const validateForm = (): boolean => {
    const errors: FormErrors = {}

    if (!formData.fullName) {
      errors.fullName = "Name is required"
    }

    if (!formData.email) {
      errors.email = "Email is required"
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
      errors.email = "Invalid email format"
    }

    if (!formData.mobileNumber) {
      errors.mobileNumber = "Phone number is required"
    } else if (formData.mobileNumber.length !== 10) {
      errors.mobileNumber = "Phone number must be 10 digits"
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
  const handleSubmit = async () => {
    console.log("::: handle submit :::");
   
    

    if(!validateForm()) {
      handleError("Please fill all required fields");
      return;
    };  



    try{
      const formDataToSubmit = { ...formData };

      if (formDataToSubmit.dob) {
        const parsedDate = parse(formDataToSubmit.dob, "yyyy-MM-dd", new Date());
        if (isValid(parsedDate)) {
          formDataToSubmit.dob = format(parsedDate, "dd MMM yyyy");
        }
      }

      let responseBody;

      if(isEditing){
        responseBody = await editUserTrigger({
          user: formDataToSubmit,
        });

      }
      else{
          responseBody = await addUserTrigger({
            user: formDataToSubmit,
          });
      }
      
      onOpenChange(false);

      mutate("/api/user");

    }catch(error){
      handleError(error);
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

  if(addUserError || editUserError) handleError(addUserError || editUserError);

  if(creatingUser || editingUser) return showLoadingBar(); 

  return (
    <Dialog open={isOpen} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[600px] max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle className="text-xl">Add New User</DialogTitle>
        </DialogHeader>

        <div className="grid gap-6 py-4">
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            {/* Full Name */}
            <div className="space-y-2">
              <Label htmlFor="fullName" className="flex items-center gap-1">
                Full Name
                <span className="text-destructive">*</span>
              </Label>
              <Input
                id="fullName"
                name="fullName"
                value={formData.fullName}
                onChange={handleInputChange}
                placeholder="Enter full name (lowercase only)"
                className={formErrors.fullName ? "border-destructive" : ""}
              />
              {formErrors.fullName && <p className="text-xs text-destructive">{formErrors.fullName}</p>}
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
              <Label htmlFor="mobileNumber" className="flex items-center gap-1">
                Mobile Number
                <span className="text-destructive">*</span>
              </Label>
              <div className="relative">
                <Input
                  id="mobileNumber"
                  name="mobileNumber"
                  value={formData.mobileNumber}
                  onChange={handleInputChange}
                  placeholder="Enter 10-digit number"
                  className={`pl-9 ${formErrors.mobileNumber ? "border-destructive" : ""}`}
                />
                <Phone className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
              </div>
              {formErrors.mobileNumber && <p className="text-xs text-destructive">{formErrors.mobileNumber}</p>}
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
  )
}