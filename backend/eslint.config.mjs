import { dirname } from "path";
import { fileURLToPath } from "url";
import { FlatCompat } from "@eslint/eslintrc";

const _filename = fileURLToPath(import.meta.url); // No warning for unused variable
const _dirname = dirname(_filename); // No warning

const compat = new FlatCompat({
  baseDirectory: _dirname, // Still used, but prefixed to avoid warnings
});

const eslintConfig = [
  ...compat.extends("next/core-web-vitals", "next/typescript"),
];

export default eslintConfig;
