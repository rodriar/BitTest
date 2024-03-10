
# Bitso Books



## Installation

Run xcode project. No need for external dependencies intallations.


## Architecture

This project follows the MVVM (Model-View-ViewModel) + C architecture to separate the presentation layer from the business logic, making the codebase more modular, scalable, and testable. Combine framework is used for data binding between the ViewModel and the View, enhancing the reactive programming paradigm within the app.
We also use the Input/Output enums to handle communication between components.
![Bitso Ark drawio](https://github.com/rodriar/BitTest/assets/22194427/66bf6630-8365-4f88-8e42-149de64f0ffb)


## Tests

Describe how to run the tests and what they cover. Explain the testing strategy: unit tests, UI tests, integration tests, etc.

```bash
To run the tests:
1. Open the project in Xcode.
2. Navigate to the test navigator by clicking on the diamond icon on the top left side or using the shortcut `Cmd + 6`.
3. You can run all tests by pressing `Cmd + U` or click the play button next to the individual test or test suite.
```

## Future Improvements

Outline the future roadmap and improvements you plan for your project. This could include:

- Better DI of number formatter.
- Mock BooksManager.
- Module per screen or per flow.
- Adding more tests to improve code coverage.
- UI/UX improvements.

