/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
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
