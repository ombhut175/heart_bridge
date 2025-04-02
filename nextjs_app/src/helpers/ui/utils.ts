import {otpDataInterface} from "@/helpers/interfaces";
import {CONSTANTS} from "@/helpers/string_const";

export function getEncodedUrl(
    {data, route}:
    { data: otpDataInterface, route: string }) {
    return `${route}?${CONSTANTS.DATA}=${encodeURIComponent(JSON.stringify(data))}`;
}

export function getDecodedData(encodedData:string):otpDataInterface
{
    return JSON.parse(decodeURIComponent(encodedData));
}