/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  eslint: {
    // Warning: This allows production builds to successfully complete even if
    // your project has ESLint errors.
    ignoreDuringBuilds: true,
  },
  typescript: {
    // !! WARN !!
    // Dangerously allow production builds to successfully complete even if
    // your project has type errors.
    // !! WARN !!
    ignoreBuildErrors: true,
  },
  experimental: {
    // Configure Turbopack here
    turbo: {
      // Turbopack-specific configuration
      rules: {
        // Add any Turbopack-specific rules if needed
      },
    },
  },
  // Webpack configuration - this will be used when not using Turbopack
  webpack: (config) => {
    return config;
  },
};

module.exports = nextConfig;
