import { UserInterface } from '@/model/User';
import { jwtVerify, SignJWT } from 'jose';
import { NextRequest } from 'next/server';
import { AUTHENTICATION } from '@/helpers/string_const';
import {serialize,parse} from "cookie";

export async function setUser(user: UserInterface) {

  const secret = new TextEncoder().encode(process.env.JWT_SECRET);


  return await new SignJWT({
    _id: user._id,
    email: user.email,
  })
    .setProtectedHeader({ alg: 'HS256' })
    .setExpirationTime('30d')
    .sign(secret);
}

export function getToken(req: NextRequest | Request) {


  let cookieToken: string | undefined;


  // Handle NextRequest (has cookies)
  if (req instanceof NextRequest) {


    cookieToken = req.cookies.get(AUTHENTICATION.USER_TOKEN)?.value;
  }else {

    // Extract cookies manually from headers
    const cookieHeader = req.headers.get('cookie');

    if (cookieHeader) {
      const cookies = parse(cookieHeader);
      cookieToken = cookies[AUTHENTICATION.USER_TOKEN];

    }
  }

  const authHeader = req.headers.get(AUTHENTICATION.AUTHORIZATION);

  const headerToken = authHeader?.startsWith(`${AUTHENTICATION.BEARER} `)
    ? authHeader.slice(AUTHENTICATION.BEARER.length + 1)
    : undefined;


  return cookieToken || headerToken || null;
}

export async function getUser(token: string) {
  try {

    const secret = new TextEncoder().encode(process.env.JWT_SECRET);


    const { payload } = await jwtVerify(token, secret);

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

  if (!user) {
    throw new Error(`No user found of this token ${token}`);
  }

  return user;
}

export async function getUserEmailFromCookies(req: NextRequest | Request) {

  const token = getToken(req);

  if (!token) {
    throw new Error('No Token');
  }

  const user = await getUser(token);


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


