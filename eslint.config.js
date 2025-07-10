// eslint.config.js
import path from "path";
import { fileURLToPath } from "url";
import js from "@eslint/js";
import tseslint from "typescript-eslint";
import eslintPluginPrettierRecommended from "eslint-plugin-prettier/recommended";
import roblox from "eslint-plugin-roblox-ts-x";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const compat = new FlatCompat({
	baseDirectory: __dirname,
	resolvePluginsRelativeTo: __dirname,
});

export default tseslint.config(
	{
		plugins: {
			"roblox-ts-x": roblox,
		},
		rules: {
			"roblox-ts-x/no-any": ["error", { fixToUnknown: true }],
		},
	},
	{
		ignores: ["node_modules/", "dist/", "out/", "include/", "old_common/", ".config/"],
	},
	js.configs.recommended,
	...tseslint.configs.recommended,
	eslintPluginPrettierRecommended,
	{
		languageOptions: {
			parserOptions: {
				project: "./places/*/tsconfig.json",
				ecmaVersion: "latest",
				sourceType: "module",
				jsx: true,
				useJSXTextNode: true,
			},
		},
		rules: {
			"prettier/prettier": "warn",
		},
	},
);
