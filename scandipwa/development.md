# Development guide

This article will guide you through the best-practices working with ScandiPWA. Showcase the path from the freshly installed theme to the production-ready product!

## Preparing the environment

Make sure your development environment is configured well. New stack might require new tools. Let's see how can we configure them!

### VSCode

The tools and editors are essential. For PHP - there is a standard "PHPStorm" for React development we encourage using [VSCode](https://code.visualstudio.com/). This is a very popular code editor, with a powerful extension API. We even [have our own](https://github.com/scandipwa/scandipwa-development-toolkit) to help you develop your store faster! Watch the video to configure your editor!

<iframe width="560" height="315" src="https://www.youtube.com/embed/hmzcmb611x0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

The  VSCode extensions mentioned:
- [Better comments](https://marketplace.visualstudio.com/items?itemName=aaron-bond.better-comments) - the comment highlights
- [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker) - write without typos
- [Debugger for Chrome](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker) - remote debugger for chrome
- [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint) - JS code-style validator
- [GitLense](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens) - better Git integration
- [ScandiPWA VSCode snippets](https://github.com/scandipwa/scandipwa-development-toolkit) - ScandiPWA extension helper
- [stylelint](https://marketplace.visualstudio.com/items?itemName=stylelint.vscode-stylelint) - SCSS code-style validator
- [Trailing Spaces](https://marketplace.visualstudio.com/items?itemName=shardulm94.trailing-spaces) - left-over spaces highlighter

### ESLint and StyleLint - code-style validators

Matching code-style is very important. The consistent tabulation, the proper imports, everything matters! We even made [our own ESLint plugin](https://www.npmjs.com/package/@scandipwa/eslint-plugin-scandipwa-guidelines) (for the next ScandiPWA version)!

!> **Note**: it is mandatory to install the ESLint and StyleLint! This will help a lot later, when inspecting the source code or contributing! Please do not skip this step!

<iframe width="560" height="315" src="https://www.youtube.com/embed/3nO6m4zDnqs" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

### Chrome remote Debugging

Configuring the remote debugging can be quite challenging. Debugging in the browser requires additional tools. Watch the tutorial video, and configure your Chrome and VSCode for remote debugging.

<iframe width="560" height="315" src="https://www.youtube.com/embed/cyDwoVLH_hA" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Chrome extensions mentioned in this video:
- [React Developer Tools](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi?hl=en) - the component state & props inspector
- [Redux DevTools](https://chrome.google.com/webstore/detail/redux-devtools/lmhkpmbekcpmknklioeibfkpmmfibljd?hl=en) - the global state inspection tool

### GraphQL Playground

Knowing the GraphQL schema is important. Using reliable tools from the very begging is crucial for fast delivery. Install them beforehand.

<iframe width="560" height="315" src="https://www.youtube.com/embed/27IHNDG4Kaw" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

The tools mentioned in the video:
- [GraphQL Playground](https://github.com/prisma-labs/graphql-playground) - the best GraphQL schema editor
- [Postman](https://www.postman.com/) - the best API explorer

## Learning the basics

Before we get into modules, examples, and best-practices let's build a solid ground of the underlying methodology understanding.

### File structure

We proved that flat file structure is beneficial (see more in the [organization patterns article](/scandipwa/organization.md)).

Now, it is time to get familiar in the close up look. The overview of themes location, internal folder-structure, and the naming conventions overview can be found in that guide.

[<span class="Button">Explore file structure</span>](/scandipwa/development/file-structure.md)

### Component architecture

The SPA main goal is to transfer the data into the output on the client's screen. Learn how the data is flowing through the application and what part of the application is responsible for what task.

[<span class="Button">Traverse Data-flow diagram</span>](/scandipwa/development/data-flow.md)

### Override mechanism

No modification to the source-code, fluid migrations from version to version - no need to git-merge the changes.

Those are the benefits of our override mechanism. It allows to build on top of the vendor theme like in M2 - just create a file with the same name and location!

[<span class="Button">Dive into Override mechanism</span>](/scandipwa/development/overrides.md)

### Debugging guide

Being able to find out what is going on, why, and where is crucial for an effective project delivery. We, developers, call this debugging.

[<span class="Button">Discover debugging hints</span>](/scandipwa/development/debugging.md)

## Going advanced

Time to begin the project development! Let's take a look on our recommendations on real project development. From the base-template creation to the component architecture and most common code-review mistakes.

### Base template (theming)

Every design is different. But each has some base elements it is build out of. These base elements, common styles, resets are called project`s "base-template". The best approaches for base element styling, font loading and the common element implementation in one place.

[<span class="Button">start base template development</span>](/scandipwa/advanced/base-template.md)

### GraphQL resolver creation

The new way to communicate with a server is called the GraphQL API. Graphs... Sounds very complicated to develop for! Afraid not, we got you covered! Turns out it is a pretty simple task!

Learn how to define the GraphQL resolver and modify the schema in Magento 2!

[<span class="Button">Create first GraphQL resolver</span>](/scandipwa/advanced/creating-resolver.md)

### Connect to GraphQL resolver

You already have a GraphQL resolver? Wow! Awesome. Learn how to connect it to the front-end and make the data request. Learn the difference in request methods!

[<span class="Button">Connect to the GraphQL resolver</span>](/scandipwa/advanced/connecting-resolver.md)
