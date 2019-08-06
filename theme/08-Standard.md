# ScandiPWA coding standards

- [ScandiPWA coding standards](#scandipwa-coding-standards)
  * [Stylesheets (SCSS)](#stylesheets-scss)
    + [1. Mixin nesting](#1-mixin-nesting)
    + [2. Color palette (color organization)](#2-color-palette-color-definition)
    + [3. Selectors, mixins and functions](#3-selectors-mixins-and-functions)
    + [4. Nesting](#4-nesting)
    + [5. Value optimization](#5-value-optimization)
    + [6. Use of rem / em / px](#6-make-a-use-of-rem-em-px)
    + [7. Avoid !important](#7-avoid-important)
    + [8. No fixed heights / width](#8-no-fixed-heights--width)
    + [9. Stop specifying default property values](#9-stop-specifying-default-property-values)
  * [Overall](#overall)
    + [1. Data loading](#1-data-loading)
    + [2. Effective data processing](#2-effective-data-processing)
  * [JavaScript](#javascript)
    + [1. Make it a habit not to reassign variables.](#1-make-it-a-habit-not-to-reassign-variables)
    + [2. Destructurize data](#2-destructurize-data)
    + [3. Don't overuse &&](#3-dont-overuse-)
    + [4. Context](#4-context)
    + [5. Use specific functions](#5-use-specific-functions)
    + [6. Return early](#6-return-early)
    + [7. Variable naming](#7-variable-naming)
    + [8. Group-up multiple state updates](#8-group-up-multiple-state-updates)
    + [9. Decoupling](#9-decoupling)
    + [10. Keep your code clean](#10-keep-the-code-clean)

## Stylesheets (SCSS)

### 1. Mixin nesting

When writing media queries, the `mobile`, `desktop` mixins are commonly used. The proper way, to organize them, is to write selectors outside mixin and keep only properties in. 

This allows to keep all the properties organized for a selector, as you change the appearance of the selector within your media query (change it's property), so keep only properties changing. Additionally, this allows for easy control (add / remove) of properties and other media mixins to the selectors.

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


### 2. Color palette (color definition)

CSS variables must be used for color definitions for ScandiPWA.
It provides ability for modern and easy color-scheme manipulation and brings an option of color dynamic adjustment. The colors for a component must be specified in `:root` element, the colors itself, should be moved out into `variables.scss` file.

Used colors should be specific to a component, they may share the same color, but must be distinct in order to be easily adjusted in the future, this makes your styles more flexible.

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


### 3. Selectors, mixins and functions

Complex styles commonly require multiple pseudo-classes, pseudo-elements, media queries, properties, selector-build-ups. Order matters a lot, as good organization helps to keep it trackable and easily readable.

1) Non-content based mixin has to be defined on top, in order to be rewritten with properties later
2) Variables must be declared before these are used (according to specs)
3) Pseudo-classes and pseudo-elements must not be mixed together
4) Element and modifier definitions must be above other definitions (i.e. element definition)

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
        // Styles applied when element is active
    }

    &-Image {
        max-width: 20px;
    }

    span {
        font-size: 12px;
    }
}
```


### 4. Nesting

ScandiPWA follows BEM CSS organization methodology, that provides convenience, ease and good effectivity of the project styles.
Each nested selector increase the "weight" of rules, making it harder and harder to override. You can learn more about "weight" or specificy approach: https://css-tricks.com/specifics-on-css-specificity/ 

#### For example:

```scss
// Source code
.Component {
  &-Wrapper {
    // Element properties
    
    &_wide {
      // Modifier properties
    }
  }
}

// Compiled code
.Component-Wrapper {
  // Element properties
}

.Component-Wrapper_wide {
  // Modifier properties
}
```

### 5. Value optimization
All values must be rounded to integer pixel values, or the pixels should be used when possible.
The values of CSS properites should never reference decimal values under a pixel, as it is impossible to draw less then 1px (if it is not a clip path!).

Also, the values like 23px must be rounded to each 5px that improves readability. The reccomened stops are 5px for content-full elements and 1px for simple elements.

`0` in front of values lower than `1` is redundant:
- correct: `.25`
- wrong: `0.25`

> Whether element height has a float `px` value instead of integer - it has one pixel border, it might not be rendered, as it's location is in between the pixel grid of a website, similarly the 2px border, might become 1px. The vertically aligned elements are often affected by non-rounded values, for example the position of second element might be offset. A lot of issues might be potentially caused by non-rounded values – avoid using them!


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

### 6. Make a use of rem / em / px

Using `em` and `rem` are often misleading: they are dynamic and you often don't know what value it contains. To make it clear:
- `rem` is the **body** font-size based unit
- `em` is the **parent** element font-size based unit

> There are only two rules – make sure you are using values that can be rounded to a full pixel. Make sure you have a reason to use `rem` or `em`. In general, most common use case for any of these to be used is text distribution.

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

### 7. Avoid !important
You must not use `!important`.

> Important is the most powerful form of CSS selector strength rules, it overrides id, class, name, everything. It is very commonly used to override inline-styled elements, but brings inconsistency.

> It is much better to use third parties, that escape direct styling, by for example using custom stylesheets and applying CSS custom variables.

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

### 8. No fixed heights / width
You must not define width / height fixed size.
The recommeded way to define styles is by using `box-sizing: border-box` along with padding to define element's height.

> This prevents from applying custom style to the element, breaks `flex` if element is involved in it, and overall complicate styling. It is easy to assume and follow the assumption content size will never change, however such asumption is wrong.

> When styling it is easy to define a height once, and keep it consistent, however, the assumption, that content will always be the same, and designs won't change is weak.  In order to achive the effective behaviour of the element when loading use `min-height` .



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



### 9. Skip unnecessary definitions

It often happens, that default values are defined multiple times, i.e. `font-style: normal;` or `font-weight: normal;`, especially, when styles are based on apps like Zeplin.

Define only necessary properties, skipping all default (defined as default) properties.

Never rely on browser defaults, it differs from browser to browser. Use `reset.scss` for unifying default styles.

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


## Overall

### 1. Data loading

When loading a data, we must display placeholders for the data that is a part of a page (layout). 

> Placeholders are great for filling the layout while we are waiting for the data, provides suggestions about the content size or type and improve webpage UX. Do not use conditional rendering to showcase this, implement it using early returns and test, test, test!

> In perfect condition, if you have not yet recieved a data to be rendered, you must already render the full element structure, but with placeholders inside, this way, after data will be recived, there will be no complex re-renders, just places were placeholders were – this eliminates page blinking.

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

### 2. Effective data processing

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

## JavaScript

### 1. Do not reassign variables

You must not reasign variable values, because:
- you may change the external state by an accident
- code complexity is growing

> In a paradigm of functional programming, you should never reassign values to variables. The functions must follow Maths way – if `a` is passed, the value should be returned, the passed value should never be changed or redefined, as in in most common scenarios:

> Read the [great article](<https://zellwk.com/blog/dont-reassign/>) about this!

#### For example:

```js
// Bad
let hair

if (today === 'Monday') {
  hair = 'bangs'
} else {
  hair = 'something else'
}

// Good
const hair = today === 'Monday' ? 'bangs' : 'something else';
```

### 2. Destructure data
You must destruct props / states in the beginning of the method / function. 
You must not pass descructured data between methods, if fields can be desctructured independently.

> Reduce complexity and improve readability, brings clear dependency on the data you are processing:
> - Allows for easy reading of what is going on in the code
> - Allows for easy default value declaration, without modifying the inital data source
> - Allows for varaiable name aliasing
> The dot notation is great, but when used a lot it brings inconvenience. It is much better pratice to separate objects to smaller parts – destructurizing them into variables.

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

### 3. Don't overuse &&

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

### 4. Context

Using arrow functions is great, but they must be created in runtime. You must avoid this behaviour by binding them to component context. There is also an option to declare them as arrow functions initially, but it is not recommend, as we would like to stay consistent thoughout the project (in terms of function declarations).

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

### 5. Use specific functions
You must avoid re-declaring values.
You should use  `map`, `reduce`, `filter`, `find` (and others!) over Array.forEach().

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

### 6. Return early

You must use early returns.

#### For example:

```js
// Bad
function doSomething(argument) {
    if (argument) {
        // many lines of code
        return something;
    }

    return false
}

// Good
function doSomething(argument) {
    if (!argument) {
        return false;
    }
    // many lines of code

    return something;
}
```

### 7. Variable naming

If you have a place where one variable name will be convenient, and your variable is coming from a function parameter, do not hesitate and name it like you need imidiatelly. It is strange to see abstarct variable names like `value`, which does not represent anything.

#### For example:

```js
// Unpreferable, rename occurs
<input onChange={ value => this.setState({ name: value }) } /> // value

// Prefered, rename does not happen
<input onChange={ name => this.setState({ name }) } /> // name

// Prefered, complex item, rename occurs
<input onChange={ name => this.setState({ item: { name: itemName }, user: { name: userName } }) } /> // itemName, userName
```


### 8. Group-up multiple state updates

When implementing your own `dispatcher` classes you might see places, where stumble across a place where multiple `dispatch` functions are called. You must join them into one action dispatch. 

> When not merged together, it will become hard to track. On global state update, the component will update multiple times, so tracking previous props in `static getDerivedStateFromProps` will not be easily achievable. Also, the rendering might happen more than one time, that might cause some lag noticeable lag.

#### For example:

```js
// Inefficent
dispatch(updateProducts(products));
dispatch(updateBreadcrumbs(products));
dispatch(updateCategoryFilters(products));

// Great
dispatch(updateProductsAndCategory(products);
```

### 9. Decoupling

When implementing a react render method, the JSX is typed, it supports a conditional rendering wrapped within `{ ... }`. This feature is often over-used by developers, which result in very clunky, big render methods.

> Decoupling, or, if we rephrase, Dividing complex, conditional renders in to smallerfunctions, makes it:
> - More extendable
> - More readable
> - Allows for easy additional checks

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


### 10. Keep the code clean

Make sure to remove unnecessary or unused tags, comments, commented code, attributes.

#### For example:

```js
// Bad
return (
	<>
        // <Item item={item} />
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
