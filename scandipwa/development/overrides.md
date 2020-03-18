# Guide into overriding

ScandiPWA is not meant to be modified, rather extended. This means no changes must be done it the source theme (`vendor/scandipwa/source`), rather changes in `app/design/frontend/<VENDOR>/<THEME>` must be made.

## A step-by-step algorithm for JavaScript

You create a file with the same name, under the same folder - reference the `vendor/scandipwa/source` to find the exact name and file. But in general, the algorithm is as follows:

1. **Find out the component** name using web-inspector. The name of the component can be found using following algorithm:

   1. Using inspector find an element you want to change, i.e. `.Header-Button_type_menu` element.

   2. Because of [BEM](https://en.bem.info/methodology/) element with class `.Header-Button_type_menu` is clearly related to `Header` component, and **must** be declared there.

2. Knowing the component name, it is time to **decide what would you like to change**:

    1. If the logic change is intended, our you plan to connect to the global state - override the `<COMPONENT NAME>.container.js`.

    2. If the presentation change is intended - you need to override the `<COMPONENT NAME>.component.js`.

    3. If styles are intended to change completely, you need to override the `<COMPONENT NAME>.style.scss`.

    4. If you only want to adjust style, you will need to create and import new additional file - `<COMPONENT NAME>.style.override.scss`

        > **Note**: you are required to import this new style file in `<COMPONENT NAME>.component.js` or, even in `<COMPONENT NAME>.container.js`, it just must be imported.

3. Using the [VSCode extension](https://github.com/scandipwa/scandipwa-development-toolkit) or manually **create a files with the correct name in the correct folder**. The folder naming logic is as follows:

    1. If it is the component, not the route (i.e. `ProductPage`, `CategoryPage`, `MyAccount`, `Checkout`) you will find it in the `app/component/<COMPONENT NAME>/` folder. For example, the `Header` is located in `app/component/Header/`.

    2. If it is a page, or a route - search for it in the `app/route/<COMPONENT NAME>/`.

    > **Note**: there will never be a component folder nested in another component folder! The file-structure is flat, and consistent.

4. The file is created, what next? Time to write some JavaScript. The main idea for extension - you are replacing the file, so all exposed "API"s especially `export` must be preserved. The general template looks as follows:

    ```javascript
    import { /** Exports I plan to modify or reuse */ } from '<PATH TO SOURCE COMPONENT>';

    // TODO: implement the modifications to imported parts

    export { /** Export all unmodified exports */ } from '<PATH TO SOURCE COMPONENT>';

    export { /** Exports I have overridden */ };

    export default /** copy the original default export */;
    ```

    Following notes apply:

    1. The `<PATH TO SOURCE COMPONENT>` **MUST** refer to file, not the folder, i.e. instead of: `component/Header` write `component/Header/Header.component`.

    2. The default export must be preserved - the new, extended class must contain the same logic, i.e. if I have following in the code: `export default connect(mapStateToProps, mapDispatchToProps)(Header);` I must import the connect from redux (just like in source component), `mapStateToProps` and `mapDispatchToProps` from source file I am extending, and ensure my component, contains the same default export.

    3. Importing `import { A } from '...';` is not similar to: `import A from '...';` first code imports the named export, second - default export. You most probably want to **use the named export** (the first option, with curly brackets).

Let's now consider a common cases, to prove the algorithm works.

## Overriding the main router

The original router file is located in `app/route/index.js`. It is common to extend it in order to add new routes, here is a template to use:

```js
// importing the necessary module to implement the "default export"
import { connect } from 'react-redux';

// importing all parts of original header planned to modify
import {
    BEFORE_ITEMS_TYPE,
    // SWITCH_ITEMS_TYPE,
    // AFTER_ITEMS_TYPE,
    mapStateToProps,
    mapDispatchToProps,
    AppRouter as SourceAppRouter
} from 'SourceRoute';

// export all unmodified exports from original file
export {
    CartPage,
    CategoryPage,
    Checkout,
    CmsPage,
    HomePage,
    MyAccount,
    NoMatchHandler,
    PasswordChangePage,
    ProductPage,
    SearchPage,
    SomethingWentWrong,
    UrlRewrites,
    MenuPage,
    BEFORE_ITEMS_TYPE,
    SWITCH_ITEMS_TYPE,
    AFTER_ITEMS_TYPE,
    history
} from 'SourceRoute';

// modify the intended part of the logic, notice, the class is also exported!
export class AppRouter extends SourceAppRouter {
    constructor(props) {
        super(props);

        this[BEFORE_ITEMS_TYPE].push({ /** ... */ });
    }
}

// preserve the default export
export default connect(mapStateToProps, mapDispatchToProps)(AppRouter);
```

## Overriding the Header component & container

Imagine you want to extend the Header functionality, by adding additional state to it. This requires to extend the original component and container. Here is a template for them (files are: `app/component/Header.component.js` and `app/component/Header.container.js`).

```js
// importing all parts of original header planned to modify & reuse
import SourceHeader from 'SourceComponent/Header/Header.component';

// WARNING: the Header class is not correctly exported, in future versions, ^ this might become `import { Header as SourceHeader } from ...;`.

// exporting custom variables for use in other components
export const MY_STATE = 'MY_STATE';

// modify the intended part of the logic, notice, the class is also exported!
export class Header extends SourceHeader {
    constructor(props) {
        super(props);

        this.stateMap[MY_STATE] = { /** ... */ };
    }
}

// export all unmodified exports from original file
export {
    PDP,
    POPUP,
    CATEGORY,
    CUSTOMER_ACCOUNT,
    CUSTOMER_SUB_ACCOUNT,
    CUSTOMER_ACCOUNT_PAGE,
    HOME_PAGE,
    MENU,
    MENU_SUBCATEGORY,
    SEARCH,
    FILTER,
    CART,
    CART_EDITING,
    CHECKOUT,
    CMS_PAGE
} from 'SourceComponent/Header/Header.component';

// preserve the default export
export default Header;
```

Cool, the state declared, now it is time to add default URL handler for it:

```js
// importing the necessary module to implement the "default export"
import { connect } from 'react-redux';

// importing all parts of original header planned to modify
import {
    mapStateToProps,
    mapDispatchToProps,
    HeaderContainer as SourceHeaderContainer
} from 'SourceComponent/Header/Header.container';

// importing from overridden component
import { MY_STATE } from 'Component/Header/Header.component';

// modify the intended part of the logic, notice, the class is also exported!
class HeaderContainer extends SourceHeaderContainer {
    constructor(props) {
        super(props);

        this.routeMap['/my-route'] = {
            name: MY_STATE,
            onMyButtonClick: this.onMyButtonClick.bind(this)
        };
    }

    onMyButtonClick() {
        // TODO: implement the click handler
    }
}

// preserve the default export
export default connect(mapStateToProps, mapDispatchToProps)(HeaderContainer);
```

## Overriding the styles

For styles nothing changes. You create a file under the same name and it gets included into the bundle. Sometimes, the restart of frontend container is needed, because of the webpack cache. The sole exception to this general rule is the `src/app/style/abstract/_abstract.scss` file. Because it is auto-imported by webpack in all `*/**.scss` files. If you plan to override it:

1. Create the file importing original styles, like this:

    ```scss
    // In case you made no changes
    @import '../../../../../../../../../vendor/scandipwa/source/src/app/style/abstract/variables';
    @import '../../../../../../../../../vendor/scandipwa/source/src/app/style/abstract/media';
    @import '../../../../../../../../../vendor/scandipwa/source/src/app/style/abstract/button';
    @import '../../../../../../../../../vendor/scandipwa/source/src/app/style/abstract/loader';

    // In case you have overrides for the files
    @import './icons';
    @import './parts';

    // Here, you can add your files
    @import './my-abstract-style';
    ```

2. In both webpack configurations (`webpack.development.config.js`, `webpack.production.config.js`) change following line:

    ```js
    path.resolve(fallbackRoot, 'src', 'app', 'style', 'abstract', '_abstract.scss') // from "fallbackRoot"
    path.resolve(projectRoot, 'src', 'app', 'style', 'abstract', '_abstract.scss') // to "projectRoot"
    ```

## Overriding templates (HTML, pHTML)

ScandiPWA has a long-standing bug - the templates are impossibble to override. For some reason, they are always taken from vendor folder, instead of the theme. Becuase of that, in order to change anything inside of the `src/public/index.development.html` or `src/public/index.production.phtml` you must:

1. Rename the files, in exmaple, from `src/public/index.development.html` to `src/public/my-index.development.html`, and from `src/public/index.production.phtml` to `src/public/my-index.production.phtml`.

    > **Note**: we renamed from `index` to `my-index`! You can rename to anything else.

2. Change their webpack import declarations. In both webpack configurations (`webpack.development.config.js`, `webpack.production.config.js`) change following line:

    ```js
    // In the "webpack.production.config.js"
    path.resolve(projectRoot, 'src', 'public', 'index.production.phtml') // from "index.production.phtml"
    path.resolve(projectRoot, 'src', 'public', 'index.production.phtml') // to "my-index.production.phtml"

    // In the "webpack.development.config.js"
    path.resolve(projectRoot, 'src', 'public', 'index.development.html') // from "index.development.html"
    path.resolve(projectRoot, 'src', 'public', 'my-index.development.html') // to "my-index.development.html"
    ```

3. Reload the webpack. If using docker the following command should be executed:

    ```bash
    # if you have the alias set up
    dcf restart frontend

    # without aliases (not recommended)
    docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml -f docker-compose.frontend.yml restart frontend
    ```

    If using without docker - stop the server, then start it again.

## Extending reducers & actions

The reducers are not classes. The actions are simple functions. Here is an instruction to do both: create new action, update initial state.

To extend the action, in example the `src/app/store/Navigation/Navigation.action.js`. Create the file with same name and path in your theme (`app/design/<VENDOR>/<THEME>`), then do following:

```js
// import constants you plan to use
import {
    CHANGE_NAVIGATION_STATE
} from 'SourceStore/Navigation/Navigation.action';

// redeclare, modify the original action
export const changeNavigationState = (navigationType, navigationState, myVariable) => ({
    type: CHANGE_NAVIGATION_STATE,
    navigationType,
    navigationState,
    myVariable
});

// declare new action type
export const MY_CUSTOM_ACTION = 'MY_CUSTOM_ACTION';

// declare new action
export const myCustomAction = myVariable => ({
    type: MY_CUSTOM_ACTION,
    myVariable
});

// export unchanged constants from original file
export {
    GOTO_PREVIOUS_NAVIGATION_STATE,
    CHANGE_NAVIGATION_STATE,
    goToPreviousNavigationState
} from 'SourceStore/Navigation/Navigation.action';
```

Extending reducer is a little more complex. The main idea is to create a switch before the original reducer, where if new / necessary action type is found - return the state update, else call original reducer. Take a look:

```js
// import outside dependencies needed for extension
import {
    DEFAULT_STATE
} from 'Component/NavigationAbstract/NavigationAbstract.container';

import { MY_CUSTOM_ACTION } from './Navigation.action';

// import constants you plan to modify, reuse
import sourceNavigationReducer, {
    initialState as sourceInitialState,
} from 'SourceStore/Navigation/Navigation.reducer';

// declare anything needed for the reducer
export const MY_NEW_NAVIGATION_TYPE = 'MY_NEW_NAVIGATION_TYPE';

const handleMyCustomAction = (action) => {
    // take the payload of the action
    const { myVariable } = action;

    return {
        // update the global state
        ...state
    };
};

// extend initial state, export it
export const initialState = {
    ...sourceInitialState,
    [MY_NEW_NAVIGATION_TYPE]: {
        navigationState: DEFAULT_STATE,
        navigationStateHistory: [DEFAULT_STATE]
    }
};

// extend the reducer with custom action handler
const NavigationReducer = (state = initialState, action) => {
    const { type } = action;

    switch (type) {
    case MY_CUSTOM_ACTION:
        return handleMyCustomAction(action);
    default:
        return sourceNavigationReducer()
    }
};

// export the new reducer as default
export default NavigationReducer;
```

## Need more examples?

Other component extension is similar. Please re-read the step-by-step algorithm, this really helps!

Are you still struggling? [Join the Slack channel](https://join.slack.com/t/scandipwa/shared_invite/enQtNzE2Mjg1Nzg3MTg5LTQwM2E2NmQ0NmQ2MzliMjVjYjQ1MTFiYWU5ODAyYTYyMGQzNWM3MDhkYzkyZGMxYTJlZWI1N2ExY2Q1MDMwMTk) and do not hesitate to share your problems there!
