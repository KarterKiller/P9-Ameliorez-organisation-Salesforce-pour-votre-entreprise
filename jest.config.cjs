module.exports = {
    moduleFileExtensions: ['js', 'json', 'jsx', 'ts', 'tsx', 'node'],
    moduleNameMapper: {
        '^@salesforce/apex/(.*)$': '<rootDir>/force-app/main/default/classes/Controllers/$1',
        '^lightning/(.*)$': '<rootDir>/force-app/main/default/lwc/$1' // Ajout pour éviter d'autres erreurs avec LWC
    },
    transform: {
        '^.+\\.(js|jsx|mjs|cjs|ts|tsx)$': 'babel-jest'
    },
    testEnvironment: 'jsdom',
    verbose: true,
    transformIgnorePatterns: ['<rootDir>/node_modules/']
};
