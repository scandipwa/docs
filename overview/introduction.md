# Introduction to ScandiPWA Tech Stack

The main goal of this introduction is to motivate the technology stack difference between usual Magento 2 and ScandiPWA.

To understand it you are required to be familiar with the default Magento workflow as well as basic knowledge about how browsers work.

## How Magento 2 (M2) frontend (FE) works

The first time you open a page, browser caches all its **static** assets: scripts (JS), styles (CSS) and uses markdown (HTML) returned from the server to display the content of the page. The next time you visit the same website (e.g., going from product listing page (PLP) to product description page (PDP)) the browser fetches (loads) only HTML and reuses **browser** cached assets to display content. This means that to render the page (draw the content) it requires to request the HTML from a server.

The HTML content is cached on the server. This means that for the same page (e.g., PDP) the server will generate the HTML only once. Generating the HTML on the server is called SSR (Server-side rendering). While generating, the server might use multiple entities - in database defined information sources (product information, user information, category, etc.). M2 is smart, it can **automatically** invalidate (purge, flush) specific HTML page caches on demand - when the entity information was changed (e.g., the product name was changed => related category and product page caches must be flushed). This mechanism is called "Full Page Cache".

### What is the problem of such solution?

Despite changing only one information entity (e.g., product name), the server will flush and after regenerate all HTML pages where this entity was used. This will make server load unchanged entities all over again even though they have not been changed. This makes M2 very "resource-heavy", it does a lot of unnecessary requests for unchanged entities.

### How to make M2 not load unnecessary entities all over again?

You must request the information about entities on the page separately. This cannot be done using solely HTML generated on the server because after it is cached the information cannot be separated. HTML is just a presentation of multiple entity information. We cannot find the exact place in the generated HTML where one or another entity was changed and invalidate exactly its part of markdown. This means that we cannot achieve effective caching by only implementing SSR even using the ["Full Page Cache"](https://docs.magento.com/m2/ee/user_guide/system/cache-full-page.html) mechanism.

In order not to load the whole HTML all over again we must communicate with the server with the separate entities. Those entities can be presented in different formats, e.g. XML, JSON. To communicate by sharing the information (not presentation like HTML), the server must have any kind of API (Application Programming Interface). The API can be implemented in different ways, e.g. REST API (JSON), SOAP API (XML), GraphQL (JSON).

The method of communication with the server with API is called AJAX (Asynchronous Javascript and XML). With the AJAX methodology the information is retrieved from the server, then passed to the algorithm on client (in browser), which generates the HTML. There could be multiple separate AJAX requests, e.g. product, category, user, etc. Each request can be separately cached on the server. When done for all the data on the page, this approach is called Client-Side Rendering (CSR).

### Can we implement CSR in M2?

Yes. Out of the box, Magento 2.3.x comes with partial GraphQL support. However, the default Magento theme is still mostly SSR. In places like checkout and cart, AJAX requests are used. They optimize and enhance the user experience on those pages.

To implement full CSR, we need to completely rework the way how M2 approaches rendering. We must get rid of [layout](https://devdocs.magento.com/guides/v2.3/frontend-dev-guide/layouts/layout-overview.html) / [template system](https://devdocs.magento.com/guides/v2.3/frontend-dev-guide/templates/template-overview.html). We need to implement a solution that will be capable of working in the browser (on client), make requests to M2 APIs, and render the information in human-readable format (in HTML).


## How does ScandiPWA implement CSR?

ScandiPWA does not support the Magento layout/template system. Therefore, we need a substitution to it but in the client's browser. ScandiPWA uses React as a base for its FE because it is the most popular library for modern user interface (UI) development. React is a library that allows for a more effective page rendering. Instead of changing the whole page, React compares the expected representation of the page with the current one and applies the changes only to the exact part that was changed.

As an API implementation, ScandiPWA uses GraphQL. Firstly, GraphQL was initially chosen to be used by Magento themselves. Secondly, it is a development-friendly tool. Let me explain why. In its essence, GraphQL is a language that allows you to communicate with the server throughout only one endpoint, by pointing on such fields that you want the server to provide information about.

By rewriting (by implementing features present in) the M2 FE using the new technology stack like React and QraphQL as well as using the AJAX methodology, we can implement a CSR on the website.

The application can claim to be a Single Page Application (SPA) if every page of it can be rendered on client (in browser).

## How does SPA work?

Browsers always work in the same way. When refreshing the page or typing the new URL, the browser will request the HTML from the server. From this HTML the browser will extract scripts and styles.

In the case of SSR application, the behavior above is expected. It is required for every page because we do not know what will happen when you click on a link. The HTML will be requested once again and the page will be rendered.

If your application can render any page of your website, then by going to another page within the website, you will be able to render it. So the HTML request to the server will not be required. You only need to emulate (fake) the change of the URL. This can be done by manipulating the browser history.

When using SPA, instead of the server, your scripts are in response of the page content rendering.

## Which benefits does SPA bring?

First of all, you do not longer need to request the HTML for every page. This allows for making transitions between pages smooth and fast.

**Why smooth?** Because now the application (SPA) is in response (controlling) of the browsing - when you transition between page, we already know what page will follow up, so we can animate the transition.

**Why fast?** Because the server might never know which page the user is currently browsing. You do not need to wait for the server response to render the page.

This allows for much better User Experience (UX).

## Which benefits does PWA bring?

PWA stands for Progressive Web Applications. PWA allows you to have one source code for all the platforms like web-browsers, Android and iOS applications, and PCs. This makes targeting a new audience cheaper. Additionally, the PWA solution brings you the ability of offline browsing and the possibility to install the application to your home screen directly from the browser.

By design, PWA introduces Service Worker (SW). Service Worker is a programmable proxy.

**What is a programmable proxy?** Imagine two people communicating with each other using a pipe. The pipe is a proxy. Imagine the pipe having a valve. If someone can control the valve - the pipe is now a programmable proxy.

These two people from the example above are the server and the client (browser). The SW can control communication between them. The communication between the client and server consists of the requests and the responses to them. The SW can cache the response to the corresponding request. Later, if the same request is sent from the client, the SW can interrupt it and respond with the cached version of the response. In this situation, the request is not being proxied (sent) to the server.

This feature of SW allows for offline browsing and faster responses. Instead of making a round-trip to the server, we are only communicating with SW that is installed in the client's browser.

## Summary

Magento has introduced an effective way of communicating with the server - GraphQL. This allows us to use AJAX methodology for the further implementation of CSR.

ScandiPWA is a SPA theme for Magento. It can be installed as a regular Magento theme, however, the usual layout/template system is not utilized. Instead, we are using React components to render the application.

