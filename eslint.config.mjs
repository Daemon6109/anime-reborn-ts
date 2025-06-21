import js from '@eslint/js';
import tseslint from 'typescript-eslint';

export default tseslint.config(
    js.configs.recommended,
    ...tseslint.configs.recommended,
    {
        rules: {
            '@typescript-eslint/no-unused-vars': 'warn',
            '@typescript-eslint/no-explicit-any': 'warn',
        },
    },
    {
        ignores: [
            'out/**',
            'dist/**',
            'node_modules/**',
            'include/**',
            'tasks/**',
            'scripts/js/**',
            'jest.config.js',
            'eslint.config.js',
        ],
    }
);
