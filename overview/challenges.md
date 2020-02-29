# SPA application challenges

> **Note**: challenges described here are common to any SPA application. The ScandiPWA (and alternative solutions) way of solving those challanges is [described here](./existing_solutions.md).

By design Magento front-end can not be separated from the Magneto back-end. This is because it is rendered on the server side, so you need a complete Magento instance to render the HTML for the browser (client).

This aspect means that running in the high-loaded environment can be challenging. The resources needed to render the page are huge. To leverage the load, it is common to have multiple Magento instances serving the single purpose of rendering the HTML pages to the client.

The SPA is capable of rendering the page on its own. It only requires the data coming from server. This means, it is enough to have just the static files (scripts and styles **and not the whole Magento!**) to render the HTML.

The multiple smaller servers (not Magento) serving the static files of the front-end only are called headless servers.

## What challenge does a headless frontend bring?

Due to the SEO requirements we cannot just return static files (scripts and styles) of the application.

**Why?** Because crawlers are not browsing the SPA. They are reading the generated HTML and opening the found links in "new windows". This means our history manipulation is not relevant and is not working for crawlers. Each page is requested directly from the server.

Therefore, we need to make sure the responses from the server (status codes) are correct. For example, if a page is not found, we should respond with 404, which is impossible to achieve without a server. The server returning just those static files and making sure the response codes are correct is called the headless server (aka headless frond-end sever).

As stated above, the crawlers require the complete page HTML to parse the information inside. By design, SPA is not providing this HTML immediately. It needs to initialize scripts before content becomes available to the client. This means that crawlers are not able to parse any CSR page out-of-the-box.

## How to make crawlers parse the CSR pages?

There are two main options: hybrid rendering (SSR + CSR) or pre-rendering.

**What is hybrid rendering?** This is a way of rendering an application, where the same application is running on both FE and BE. The BE is generating the "HTML upshell" – the skeleton-like structure that contains the most important page data – SEO-valuable content (like meta tags, headings). Since you cannot have two different HTML templates for the client and the server, this approach requires the **NodeJS server**, in order to run the same scripts that browser uses for rendering. Additionally, it requires a **conditional rendering** (complicated rendering logic), where you need to render different content depending on the context - server-side or client-side, as on the server, we are rendering the SEO-valuable content only. This solution is known for it's complexity, as you are required to maintain 2 versions of your website - server-side rendered and client-side rendered.

**What is pre-rendering?** This is a way to generate the HTML of the page using a separate service that runs the browser in a headless mode. The headless browser is a browser that you can run on the server. By running the browser (e.g. Google Chrome) on server, we are using the same HTML template for page rendering as the client. This allows to generate the HTML on the server without modifying the code-base. We now do not need two separate logics for client-side rendering and server-side rendering. This approach is **known for it's simplicity**. But it is **slower (more resource-heavy) then hybrid rendering**.

For the implementation of the hybrid rendering, we need either to completely overwrite the BE using the NodeJS or introduce an additional layer between your BE and FE. The pre-rendering is a standalone service with no dependencies. So, the middleware layer introduction VS keeping the single server responsible for the application rendering is another challenge of SPA.

## How to communicate with a server?

Previously the standart way of implementing the API was REST. Rest was known for its ease - you define an endpoint, and communicate with it using JSON. On large scale, however, REST is hard to master. With commonly more than 100 enpoints, it was almost impossible to remember. Additionally the data that was returned by the endpoint was often very detailed. Too big payloads required a way to request specific fields only. Multiple solutions arraised and standartization became neccessary. The GraphQL became the new standart.

What was introduced in GraphQL? First, the endpoint count was decreased to 1. The schema concept was added. Now, the developer could ask for schema to understand what information can be recieved from the endpoint. Finally, the "query language" was added in order to specify which exact fields must be returned from the server. The GraphQL however, is slower then REST API. This is becuase it requires a recursive parsing of the requested information and then "asyncronious" resolution.

Some languages like PHP do not support the asyncronious code execution. This makes PHP GraphQL server respond longer then NodeJS server. This means Magento 2 will be responding slower to QraphQL requests than the NodeJS server (assuming calculation has the same complexity). Introduction of additional servers, however, means decreasing data-integrity.

However, if the data-integrity is compromised, the midleware could take care of the GraphQL parsing.

## How to cache API calls efficently?

Using the REST API, there is no issue - the communication happens via GET requests that are very easy to cache by the URL key. The POST requests on the other hand are mostly made for sensitive data communication and by default they cannot be cached.

GraphQL by design is using POST requests to communicate with the server. This complicates the process of caching GraphQL requests. We need a mechanism to transform the POST request into cachable GET request so we could use established tools like Varnish.

In order to achive that, the persisted-query approach can be used. Initially introduced by Appolo, it's main principle is to transform a GraphQL query into a unique identifier and send the GraphQL query variables as the URL parameters. This approach **requires to additional requests**. However, **it saves the bandiwidth**, because the query body is not sent every time. Read more about how persisted-query works [here](https://github.com/scandipwa/persisted-query#usage).

An alternative, less efficent, and less robust approach is to send the stringified JSON of the full GraphQL request to the server. This is how Magento 2 approaches the GraphQL caching implementation by default. Despite the simplicity, it brings the downsides like lower reliabaility - because now **the maximum URL length can be easily exceeded**. Additionally this way of communication is bandwidth heavy - the full query body is sent every time.

Another, more complex way to cache data is to create an additional entity storage server (database). This storage could be later syncronized with any e-commerce BE, like, i.e. Magento 2. This approach is very popular within the backend-agnostic solutions, where the middleware server could be responsible for the database operation. The downsides are the **introduced stack complexity** and **the lack of data-integrity**.

## Summary

<!-- TODO: complete doc @liana -->
