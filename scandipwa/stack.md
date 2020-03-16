# Frontend tech-stack

The ScandiPWA is build using very **simple** technologies. It is utilizing:
- React + JSX
- Redux
- SASS (SCSS)
- Webpack

Yes, there are a lot of buzz-word in this list. But let's break those technologies down to simple, easy-to-understand pieces.

## Magento 2 retrospective

First, let's define why was there a necessity for a change?

Because we are building a CSR application, not the SSR! So the technologies must be efficient and optimized for the browser, not the server.

Some technologies from the old stack did not fit by design, i.e.:
- XML layouts
- PHTML templates

And some, just did not age well or stopped being supported:
- LESS styles
- Require JS
- JQuery

Let's now compare the old and new one's and see why was a decision made and what were the alternatives of the chosen technology.

## React _vs_ JQuery

> **TODO**: compare JQuery algorithm and React, explain the gain in performance. Briefly compare React to Vue and Angular.

## JSX _vs_ PHTML

> **TODO**: compare old PHTML template system and the JSX. Explain why is one more optimized for browsers then the other.

## XML layouts

> **TODO**: explain why there is no replacement for this technology, and what are we going to do about it.

## RequireJS _vs_ Webpack

> **TODO**: Explain the main difference between RequireJS and Webpack. Why is one more suited than the other.

## SASS _vs_ LESS

> **TODO**: Explain the main difference between SASS and LESS. Explain why is one technology more power-full then the other. Discuss alternatives if any - CSS? CSS-in-JS?
