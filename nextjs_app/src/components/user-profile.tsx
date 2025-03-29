"use client"

import useSWR from "swr"

const fetcher = (url: string) => fetch(url).then((res) => res.json())

export function UserProfile() {
  const { data, error, isLoading } = useSWR("https://jsonplaceholder.typicode.com/users/1", fetcher)

  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-40">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-gray-900 dark:border-white"></div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="p-4 bg-red-100 dark:bg-red-900 text-red-800 dark:text-red-100 rounded">
        Failed to load user data
      </div>
    )
  }

  return (
    <div className="space-y-4">
      <div className="grid grid-cols-2 gap-2">
        <div className="font-semibold">Name:</div>
        <div>{data.name}</div>
        <div className="font-semibold">Email:</div>
        <div>{data.email}</div>
        <div className="font-semibold">Phone:</div>
        <div>{data.phone}</div>
        <div className="font-semibold">Website:</div>
        <div>{data.website}</div>
      </div>
      <div className="text-xs text-gray-500 dark:text-gray-400">Data fetched with SWR</div>
    </div>
  )
}

