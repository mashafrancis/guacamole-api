module.exports = {
  verbose: true,
  roots: [
    '<rootDir>/src'
  ],
  transform: {
    "^.+\\.tsx?$": "ts-jest"
  },
  testRegex: "(/__tests__/.*|(\\.|/)(test|spec))\\.(jsx?|tsx?)$",
  moduleFileExtensions: [
    "ts",
    "tsx",
    "js",
    "jsx",
    "json",
    "node"
  ],
  coverageReporters: [
    'html',
    'json',
    'lcov',
    'text',
    'clover'
  ],
  modulePathIgnorePatterns: ['<rootDir>/node_modules'],
  collectCoverage: true,
  collectCoverageFrom: ['src/**/*.ts', 'src/**/*.tsx', '!src/**/interface.d.ts', '!src/**/*interfaces.d.ts'],
  coverageThreshold: {
    global: {
      'branches': 0,
      'functions': 0,
      'lines': 0,
      'statements': 0
    }
  },
  testEnvironment: 'node'
};
