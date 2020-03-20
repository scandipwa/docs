# Creating the GraphQL resolver

The ScandiPWA works by communicating with the server using JSON. This JSON is transferred using the GraphQL API. GraphQL is a replacement to the old, good REST API.

At some point of time, we come to a point, where current schema is just not providing us enough information. What to do in such cases? Keep calm and implement Magento 2 GraphQL resolver!

## Watch the tutorial

<iframe width="560" height="315" src="https://www.youtube.com/embed/RPE36f0xQRI" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## General rule

Imagine having a normal Magento module. With some model, helpers.

Start with creating a module called `<MODULE_NAME>GraphQL`. Use an [online generator](https://mage2gen.com/) for that

Next, define what would you like to expose! Now, define a schema in `<MODULE_ROOT>/etc/schema.graphqls`. The general docs on doing that can be found on the [official GraphQL site](https://graphql.org/learn/schema/). But, there are few differences in Magento 2:
- The interface implementation does not require to implement all interface fields in the type
- The `extend type` notation is not obligatory, but we recommend using it do distinguish between new and extended types
- The [query caching mechanism](https://devdocs.magento.com/guides/v2.3/graphql/develop/create-graphqls-file.html#query-caching) is not utilized in ScandiPWA, we include all white-listed models which were loaded during the response preparation
- You can use directives like `@resolver` and `@doc` to connect resolvers and document the code quickly

Time to implement the resolver! Connect it with you schema declaration using `@resolver` directive in the schema. Provide a class in the following manner:

```graphqls
type Query {
    serverTime: String @resolver(class: "ScandiPWA\\ServerTime\\Model\\Resolver\\ServerTime") @doc(description: "The current server time formatted in YYYY/MM/DD")
}
```

Awesome, now create the resolver class. This should be done in `<MODULE_ROOT>/Model/Resolver/<RESOLVER_NAME>.php`. This should be a class, use following template:

```php
<?php
/**
 * Copyright © Magento, Inc. All rights reserved.
 * See COPYING.txt for license details.
 */
declare(strict_types=1);

namespace <VENDOR>\<NAME>\Model\Resolver;

use Magento\Framework\GraphQl\Config\Element\Field;
use Magento\Framework\GraphQl\Query\ResolverInterface;
use Magento\Framework\GraphQl\Schema\Type\ResolveInfo;

/**
 * @inheritdoc
 */
class <RESOLVER_NAME> implements ResolverInterface
{
    /**
     * @inheritdoc
     */
    public function resolve(
        Field $field,
        $context,
        ResolveInfo $info,
        array $value = null,
        array $args = null
    ) {
        // resolver functionality ...
    }
}
```

?> **Note**: Do not write the complex business logic inside, just refer the original Models.

## Advanced performance optimization

The Magento, by default, has the **Batch resolver interface** - read more about these [here](https://devdocs.magento.com/guides/v2.3/graphql/develop/resolvers.html#batchresolverinterface). We are not utilizing them, we started long before they appeared. This is why we now have the [performance module](https://github.com/scandipwa/performance).

?> **Note**: We have not dug deep into the new Magento approach to the GraphQL performance issues (Batch resolver interface).

Our solution (the performance package) was tested under the 500 RPS (Request Per Second) no cache load. The average response time for category page of 24 products - 0.5s. We can have not validated the performance of Magento resolvers after the `2.3.4`. On `2.3.3` it was not that great.