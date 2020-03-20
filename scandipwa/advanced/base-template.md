# Base template development

The base-template development is very important for a reason. **Declare it once, in order not to repeat yourself in the future**. The creation of base template is not easy. It requires time - time spent on the observation. You must go through the designs and define common elements.

Remember, if they seem similar - they most probably are!

- **We encourage not to style pixel perfect**! This leads to poor performance and code over-complication.

- **Round values, prefer rounding to 5px or 10px**! The more clear the values are, the easier it is to understand the code.

- **Escape magic numbers**! They lead to confusion. Make sure to comment on important numbers which seem to be coming from nowhere.

## Define the abstract layer

Before we cover the requirements for the elements, let's define the variables for the base-template. Some of those variables must be declared as CSS custom properties in order to achieve the highest flexibility - ability to change them by context, or even from admin configuration page!

Others, which must be available in every component style must be moved into `src/app/style/abstract/_abstract.scss`. Read how to properly override this specific file in the [override guide](/scandipwa/development/overrides.md).

- Define primary and secondary font families

- Define the maximum content width and padding (of content-wrapper) on desktop and mobile

- Declare primary colors. We prefer the `<TYPE>-base-color`, `<TYPE>-light-color` and `<TYPE>-dark-color` notation, i.e. `primary-base-color`. Do not forget error, success and warning colors

- Decide and define the placeholder animation and color

- Define and set the default font size on mobile and desktop. Prefer setting in pixels.

- Define media breakpoints, for mobile, for table, for desktop. By default they are as follows (declared in `src/app/style/abstract/_media.scss`):

    ```
                      0          768px      1024px     +∞
    desktop           |          |          |███████████
    before-desktop    ███████████████████████          |
    tablet            |          ████████████          |
    after-mobile      |          ███████████████████████
    mobile            ███████████|          |          |
    ```

## Optimize fonts

Please go through the project and collect the necessary font-faces. Ideally, there must be **no more than 5 font-faces** in total. Otherwise this will strongly affect the website performance.

!> **Note**: sometimes, people assume having one font but in multiple weights is OK - but it is commonly not. For usual fonts every font-weight weights the same. This means that you are not limited by 5 font-families, rather by 5 font-family / font-weight combinations.

Try to **remove unused glyphs** (symbols). If your site is not using cyrillic, but the font includes is - ask your designer to remove them. Use services like [FontForge](https://fontforge.org/en-US/) for that!

The `@font-face` declarations are located in `src/public/index.development.html` and `src/public/index.production.phtml`. Overriding those files is a little more complex then you might think. Checkout [our guide](/scandipwa/development/overrides.md) to know more!

!> **Note**: in the `@font-face` declaration, the property `font-display` **MUST** be declared.

In the same files the following HTML code is present for every font asset. It's task is to start preloading the font, before browser starts parsing CSS:

```html
<link rel="preload" href="<LINK TO FONT-FACE>" as="font" type="font/woff2" crossorigin="">
```

!> **Note**: the best format for your fonts is the `woff2` - it is almost 10 times smaller than `ttf` in some cases.

> **VIP Note**: always prefer serving fonts from server. Google fonts are great, but they do not provide the best performance to your website.

Make sure to check how your fonts look on Mac, Linux and Windows. Adjust following properties to match your fonts on mentioned platforms (do it before-hand!):

```css
* {
    text-shadow: 1px 1px 1px rgba(0, 0, 0, .004);
    text-rendering: optimizeLegibility;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    -webkit-tap-highlight-color: transparent;
    letter-spacing: .2px;
}
```

Please add / edit those styles in the `src/app/style/base/_reset.scss`. This is a place to reset the default CSS behavior of the elements.

## The base element style definitions

Let's define a list of elements to be referenced as "base-elements". They are always present in any base-template. Following HTML elements fall into this group:

- Lists and list items: `<ul>`, `<ol>`, `<li>`
- Paragraphs: `<p>`
- Headings: `<h1>`, `<h2>`, `<h3>`, `<h4>`, `<h5>`, `<h6>`
- Interactive element: `<a>`, `<button>`
- Input elements: `<input>`, `select`, `<textarea>`
- Tables, rows, and columns: `<table>`, `<tr>`, `<td>`, `<th>`

You must approach your designer with this list. Let's now go through the elements and define what is important to consider while designing in order to achieve the most optimal styling.

!> **Note**: elements mentioned above are always required, in the next section will talk about common elements in general.

### List and list items

Please ask your designers to provide the margins of the list items between one another, and around the list element remember to unset it in the `:last-child` pseudo class.

!> **Note**: the `:last-child` reset is not cool, it requires to always override the styles in components, which use `<li>` list items.

Possibly the better way to style the `<li>` element would be to create a class `.List` and `.List_numerated`. Then to replace it in the `<Html>` component. The alternative solution would be to use the [ARIA: Listitem role](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Roles/Listitem_role) on elements which semantically should be list items, but it is not recommend by the MDN authors.

We have a custom bullet-points and numbers style in the lists, if you are like us - make sure to do it using the `::before` pseudo-element of the list item (`<li>`), use css counters for `<ol>`.

Look for list reset in the `src/app/style/base/_reset.scss`, and for the list styling in the `src/app/style/base/_list.scss`.

If possible, try to avoid styling this element on the `<li>` itself.

### Paragraphs

Please ask your designers to provide styles for paragraphs especially line-heights, margins. Make sure to define the margin between to paragraphs.

By default styles of paragraphs are declared in `src/app/style/base/_reset.scss`.

### Headings

All headings must have a defined margin and it would be perfect if they will be different in context. If one heading is followed by another - decrease the margin between them.

By default styles of paragraphs are declared in `src/app/style/base/_reset.scss`.

### Interactive elements

Make sure the link can be styled as button, and the button can have no styles. Go through the designs, make sure all buttons are similar, inform designers about mismatches.

Make sure the buttons can be styled using class. Make sure buttons can have no style. Check how that is achieved in ScandiPWA, we are using the abstract `@mixin button`. It can be found in `src/app/style/abstract/_button.scss`.

By default ScandiPWA has flat and outline button styles.

Then there is a button variable declarations (for button configuration) in the `src/app/style/base/_button.scss`.

The link has no abstraction underneath, the styles can be found in  `src/app/style/base/_link.scss`.

Make sure buttons have `:hover`, `:focus`, `[disabled]`. Keep in mind the [order of pseudo-classes](https://css-tricks.com/snippets/css/link-pseudo-classes-in-order/).

### Input elements

Make sure you have defined the styles for all input types:

- checkbox
- radio
- select
- number
- password
- text
- textarea

Additionally the styles for placeholders, errors, notes, success messages, labels is present. ScandiPWA has a lot of places, where the styles for input are declared.

The "reset" and base styling is declared in `src/app/style/base/_reset.scss`. There we define the default `min-height` and `min-width` and font sizes.

!> **Note**: font-size on the mobile must be at least 16px! Otherwise the input will zoom in on iOS devices. Please share this with your designer!

The next place to look for input styling can be found in `src/app/style/base/_input.scss`, there we are specifically styling the input boxes (for input, textarea, select). Additionally we reset the `[type="number"]` spinners by using following styles:

```css
[type='number'] {
    -moz-appearance: textfield;
}

[type="number"]::-webkit-inner-spin-button,
[type="number"]::-webkit-outer-spin-button {
    appearance: none;
    margin: 0;
}
```

And the last and the most important place is outside of the default styles. The `<Field>` component. It has a styles for input labels, check-boxes, radio-buttons, selects, notes, error & success messages and more. Those styles can be found in `src/app/component/Field/Field.style.scss`.

### Tables, rows, and columns

Please ask your designer to consider tables on mobile. They will most probably look much different than on desktop, or may probably scroll. This is achieved using the table replacement in the `<Html>` component!

All those styles are declared in `src/app/style/base/_table.scss`.

## Shared, common elements

We covered the basic HTML elements, those who are always present. Now, it is time for an investigation. We must go thorough the design and try to squeeze the common elements of out it.

The more repetitive design is - the easier it is to extract the common elements. The most common elements to extract are:

- **Navigation** - it's states, the icons and behaviors
- **ProductCard** - can be vertical and horizontal, but always displays product information and similar information
- **ProductAttributes** - used in filtering and product pages, it is preferable define a common style to them
- **Add to cart** - on PDP or in ProductCard - this element must be styled separately
- **Price** - the price styles, with cart promotion rules, special prices, discounts, tax, savings from discounts, etc.
- **Popup** - the common way to display info
- **Loaders** - some places require loaders instead of placeholders

Let's now cover each in-depth!

### Navigation

Previously it was very common to make it appear on top and stay static. Nowadays, it is a little different. The applications are no longer "small version of desktop websites".

Today, it is important to preserve the customers browsing "state". Where is he? Browsing products, now taking a look on cart, now back to shopping. Pressing "back" button is inconvenient, hard to animate and almost never resembles the good user-experience.

For that exact reason ScandiPWA from version `2.9.0` is using bottom placed navigation. The top space is used to display the back button and provide the information about the current location. This makes browsing the website easy, improved customer experience.

The navigation is no longer static, like it was previously. Today, the header might show different icons and layout while viewing filters, switch to displaying title and back button in PDP and again when going into the cart. State-full header is a new thing designers should learn.

To create a good header template you need to do following:
1. Define the list of different header states
2. Extract all different elements and icons from header states
3. Map the icons in header to discovered states
4. Define the list of application routes
5. Map the routes to header states

Mapping of header icons and parts are made in `stateMap` of `src/app/component/Header/Header.component.js`. The mapping of routes to header states happens in `routeMap` of `src/app/component/Header/Header.container.js`. Learn how to extend Header styles in the [override guide](/scandipwa/development/overrides.md).

Header by default has the fixed height and many components are using it's height to position them-self right under it. This height is defined using CSS custom property `--header-height`. Remember to include the `env(safe-area-inset-top)` in you header height declaration. This will allow to compensate for iPhone X notch height.

The bottom navigation is located in `src/app/component/NavigationTabs/NavigationTabs.component.js` and `src/app/component/NavigationTabs/NavigationTabs.container.js`. It also has `routeMap` in container and `stateMap` in component. This is because all navigation in ScandiPWA inherits from `src/app/component/NavigationAbstract/NavigationAbstract.component.js` and `src/app/component/NavigationAbstract/NavigationAbstract.container.js`. This allows to quickly create the navigation matching the best practices listed above.

For state management the Redux is used, global state is encapsulated in NavigationReducer (`src/app/store/Navigation/Navigation.reducer.js`). To modify the existing reducer with your own, new navigation, check the [override guide](/scandipwa/development/overrides.md).

## ProductCard

The product card, also known as product pod is very common element through-out the project. However, there is a big warning:

!> **Note**: please do not try to use one single shared element everywhere. If you will extend and build others on top - this is fine. If you will try to make one element fit in cart, wishlist, product listing page and checkout totals - this might result in a very complex code, which will be very hard to maintain.

From design perspective please do not over-complicate the product-pod with too much data. The more data will be there, the heavier the request will be. This means slower websites. Remember - the less data is requested, the faster the page loads!

The styles and layout of product pod is declared in the `src/app/component/ProductCard` component folder. It uses some smaller components inside, but in general you can style your product card there.

By default, the `<ProductCard>` component is used in:
- Cart cross-sells
- Product listing
- Related products
- Whish-list items
- Recently viewed products

## ProductAttributes

Remember to style swatches and dropdowns.

Their layout can be modified in the `src/app/component/ProductConfigurableAttributes` and `src/app/component/CategoryConfigurableAttributes`. For category and product page accordingly.

The attribute style itself can be found in `src/app/component/ProductAttributeValue` component. Here, you will also find text, multi-select, boolean types. The loading placeholders can also be found there.

By default, remember:
- **dropdown** typed attributes are displayed as select elements on PDP, and as checkboxes on PLP
- **swatch** types - as small outlined buttons on PLP and PDP. Visual swatches are rounded into circles.

## Add to cart

The styles of this element can be found in `src/app/component/AddToCart`.

## Price

The styles of this element can be found in `src/app/component/ProductPrice`.

## Popup

The styles of this element can be found in `src/app/component/Popup`.

## Loaders

The styles of this element can be found in `src/app/component/Loader`.
