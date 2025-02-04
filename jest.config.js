const { jestConfig } = require('@salesforce/sfdx-lwc-jest/config');
  
module.exports = {
    ...jestConfig,
    moduleNameMapper: {
        '^@salesforce/apex/(.*)$': '<rootDir>/force-app/test/jest-mocks/lightning/MyTeamOrdersController'
    },
    modulePathIgnorePatterns: ['/.localdevserver']
};
  