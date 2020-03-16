# Setup on existing Magento 2 instance

ScandiPWA is a simple Magento theme. We can install it on existing Magento instance using composer.

<hr>

In code examples, you might stumble across such declaration:

```bash
# to clone the fork
git clone git@github.com:<YOUR GITHUB USERNAME>/scandipwa-base.git
```

> **Note**: the `<YOUR GITHUB USERNAME>` is not a literal text to keep, but the "template" to replace with the real value.

## Watch video

> **Note**: video is coming soon!

## Before you start

1. Make sure your server is running `Magento 2.3.3`.

2. Make sure Redis is available on the host machine. Obtain the host, port of this service.

3. Make sure you have `node` available on you machine. To test this, run:

    ```bash
    node -v # should be 10^
    ```

    In case this command resulted in error, install node using the [official guide](https://nodejs.org/en/download/package-manager/). Prefer `nvm` installation to get NODE version 10 specifically.

4. Make sure the `Varnish` is installed on the host / infrastructure and Magento is configured to use it. Please validate with following:

    ```bash
    varnishd -V # should be 5^
    ```

    In Magento admin go to _Stores > Configuration > Advanced > System > Full Page Cache_. Make sure the `Varnish Cache` is selected in the dropdown, varnish configuration has proper values set in it.

    If it is not, please follow [official documentation](https://devdocs.magento.com/guides/v2.3/config-guide/varnish/config-varnish.html) to set it up.

    > **Note**: varnish is important! Please validate if it is installed with your hosting provider / developer.

5. Make sure the `Redis` is installed on your host / infrastructure. To validate the installation run following:

    ```bash
    redis-cli -v # should output 2.5^
    ```

    If it is not installed, please follow [this guide](https://codewithhugo.com/install-just-redis-cli-on-ubuntu-debian-jessie/) to obtain it.

    > **Note**: steps 5. and 6. are the requirements of `scandipwa/persisted-query` package.

## It is time to setup!

1. Install `scandipwa/installer` using following command:

    ```bash
    composer require scandipwa/installer
    ```

2. Configure `scandipwa/persisted-query` module, using Magento CLI:

    Execute the CLI command for each configuration value as follows:

    ```bash
    php bin/magento setup:config:set <FLAG> <VALUE>
    ```

    - `--pq-host` [mandatory] - persisted query redis host  (`redis` for ScandiPWA docker setup, `localhost` in the most common custom setup case)

    - `--pq-port` [mandatory] - persisted query redis port (`6379` for ScandiPWA docker setup)

    - `--pq-database` [mandatory] - persisted query redis database (`5` for ScandiPWA docker setup)

    - `--pq-scheme` [mandatory] - persisted query redis scheme (set to `tcp` in not sure)

    - `--pq-password` [optional, **empty password is not allowed**] - persisted query redis password

    Alternatively, set those configurations directly in `app/etc/env.php` under `cache` key:

    ```php
    'cache' => [
        'persisted-query' => [
            'redis' => [
                'host' => '<REDIS HOST>',
                'scheme' => 'tcp',
                'port' => '<REDIS PORT>',
                'database' => '5'
            ]
        ]
    ]
    ```

3. Install the ScandiPWA theme:

    > **Note**: by default for `<YOUR VENDOR>/<YOUR THEME>` we are using `Scandiweb/pwa`. But you can choose any other one.

    ```bash
    php bin/magento scandipwa:theme:bootstrap <YOUR VENDOR>/<YOUR THEME>
    ```

4. Go to the bootstrapped theme folder, and install the dependencies and compile a project:

    ```bash
    cd app/design/frontend/<YOUR VENDOR>/<YOUR THEME>
    npm ci # install dependencies
    npm run build
    ```

5. Time to change Magento theme:

    1. Follow [official guide](https://devdocs.magento.com/guides/v2.3/frontend-dev-guide/themes/theme-apply.html) to set a theme

    2. For desired store, set the theme to `<YOUR VENDOR>/<YOUR THEME>`

## Time to open the site

1. Open your favorite browser, i.e. Google Chrome

2. Open your server domain

## Something does not work?

Upon immediate inspection theme could appear fine, but might not load at all. Please open you inspector and make sure the requests (at least one GET and one POST) has returned successfully. If they did, please checkout the rest for `error` fields in response. The most common issues are:

1. Missing Header and Footer CMS blocks.

    To resolve, go to the admin panel, create at least one CMS block and one Scandiweb menu, then go to _Store > Configuration > ScandiPWA > Content customization_ and select CMS blocks for all fields. If you will select the field to be "empty" it will also count as a selection.

2. Homepage not showing - refer to the [FAQ](/setup/docker/faq.md), search for `404 on Homepage`.

> **Note**: after changing those configurations remember to flush the Magento caches.

For other issues, follow this simple algorithm:

1. Refer to the [FAQ page](/setup/docker/faq.md). It most probably already has the solution to your problem.

    > **Note**: the Docker setup related issues are also mentioned in this document.

2. If the issue still persists, [join our community slack](https://join.slack.com/t/scandipwa/shared_invite/enQtNzE2Mjg1Nzg3MTg5LTQwM2E2NmQ0NmQ2MzliMjVjYjQ1MTFiYWU5ODAyYTYyMGQzNWM3MDhkYzkyZGMxYTJlZWI1N2ExY2Q1MDMwMTk), and feel free to ask questions in `#pwa_tech` public channel.

3. Alternatively [create an issue on GitHub](https://github.com/scandipwa/scandipwa-base/issues/new/choose) - however, the response time there will be a little-bit longer than in community Slack.

