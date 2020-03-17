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

> **TODO**: add not about importing fonts in html, add link to override doc. Add note about reducing the amount of fonts & weights.

## The base element style definitions

Well, before we start, let's define a list of elements to be referenced as "base-elements". They always MUST be present in the template. Following HTML elements fall into this group:

- Lists and list items: `<ul>`, `<ol>`, `<li>`
- Paragraphs: `<p>`
- Headings: `<h1>`, `<h2>`, `<h3>`, `<h4>`, `<h5>`, `<h6>`
- Interactive element: `<a>`, `<button>`
- Input elements: `<input>`, `select`, `<textarea>`
- Tables, rows, and columns: `<table>`, `<tr>`, `<td>`, `<th>`

You must approach your designer with this list. Let's now go through the elements and define what is important to consider while designing in order to achieve the most optimal styling.

### List and list items

Please ask your designers to provide the margins of the list items between one another, and around the list element remember to unset it in the `:last-child` pseudo class.

> **Note**: the `:last-child` reset is not cool, it requires to always override the styles in components, which use `<li>` list items.

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

> **NOTE**: font-size on the mobile must be at least 16px! Otherwise the input will zoom in on iOS devices. Please share this with your designer!

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

