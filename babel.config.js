module.exports = {
  presets: [
    ['@babel/preset-env', { targets: { node: 'current' } }],
    ['@babel/preset-typescript', { 
      allowDeclareFields: true,
      onlyRemoveTypeImports: true,
      // Allow parsing of TypeScript-specific syntax
      isTSX: false,
      allExtensions: false
    }]
  ],
  plugins: [
    ['@babel/plugin-proposal-decorators', { legacy: true }],
    // Add support for TypeScript syntax features
    '@babel/plugin-syntax-typescript'
  ],
  // Only apply to JavaScript and TypeScript files
  ignore: [
    'node_modules/**',
    '**/*.d.ts'
  ]
};
