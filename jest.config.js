const { jestConfig } = require('@salesforce/sfdx-lwc-jest/config');

module.exports = {
    ...jestConfig,
    moduleNameMapper: {
        '^@salesforce/apex/(.*)$': '<rootDir>/force-app/test/jest-mocks/lightning/MyTeamOrdersController'
    },
    modulePathIgnorePatterns: ['/.localdevserver'],
    
    collectCoverage: true,
    
    collectCoverageFrom: [
        'force-app/main/default/lwc/**/*.js',
        '!force-app/main/default/lwc/**/__tests__/**',
        '!**/node_modules/**',
        '!**/coverage/**',
        '!**/sorter.js',
        '!**/block-navigation.js',
        '!**/prettify.js',
        '!jest.config.js',  
        '!**/MyTeamOrdersController.js'
    ],

    testPathIgnorePatterns: [
        '/node_modules/',
        '/coverage/',
        'sorter.js',
        'block-navigation.js',
        'prettify.js'
    ],

    coverageDirectory: "<rootDir>/force-app/main/default/lwc/__tests__/coverage",
    coverageReporters: ["text", "lcov"],
};
