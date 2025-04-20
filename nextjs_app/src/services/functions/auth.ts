import {getRequest} from "@/helpers/ui/handlers";

export default async function isUserLoggedIn(){
    const response = await getRequest("/api/isLoggedIn");
}