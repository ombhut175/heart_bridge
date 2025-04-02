import { UserInterface } from '@/model/User';
// import {sign} from "jsonwebtoken";
import { jwtVerify, SignJWT } from 'jose';
import { NextRequest } from 'next/server';
import { AUTHENTICATION } from '@/helpers/string_const';
import {serialize,parse} from "cookie";

export async function setUser(user: UserInterface) {
  console.log("::: set user :::");
  console.log("secret key = ",process.env.JWT_SECRET);

  const secret = new TextEncoder().encode(process.env.JWT_SECRET);

  console.log("secret = ",secret);

  return await new SignJWT({
    _id: user._id,
    email: user.email,
  })
    .setProtectedHeader({ alg: 'HS256' })
    .setExpirationTime('30d')
    .sign(secret);
}

export function getToken(req: NextRequest | Request) {
  console.log("::: get token :::");


  let cookieToken: string | undefined;

  console.log("next = ",req instanceof NextRequest);
  console.log("normal = ",req instanceof Request);

  // Handle NextRequest (has cookies)
  if (req instanceof NextRequest) {
    console.log("::: cookies :::");

    console.log(req.cookies);

    cookieToken = req.cookies.get(AUTHENTICATION.USER_TOKEN)?.value;
  }else {
    console.log("::: Request is Fetch API Request :::");

    // Extract cookies manually from headers
    const cookieHeader = req.headers.get('cookie');

    if (cookieHeader) {
      const cookies = parse(cookieHeader);
      cookieToken = cookies[AUTHENTICATION.USER_TOKEN];

      console.log("normal cookie token = ",cookieToken);
    }
  }
  console.log("cookie token = ",cookieToken);

  const authHeader = req.headers.get(AUTHENTICATION.AUTHORIZATION);

  const headerToken = authHeader?.startsWith(`${AUTHENTICATION.BEARER} `)
    ? authHeader.slice(AUTHENTICATION.BEARER.length + 1)
    : undefined;


  console.log(cookieToken || headerToken || null);

  console.log("::: get token completed :::");

  return cookieToken || headerToken || null;
}

export async function getUser(token: string) {
  try {
    console.log("::: get user :::");

    const secret = new TextEncoder().encode(process.env.JWT_SECRET);

    console.log("::: secret completed :::");
    console.log(secret);

    const { payload } = await jwtVerify(token, secret);

    console.log(":::payload completed :::");
    console.log(payload);
    return payload;
  } catch (error) {
    console.error('Invalid Token:', error);
    return Promise.reject(error);
  }
}

export async function getUserDetailsFromCookies(req: NextRequest | Request) {
  const token = getToken(req);

  if (!token) {
    return null;
  }

  const user = await getUser(token);

  return user ?? null;
}

export async function getUserEmailFromCookies(req: NextRequest | Request) {
  console.log("::: getUserEmailFromCookies ::: ")

  const token = getToken(req);

  console.log(token);
  if (!token) {
    throw new Error('No Token');
  }

  const user = await getUser(token);

  console.log(user);

  if (!user) {
    throw new Error(`No user found of this token ${token}`);
  }

  return user.email as string;
}

export async function getCookieHeader({userToken}:{userToken:string}){

    const cookieHeader = serialize(AUTHENTICATION.USER_TOKEN,userToken,{
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict',
      path: '/',
      maxAge: 60 * 60 * 24 * 30, //30 days
    });

    return {
      'Set-Cookie': cookieHeader,
      'Content-Type': 'application/json',
    }
}