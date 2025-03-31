import { toast } from "react-toastify";

export const handleError = (error: unknown) => {
  console.error(error);

  let errorMessage = "An unexpected error occurred";

  if (typeof error === "string") {
    errorMessage = error;
  } else if (error instanceof Error) {
    errorMessage = error.message;
  } else if (error && typeof error === "object" && "message" in error) {
    errorMessage = String(error.message);
  }

  toast.error(errorMessage);
};


export const handleSuccess = (responseData:{success: boolean, message : string , body:{}})=>{

}