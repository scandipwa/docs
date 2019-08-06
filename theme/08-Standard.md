# ScandiPWA coding standards

- [ScandiPWA coding standards](#scandipwa-coding-standards)
  * [Stylesheets (SCSS)](#stylesheets-scss)
    + [1. Mixin nesting](#1-mixin-nesting)
    + [2. Color organization](#2-color-organization)
    + [3. Selector and function sorting](#3-selector-and-function-sorting)
    + [4. Selector nesting escaping](#4-selector-nesting-escaping)
    + [5. Value optimization](#5-value-optimization)
    + [6. Use of rem / em / px](#6-use-of-rem--em--px)
    + [7. Important rule escaping](#7-important-rule-escaping)
    + [8. No fixed heights / width](#8-no-fixed-heights--width)
    + [9. Stop specifying default property values](#9-stop-specifying-default-property-values)
  * [Overall](#overall)
    + [1. Not visual loading](#1-not-visual-loading)
    + [2. Reduce your data to useful format](#2-reduce-your-data-to-useful-format)
  * [JavaScript](#javascript)
    + [1. Make it a habit not to reassign variables.](#1-make-it-a-habit-not-to-reassign-variables)
    + [2. Destructurize data](#2-destructurize-data)
    + [2. Don't overuse &&](#2-dont-overuse-)
    + [3. Escape dynamic function creating](#3-escape-dynamic-function-creating)
    + [5. Utilize more effective array functions](#5-utilize-more-effective-array-functions)
    + [6. Return imidiatelly](#6-return-imidiatelly)
    + [7. Remember, that variables may have any name](#7-remember-that-variables-may-have-any-name)
    + [8. No multiple state-updates at once](#8-no-multiple-state-updates-at-once)
    + [9. No complex conditional rendering](#9-no-complex-conditional-rendering)
    + [10. Don't place redundant JSX tags](#10-dont-place-redundant-jsx-tags)

## Stylesheets (SCSS)

### 1. Mixin nesting

When writing media queries, the `mobile`, `desktop` mixins are commonly used. The proper way, to organize them, is to write selectors outside mixin and keep only properties in.

#### For example:

```scss
.Button {
    // Wrong
    @include mobile {
        &:hover {
            text-decoration: none;
        }
    }

    // Correct
    &:hover {
        @include mobile {
            text-decoration: none;
        }
    }
}
```

#### Why?

Because this allows to keep all the properties organized to a selector. Because logically, you change the appearance of the selector on your media query (change it's property), so keep only properties changing. Additionally, this allows for easy addition / removal of properties and other media mixins to the selector in future.

### 2. Color organization

The CSS variable based coloring is advised on ScandiPWA based solutions. Why? Becuase it allows for easy color-scheme manipulation and brings an option of color dynamic adjustment. The colors for a component must be specified in `:root` element, the colors itself, might be moved out into `variables` file.

#### For example:

```scss
// in variables.scss
$alpine-white: #fffee9;
$slate-grey: #708090;

// in Component.style.scss
:root {
    --component-background: #{$alpine-white};
}

.Component {
    background: var(--component-background);

    @include mobile {
        --component-background: #{$slate-grey};
    }
}
```

#### Why?

The colors should have a common name throughout the project, for easier reference, it is recommended to declare SCSS variables in `variables` file. The used colors should be specific to a component, they may share the same color, but must be distinct in order to be easily adjusted in the future, this makes your styles more flexible.

### 3. Selector and function sorting

The complex styles commonly require multiple pseudo-classes, pseudo-elements, media queries, properties, selector-build-ups, it is important to write them in correct order to keep everything trackable.

#### For example:

```scss
.Component {
    @include button;

    --button-padding: .5rem;

    color: var(--component-color);

    @include mobile {
        --button-padding: 1rem;
    }

    &:hover {
        --component-color: #{$dark-grey};
    }

    &::after {
        content: '> ';
    }
  
    &_active {
				// ...
    }

    &-Image {
        max-width: 20px;
    }

    span {
        font-size: 12px;
    }
}
```

#### Why?

Sorting selectors, functions and properties is important for consistency and correct work of stylesheets. Why? For example, the non-content based mixin has to be defined on top in order to be rewritten with properties later. The CSS variables must be declared before they are used, otherwise they won't work. The pseudo-classes and pseudo-elements must be divided and not mixed together, classes should go above, becuase those selectors are tightly related to element.

### 4. Selector nesting escaping

The deeper selector, the harder it is for a CSSOM to calculate and draw. The ideal selectors are all the same weight. In our case, we are using BEM, which allows for 010 consitent depth throughout the project.

#### For example:

```scss
// Source code
.Component {
  &-Wrapper {
    // ...
    
    &_wide {
      // ...
    }
  }
}

// Compiled code
.Component-Wrapper {
  // ...
}

.Component-Wrapper_wide {
  // ...
}
```

#### Why?

As stated above less deep selectors allow for quick paints. This also allows for easy navigation within a file, and easier reading.

### 5. Value optimization

The values of CSS properites should never reference decemal values lower then a pixel. So, all values shoud be rounded to full pixels, or if impossible to round, the pixels themselfs should be used. Also, the values like 23px must be rounded to 5px, why? Becuase this allows for easy reading. The reccomened stops are 5px for content-full elements and 1px for simple elements. Remember, that 0 is redundant.

#### For example:

```scss
// Wrong
width: 23.5px;
max-width: 21px;
opacity: 0.415;
font-size: 1.23rem;
line-height: 1.456;
color: rgba(45, 234, 89, 0.456);

// Correct
width: 25px;
max-width: 20px;
opacity: .4;
font-size: 1.25rem; // assuming 1rem = 12px
line-height: 1.5;
color: rgba(45, 234, 89, .45);
```

#### Why?

It is impossible to draw less then 1px (if it is not a clip path!). This means, if element height is not a rounded `px` value and it has one pixel border, it might not rendered, as it's location is in between the pixel grid of a website, similarly the 2px border, might become 1px. The vertically aligned elements are often affected by non-rounded values, for example the position of second element might be offset. A lot of issues might be potentially caused by non-rounded values – escape them!

### 6. Use of rem / em / px

As mentioned in 5) the rouded values are very important. However, using `em` and `rem` are very misleading –  they are dynamic and you often don't know what value it contains. To make it clear `rem` is the body-font-size-based unit, while `em` is based on a parent element font-size. There is only two rules – make sure you are using values that can be rounded to a full pixel and you understand why, you are using `rem` or `em` – most commonly for text distribution.

#### For example:

```scss
body {
  font-size: 12px;
}

// Wrong
padding: 1.3rem;
left: 2.35rem;

// Correct
padding: 15px;
left: 28px;
padding-left: 1rem;
```

#### Why?

As stated in 5) due rendering issues. But, any use of specific unit should be logicaly explainable. The `em` or `rem` means, that the usecase must be somehow related to font-size. So, use them in places related to text.

### 7. Important rule escaping

Important is the most powerful form of CSS selector strength rules, it bypasses id, class, name, everything. It is very commonly used to override inline-styled elements. We must escape it to have our code supportable.

#### For example:

```scss
// <div class="third-party" style="font-size:12px;" />

// Ok, if everyhting else is impossible
.third-party {
		font-size: 12px !important; 
}

// However, there should be no declarations of !important
// in custom defined elements / stylesheets.
```

#### Why?

Becuase it is impossible to override, it makes styles incosistent. It is much better to use third parties, that escape direct styling, by for example using custom stylesheets and applying CSS custom variables.

### 8. No fixed heights / width

When styling it is easy to define a height once, and keep it consistent, however, the assumption, that content will always be the same, and designs won't change is weak. The recommeded way to approach styling is by using `box-sizing: border-box` along with padding to define element's height. In order to achive the effective behaviour of the element when loading use `min-height` .

#### For example:

```scss
// Wrong
.ProductName {
		height: 20px;
  	margin: 1rem;
}

// Correct
.ProductName {
		min-height: 20px;
  	margin: 1rem;
}
```

#### Why?

Because this prevents from applying custom style to the element, breaks `flex` if element is involved in it, and overall complicate styling.

### 9. Stop specifying default property values

When working with apps Zeplin, developers are tend to copy whole stylesheet, instead of retriving only the specific values. Then, the `font-style: normal;` or `font-weight: normal;` appears in code. Those values are mostly the defaults (which might be disabled in case of Zeplin), make sure you are not supplying them.

#### For example:

```scss
// Wrong
font-size: 15px;
font-weight: 300;
font-style: normal;
font-stretch: normal;

// Correct
font-size: 15px;
font-weight: 300;
```

#### Why?

Because they are redundant and just makes stylesheets more complex.



## Overall

### 1. Not visual loading

When loading a data to be displayed, we must display placeholders if this data will present on a page. Why? Becuase then, from placeholders we quickly jump into loaded state, without breaking the layout, so transition from loading to loaded is seemless. Please do not use conditional rendering to showcase this, implement it using early returns and test, test, test!

#### For example:

```js
class ProductPrice extends Component {
  render() {
    const { price } = this.props;
    if (!price) return null; // Bad
    if (!price) return this.renderPlaceholder(); // OK
    
    /**
     * Perfect, if your function can render same structure, 
     * but with palceholders if data is not present
     */

    return (
    		...
    );
  }
  
  propTypes = {
    price: PropTypes.shape([ ... ]).isRequired
  }
}
```

#### Why?

In perfect condition, if you have not yet recieved a data to be rendered, you must already render the full element structure, but with placeholders inside, this way, after data will be recived, there will be no complex re-renders, just places were placeholders were – this eliminates page blinking.

### 2. Reduce your data to useful format

The data we are working with is often not in the format we expect it to be. It is commonly array, where we need order object, it is often organized by wrong property, etc. Make suer you are preparing your data well in your reducer or container.

#### For example:

```js
/**
 * Imagine you want stores arranged by city it is currenlty located
 * But the data comes flat
 */

// Doing this in your component is bad idea
// Reducer
const { stores } = action;
return { stores, ...state };

// Component
const { stores } = this.props;
const storesByCity = stores.reduce((cityStores, store) => {
  const { city } = store;
  if (!cityStores[city]) cityStores[city] = [];
  cityStores[city].push(store);
  return cityStores;
}, {});

// However, doing this in reducer is great!
const { storesData } = action;

return {
  stores: storesData.reduce((cityStores, store) => {
    const { city } = store;
    if (!cityStores[city]) cityStores[city] = [];
    cityStores[city].push(store);
    return cityStores;
  }, {}),
  ...state
};
```

#### Why?

Becuase data is often used in multiple places, so preparing it once, instead opf looping though each time is essential to performance.

## JavaScript

### 1. Make it a habit not to reassign variables.

In a paradigm of functional programming, you should never reassign values to variables. The functions must follow Maths way – if a is passed, the value should be returned, the passed value should never be changed or redefined.

#### For example:

```js
// Bad
let hair

if (today === 'Monday') {
  hair = 'bangs'
} else {
  hair = 'something else'
}

// Great
const hair = today === 'Monday' ? 'bangs' : 'something else';
```

#### Why?

- Becuase you may change the external state by accident when you reassign value
- You are creating a more complex code, when doing this

Read the [great article](<https://zellwk.com/blog/dont-reassign/>) about this!

### 2. Destructurize data

The dot notation is great, but when used a lot, becomes hard to maintain. It is much better pratice to separate objects to smaller parts – destructurizing them into variables.

#### For example:

```js
// Bad
return this.props.product.minPrice < this.props.product.maxPrice
	? this.props.product.minPrice
	: this.props.product.maxPrice;

// Still bad
const minPrice = this.props.product.minPrice;
const maxprice = this.props.product.maxPrice;
return minPrice < maxPrice ? minPrice : maxPrice;

// Great
const { product: { minPrice = 0, maxPrice = 0 } } = this.props
return minPrice < maxPrice ? minPrice : maxPrice;
```

#### Why?

- Allows for easy reading of what is going on in the code
- Allows for easy default value declaration, without modifying the inital data source
- Allows for varaiable name aliasing

### 2. Don't overuse &&

It is know for a long time, that `&&` in javascript returns a last element if expression is true. But, the use of this behaviour leads to complex code structures which are hard to support.

#### For example:

```js
// Bad, hard to read
return (
	<div>
  	{ products && products.length && (
    	<h2>{ products[0].name }</h2> 
    ) }
  </div>
);

// Perfect, if moved into separate function
if (!products.length) return null;
const [{ name }] = products;
return <h2>{ name }</h2>;
```

#### Why?

Because it is much better to deligate an addition function to handle your checks, rather to rely on wierd mechanics. Also, escaping `&&` allows for cleaner code, and more extendable functions.

### 3. Escape dynamic function creating

Using arrow functions is great, but they must be created in runtime. We must escape this behaviour by binding them to component context. There is also an option to declare them as arrow functions initially, but it is not recommend, as we would like to stay consistent thoughout the project (in terms of function declarations).

#### For example:

```js
class MyComponent extends Component {
  constructor() {
  	this.handleOneMoreClick = this.handleOneMoreClick.bind(this);
  }
  
  // Preferred way
  handleOneMoreClick() { ... }
  
  // The OK one, but not recommened
  handleOtherClick: () => { ... }
  
  // The bad one
  handleClick() { ... }
  
  render() {
    return (
      <>
      	{ /** Not the right way to go */ }
    		<button onClick={ () => this.handleClick } />
				<button onClick={ this.handleOneMoreClick } />
        <button onClick={ this.handleOtherClick } />
      </>
    );
  }
}
```

#### Why?

Becuase we would like not to sacrifise any time while rendering. Slow renders are very destructive to an application, and lead to bad user expirience.

### 5. Utilize more effective array functions

If you follow 1) you are familiar with escaping `var` and `let`. But, if working with object or array you may use const, while still re-declaring values. Escape it, think about it in the same way as 1) – remember, the `forEach` is just a loop-through, the `map`, `reduce`, `filter`, `find` (and others!) exist and are more suitable for common purposes.

#### For example:

```js
// Bad practise
const { stores } = this.props;
const cityStores = {};

if (stores.length) {
  stores.forEach((store) => {
    const { city } = store;
    if (!cityStores[city]) cityStores[city] = [];
    cityStores[city].push(store);
  });
}

return cityStores;

// Great approach
const { stores } = this.props;
return stores.reduce((cityStores, store) => {
  const { city } = store;
  if (!cityStores[city]) cityStores[city] = [];
  cityStores[city].push(store);
  return cityStores;
}, {});
```

#### Why?

Because as described in 1) the propery re-declarations are ineffective. Use of suitable functions allow for less loops, and code in general.

### 6. Return imidiatelly

Why to bother with additional checks if we can return imidiatelly?

#### For example:

```js
// Bad
function getHairType (today) {
  let hair

  if (today === 'Monday') {
    hair = 'bangs'
  } else if (today === 'Tuesday') {
    hair = 'braids'
  } else if (today === 'Wednesday') {
    hair = 'short hair'
  } else if (today === 'Thursday') {
    hair = 'long hair'
  } else if (today === 'Friday') {
    hair = 'bright pink hair'
  }

  return hair
}

// Good (switch may be used as well, but in terms of example)
function getHairType (today) {
  if (today === 'Monday') return 'bangs'
  if (today === 'Tuesday') return 'braids'
  if (today === 'Wednesday') return 'short hair'
  if (today === 'Thursday') return 'long hair'
  if (today === 'Friday') return 'bright pink hair'
}
```

#### Why?

Becuase this is cleaner and makes code much more readable and flat. Any complex structures make code less and less readable.

### 7. Remember, that variables may have any name

If you have a place where one variable name will be conviniet, and your variable is coming from a function parameter, do not hesitate and name it like you need imidiatelly. It is strange to see abstarct variable names like `value`, which does not represent anything.

#### For example:

```js
// Unpreferable
<input onChange={ value => this.setState({ name: value }) } />

// Prefered
<input onChange={ name => this.setState({ name }) } />
```

#### Why?

First-of-all, it makes sense, becuase we are directly naming an entity we are working with. Secondly, we are writing less code.

### 8. No multiple state-updates at once

When implementing your own `dispatcher` classes you might see places, where stumble across a place where multiple `dispatch` functions are called. We must join them into one action dispatch. 

#### For example:

```js
// Inefficent
dispatch(updateProducts(products));
dispatch(updateBreadcrumbs(products));
dispatch(updateCategoryFilters(products));

// Great
dispatch(updateProductsAndCategory(products);
```

#### Why?

Becuase, if not merged together, it will be hard to track from listening component – on global state update, the component will update multiple times, so tracking previous props in `static getDerivedStateFromProps` will not be easily achievable. Also, the rendering might happen more than one time => some lag might be noticable. 

### 9. No complex conditional rendering

When implementing a react render method, the JSX is typed, it supports a conditional rendering by writing in `{ ... }`. This feature commonly over-used by developers, which result in very clunky, big render methods.

#### For example:

```js
// Bad, very complex rendering
render() {
  const { isOpen } = this.state;
  const { product } = this.props;
  const { name, attributes } = product;

  return (
  	<div>
    	{ name && (<h2>{ name }</h2>) }
			<p>Attributes:</p>
			<ul>
        { attributes && attributes.length && attributes.map(({ value, code }) => (
            <li>
            	<strong>{ code }</strong>
            	{ value }
						</li>
        ) }
      </ul>
			{ isOpen && <AnotherComponent product={ product } /> }
    </div>
  );
}

// Great, clean render
renderAttributeList() {
  const { product: { attributes = [] } } = this.props;
  if (!attributes.length) return null;
  return attributes.map(this.renderAttribute)
}

renderAttribute({ value, code }) {
  return (
  	<li>
      <strong>{ code }</strong>
      { value }
 		</li>
  );
}

renderProductName() {
  const { product: { name } } = this.props;
  return <h2>{ name }</h2>;
}

renderAnotherComponent() {
  const { isOpen } = this.state;
  const { product } = this.props;
  if (!isOpen) return null;
  return <AnotherComponent product={ product } />;
}

render() {
  return (
  	<div>
    	{ this.renderProductName() }
			<p>Attributes:</p>
			<ul>
    		{ this.renderAttributeList() }
			</ul>
			{ this.renderAnotherComponent() }
    </div>
  );
}
```

#### Why?

Becuase dividing complex conditional renders in functions, makes it:

- More extendable
- More readable
- Allows for easy additional checks

The recommendation here, is not to go and rewrite everything to functions, but to keep it clean. Complex render methods look dirty.

### 10. Don't place redundant JSX tags

Coding and supporting the project is not easy, and sometimes unnecessary tags are left over. Make sure you remove them.

#### For example:

```js
// Bad
return (
	<>
 		<div>
  		{ /** ... */ }
  	</div>
  </>
);

// Great
return (
	<div>
  	{ /** ... */ }
  </div>
);
```

#### Why?

Becuase those tags are uneccessary.
