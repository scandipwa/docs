# Visual Studio Code Setup and Usage

## Setup

### Installation

Download and install Visual Studio Code from <https://code.visualstudio.com/>

### Configuration

In Visual Studio Code (VS Code further):
  - Open `Quick Open` by pressing `Ctrl + P`
  - Paste the following command: `ext install [INSERT ScandiPWA EXTENSION CODE]`
  - Press enter to install ScandiPWA extension
  - Now all recommended settings and extension will be downloaded and applied

## Usage

### Extension

Press `Ctrl + Shift + P` or `F1` key to open VS Code All commands list. Type `ScandiPWA` to show all available ScandiPWA extension commands. Note that all ScandiPWA extension command are prefixed with `ScandiPWA:`. To execute command select it and press `Enter`, then follow interactive configuration.

##### Commands List

| Command                 | Description                        |
| ----------------------- | ---------------------------------- |
| Create new component    | Bootstraps new ScandiPWA component |
| Create new query        | Bootstraps new ScandiPWA query     |
| Create new route        | Bootstraps new ScandiPWA route     |
| Extend source component | Extends source ScandiPWA component |
| Extend source query     | Extends source ScandiPWA query     |
| Extend source route     | Extends source ScandiPWA route     |

#### Extension Configuration

To configure `ScandiPWA` extension open VS Code settings. Settings can be opened by going to `File > Preferences > Settings`. Type `scandipwa` to find ScandiPWA Extension related configuration.

##### Settings List

| Name        | Description                          | Default value                             |
| ----------- | ------------------------------------ | ----------------------------------------- |
| Source Path | Path to ScandiPWA **source** package | `../../../../../vendor/scandipwa/source/` |


### JavaScript Snippets

When editing JavaScript file type one of the snippet prefixes listed below and press `Tab` to replace keyword with predefined template.

##### Snippets List

| Prefix      | Template                                 |
| ----------- | ---------------------------------------- |
| **exdf**    | Default export declaration for IndexJS   |
| **comp**    | Creates new ScandiPWA component          |
| **ecomp**   | Extends Source ScandiPWA component       |
| **cont**    | Creates new ScandiPWA container class    |
| **econt**   | Extends Source ScandiPWA container class |
| **con**     | Connects component to redux              |
| **mstp**    | Declares mapStateToProps                 |
| **mdtp**    | Declared mapDispatchToProps              |
| **qc**      | Creates new ScandiPWA query              |
| **eqc**     | Extends ScandiPWA Source query           |
| **eroute**  | Extends ScandiPWA Source Route component |
| **ecroute** | Extends ScandiPWA Source Route container |
| **crd**     | Creates reducer                          |
| **erd**     | Extends ScandiPWA reducer                |
| **cdisp**   | Creates new ScandiPWA dispatcher         |
| **edisp**   | Extends ScandiPWA dispatcher             |


### Additional Extensions

You can explore collection of recommended extensions to improve your workflow.

##### Additional Extensions List

 | Extension                                                                                                       | Description                                                                       |
 | --------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
 | [Better Comments](https://marketplace.visualstudio.com/items?itemName=aaron-bond.better-comments)               | Highlights comments according to theirs type                                      |
 | [Bookmarks](https://marketplace.visualstudio.com/items?itemName=alefragnani.Bookmarks)                          | Adds bookmarks to VS Code to help navigate in code                                |
 | [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker) | A basic spell checker                                                             |
 | [Debugger for Chrome](https://marketplace.visualstudio.com/items?itemName=msjsdiag.debugger-for-chrome)         | integrates Google Chrome debugger into VS Code                                    |
 | [EditorConfig for VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)       | Allows to use shared Editor Configuration via `.editorconfig` configuration files |
 | [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)                            | Integrates ESLint - JavaScript linter into VS Code                                |
 | [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)                                  | Git support for VS Code                                                           |
 | [Import Cost](https://marketplace.visualstudio.com/items?itemName=wix.vscode-import-cost)                       | Displays size of imported package in the editor                                   |
 | [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)                          | Allows auto formatting styles on save                                             |
 | [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync)                    | Used for syncing settings and extensions from Public Gist                         |
 | [Stylelint](https://marketplace.visualstudio.com/items?itemName=shinnn.stylelint)                               | Integrates Stylelint - SCSS linter into VS Code                                   |
 | [Trailing Spaces](https://marketplace.visualstudio.com/items?itemName=shardulm94.trailing-spaces)               | Highlights trailing spaces and deletes them                                       |
