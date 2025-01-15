# Xiangshuo-VoiceOut

#auth0 account admin@voiceout.pro
#auth0 password  Voiceoutmin666!

## Table of Contents
1. [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
2. [Usage](#usage)
3. [Contributing](#contributing)

## Getting Started

### Prerequisites

Xcode (v15.3 or above)

### Installation

``git clone git@github.com:Xiangshuo-VoiceOut/Xiangshuo-VoiceOut-frontend.git``

## Usage

 - Product scheme run with app language 'Chinese, Simplified' and app region 'China mainland'
 - Folder Structure MVVM
```
📦 voiceout
├─ Resources                                                  ## external resources
├─ Utils                                                      ## foundation styles(defines functional tokens) and util shared globally
├─ Models                                                     ## class objects that hold data 
├─ Services                                                   ## API calls
├─ ViewModels                                                 ## structure should align with View
└─ Views
   ├─ Common                                                  ## shared components
   └─ Major screens, ex Authentication
      └─ Components                                           ## children components in major screen
```

## Contributing
### Bug Reports and Feature Requests

If you encounter any bugs or have ideas for enhancements, please submit an issue on GitHub. When submitting an issue, please include:

- A clear and descriptive title. ex, [FEATURE NAME] - ISSUE SUMMARY
- Steps to reproduce the bug, if applicable.
- Expected behavior.
- Any relevant screenshots or error messages.

### Pull Requests

We encourage you to submit pull requests to fix bugs, add new features, or improve existing ones. Follow these steps to contribute:

1. Fork the repository and create your branch from `main`.
2. Implement your changes, ensuring they adhere to the coding standards and conventions outlined below.
3. Test your changes thoroughly.
4. Open a pull request, including a clear description of the changes and their purpose.
5. Mention any related issues or pull requests in the description.
6. Try to minimize PR size and break down the ticket/issue when necessary.

### Commit Message Conventions

When committing changes, follow these guidelines for commit messages:

- Use the imperative mood ("Add feature" instead of "Added feature").
- Keep messages concise and descriptive.
- Prefix the commit message with a relevant tag:
  - [Feature Name]: For new features.
  - [Fix]: For bug fixes.
  - [Refactor]: For code refactoring.
  - [Docs]: For documentation updates.
  - [Test]: For adding or modifying tests.

### Workflow Procedures

Follow this workflow when working on the project:

1. Heads up in the channel which issue you are going to start working on and help each other review ticket content to avoid work conflicts.
2. Pull the latest changes from the `main` branch before starting any work.
3. Create a new branch for each feature or bug fix.
4. Commit your changes regularly, with clear and descriptive messages.
5. Push your changes to your forked repository.
6. Open a pull request to merge your changes into the main repository.
7. Participate in code reviews and address any feedback received. (Please constantly heads up in the channel when finished review PR or adjust PR)
8. Once get at least 1 approved, make sure squash all commits and merge into the main branch.
9. Delete branch after merged.
