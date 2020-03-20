# Internal parts interaction

The data is passed through the application constantly. Multiple application parts are responsible for this data processing. Learn the main actors, data-pipes and conditions in this guide!

## Watch an explanation video

?> **Note**: video is in production

## The data-flow diagram

<style>
:root {
  --code-theme-selector: #0p00;
}
</style>

```
                 +-------------+
   1 user input  |             |
+----------------> A Component |
                 |             |
                 +-----------^-+                          +------------------------------+
                   |         |                            |                              |
  2 State changing |         | 8 Container updates        |   Magento (GraphQL server)   <---+
  user interaction |         | props of child component   |                              |   |
                   |         |                            +------------------------^-----+   |
             +------------------------+                                            |         |
             |                        |                                            |         |
             |     B Container        |                                            |         |
             |                        | NO      The data is requested from server  |         |
             |  Does it affect global +--------------------------------------------+         |
             |  state?                |                                                      |
             |                        |                                                      |
             +------------------------+                                                      |
               Y|     |                  Helpers are invoked                                 |
   * NOTE #1   E|     +--------------------------------------+                               |
               S|                                            |                               |
             +--v---------------------+                      |                               |
             |                        |                  +---v---------------------------+   |
             |    Is action result    |                  |                               |   |
        +---->      synchronous?      |                  |  E Utility / Helper function  |   |
        |    |                        |                  |                               |   |
        |    +------------------------+                  +------------------^------------+   |
        |       |                  |                                        |          |     |
        |     Y |                N | 3 Payload is passed to                 |          |     |
        |     E |                O | asynchronous action dispatcher         |          |     |
        |     S |                  |                                        |          |     |
        |       |     +------------v----------+    4 Helpers are invoked    |          |     |
        |       |     |                       +-----------------------------+          |     |
        |       |     |  C Action Dispatcher  |                                        |     |
        |       |     |                       <----------------------------------------+     |
        |       |     +-----------------------+   5 Asynchronous response is returned        |
        |       |        |             |                                                     |
        |       |        |             |             The data is requested from server       |
        |       |        |             +-----------------------------------------------------+
        |       |        |
        |       |        |
        |       |        |                   +--------------------+
        |       |        |                   |                    |
        |       +--------v------------------->  D Action Reducer  +----+
        |           6 Action is dispatched   |                    |    |
        |                                    +--------------------+    |
        |                                                              |
        +--------------------------------------------------------------+
                    7 Action result updates the state
```

## Who are the main actors?

-   **A** – Component
    -   Naming convention: `Feature.component.js`
    -   Implements the data display functional
-   **B** – Container
    -   Naming convention: `Feature.container.js`
    -   Relates the component with Redux global state
-   **E** – Utility / Helper function
    -   Naming convention: `Helper.js`
    -   Utility functional which implements the common logic
-   **GraphQL server**
    -   The Magento 2, working via the GraphQL API

Following parts (after the **NOTE #1**), are only involved if the global state update is required:

-   **unmentioned** – Action Declaration
    -   Naming convention: `Feature.action.js`
    -   Declare action interface (arguments and returned values)
-   **C** – Action Dispatcher
    -   Naming convention: `Feature.dispatcher.js`
    -   Dispatches the Redux global state actions
-   **D** – Action Reducer
    -   Naming convention: `Feature.reducer.js`
    -   Handles the state update, applies Redux action results to global state

## What is going on?

!> **Note**: the passthrough to the Redux is not obligatory, I would say it is an anti-pattern. You must only involve the Redux (global state), if more than one or two components in completely different places of application must know about that. The best examples are: `cart`, `account`. ScandiPWA has some redundant states in it. Their amount will be reduced in the future.

1.  User input (`User -> A`)
2.  Global state changing user interaction (`A -> B`)
3.  Event payload is passed to asynchronous action dispatcher (`B -> C`)
4.  Helpers are invoked (`C -> E`)
5.  Asynchronous response is returned from helper (`E -> C`)
6.  Action is dispatched (`C -> D`, `B -> D`)
7.  Action result updates the state (`D -> B`)
8.  Container updates props of child component (`B -> A`)

