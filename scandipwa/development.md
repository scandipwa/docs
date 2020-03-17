# Development guide

This article will guide you through the best-practices working with ScandiPWA. Showcase the path from the freshly installed theme to the production-ready product!

## Preparing the environment

Make sure your development environment is configured well. New stack might require new tools. Let's see how can we configure them!

### VSCode

> **TODO**: guide though the necessary extensions & customizations required to efficiently work with ScandiPWA. Share the video recording.

### ESLint and StyleLinters

> **TODO**: guide thought the installation and explain the necessity. Make sure EVERYONE is using it. Share the video recording.

### Chrome remote Debugging

> **TODO**: guide through the installation quirks of the VSCode remote debugger for Chrome. Share the video recording.

### GraphQL Playground

> **TODO**: showcase the tool and explain the usage benefits. Showcase common use scenarios. Showcase the embedded debugger. Share the video recording.

## Learning the basics

Before we get into modules, examples, and best-practices let's build a solid ground of the underlying methodology understanding.

### File structure

We proved that flat file structure is beneficial (see more in the [organization patterns article](/scandipwa/organization.md)).

Now, it is time to get familiar in the close up look. The overview of themes location, the internal folder-structure and the pattern observation can be found in the ["File structure 101"]() guide.

### Override mechanism

No modification to the source-code, fluid migrations from version to version - no need to git-merge the changes.

Those are the benefits of our override mechanism. It allows to build on top of the vendor theme like in M2 - just create a file with the same name and location!

Sounds interesting? Dive into the ["Overriding mechanism guide"](/scandipwa/overrides.md) now!

### Debugging guide

> **TODO**: define a behavior pattern to debug the application. From a chrome inspector to the source folder. How BEM helps?

## Going advanced

Time to begin the project development! Let's take a look on our recommendations for base-template creation and the 