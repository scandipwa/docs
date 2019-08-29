# Visual Studio Code Setup and Usage

## Setup

### Installation

Download and install Visual Studio Code from <https://code.visualstudio.com/>

### Configuration

In Visual Studio Code (VS Code further):
- Open `Quick Open` by pressing `Ctrl + P`
- Paste the following command: `ext install Shan.code-settings-sync`
- Press enter to install Settings Sync extension
- If Settings Sync tab is not opened, press `Shift + Alt + D` to open
- Select `Download Public Gist` in Configuration section
- Enter following Gist ID: `abc132`
- Now all recommended settings and extension will be downloaded and applied

## Usage

### Extensions List

- [Better Comments](https://marketplace.visualstudio.com/items?itemName=aaron-bond.better-comments) - Highlights comments according to theirs type
- [Bookmarks](https://marketplace.visualstudio.com/items?itemName=alefragnani.Bookmarks) - Adds bookmarks to VS Code to help navigate in code
- [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker) - A basic spell checker
- [Debugger for Chrome](https://marketplace.visualstudio.com/items?itemName=msjsdiag.debugger-for-chrome) - integrates Google Chrome debugger into VS Code
- [EditorConfig for VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig) - Allows to use shared Editor Configuration via `.editorconfig` configuration files
- [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint) - Integrates ESLint - JavaScript linter into VS Code
- [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens) - Git support for VS Code
- [Import Cost](https://marketplace.visualstudio.com/items?itemName=wix.vscode-import-cost) - Displays size of imported package in the editor
- [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) - Allows auto formatting styles on save
- [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) - Used for syncing settings and extensions from Public Gist
- [Stylelint](https://marketplace.visualstudio.com/items?itemName=shinnn.stylelint) - Integrates Stylelint - SCSS linter into VS Code
- [Trailing Spaces](https://marketplace.visualstudio.com/items?itemName=shardulm94.trailing-spaces) - Highlights trailing spaces and deletes them


### JavaScript Snippets

When editing JavaScript file type one of the snippet prefixes listed below and press `Tab` to replace keyword with predefined template.

#### Snippets

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

### JavaScript Keybindings

When editing JavaScript file select Component Variable and press `Ctrl + Alt + R` to insert **con** snippet with Component Variable inside.
