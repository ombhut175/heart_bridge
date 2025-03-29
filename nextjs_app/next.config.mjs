import type { NextConfig } from "next";

const nextConfig = {
  reactStrictMode: true,
  experimental: {
    // Any experimental features can be added here
  },
  // Ensure CSS processing is properly configured
  webpack: (config) => {
    return config;
  },
};

export default nextConfig;

