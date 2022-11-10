---
layout: default
title: How to contribute
nav_order: 6
---

# Contributing
## Reporting a bug or requesting a feature
If you have encountered a bug or would like to request or propose a new feature, please feel free to create a new issue using the appropriate template.

## Implementing a requested feature or fixing a known bug
If you want to fix a known bug or implement a new feature, please first create a fork of the repository.
After you have implemented your changes, you can propose them for inclusion in the project by creating a pull request from your fork.
Please link the issue of the implemented feature or the fixed bug in the pull request for clearness, or add the respective [keywords](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword#linking-a-pull-request-to-an-issue-using-a-keyword).

# Contributing as a project member
## Reporting a bug or requesting a feature
The process is identical to the previously mentioned process for contributors which are not part of the project.

## Solving an issue
The process to solve an already known issue (bug or feature request) is basically identical to the previously described process.
However, instead of creating a fork of the repository please create a branch with a descriptive name, which allows to understand it's purpose and it's relation to the targeted issue.
A good and easy option for this is to use the `Create a branch` link which can be found in the `Development` section of each issue.

## Creating a new release
Execute the following steps in order to create a new DiscoPoP release:
- Create a branch of the `master` with the name `release/1.2.3`
- Create a tag on the newly created branch with the name `v1.2.3`
    - Creating the tag triggers the automatic publication of the project to PyPi	
- Create a draft for the new release
    - Release target: the newly created branch `release/1.2.3`
    - Release tag: `v1.2.3`
    - Release title: `Version 1.2.3`
    - Description should contain a summary of the most relevant changes
- If everything is fine, create the new release