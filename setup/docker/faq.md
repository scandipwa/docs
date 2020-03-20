# FAQ (docker local setup)

<style>
summary {
    font-family: var(--heading-h3-font-family, var(--heading-font-family));
    font-size: var(--heading-h3-font-size);
    font-weight: var(--heading-h3-font-weight, var(--heading-font-weight));
    line-height: var(--base-line-height);
}

details {
    margin-bottom: 1rem;
}
</style>

**If you have not found an answer to your issue** here, but happened to resolve it on your own / with help of community - please open a pull-request, or an issue with solution details.

In code examples, you might stumble across such declaration:

```bash
# to clone the fork
git clone git@github.com:<YOUR GITHUB USERNAME>/scandipwa-base.git
```

!> **Note**: the `<YOUR GITHUB USERNAME>` is not a literal text to keep, but the "template" to replace with the real value.

## Search does not work, product can not be saved, can not complete checkout, Magento throwing: `Indexer handler is not available`

The `elasticsearch` is might not be working. The reason of problems above can be seen in the logs of application container, to see the logs, use:

```bash
docker-compose logs -f app
```

There you will see the message saying "indexer is not available". The **elasticsearch** is an indexer of Magento 2 (by our configuration). Make sure this container (the container will be named `scandipwa-base_elasticsearch_1`) is `up`:

```bash
docker-compose ps
```

If `elasticsearch` is showing `stopped` status, then it is down and must be restarted. But there must be a reason of elasticsearch stop. Check the logs of this container:

```bash
docker-compose logs -f elasticsearch
```

If you see an error log related to `max_map_count` value being to low, do following:

On your **host** machine, execute following command:

```bash
sudo sysctl -w vm.max_map_count=262144 # for too low `max_map_count`
```

> **Note**, to set this values permanently, follow [this guide](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html#vm-max-map-count).

After this, you can restart the `elasticsearch` container. To do it:

```bash
docker-compose restart elasticsearch
```

If for some reason issue persits, and the `elasticsearch` container keeps getting stopped after restart - you have a temporary option to switch the indexer itself.

To switch indexer, in Magento 2 admin, go to:
_Stores > Configuration > Catalog > Catalog > Catalog Search > Search Engine_ and set to `MySQL`.

> **Note**, after the next deploy, this value will be switched back to `elasticsearch` as this setting is set during the deploy.

## The site does not open at all / loads forever

Sometimes the nginx can not find `varnish` host. Execute following commands:

```bash
# if you have the alias set up
dc restart nginx ssl-term
dc restart varnish

# without aliases (not recommended)
docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml restart nginx ssl-term
docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml restart varnish
```

## The `503 backend fetch failed`

Execute following commands:

```bash
# if you have the alias set up
dc restart varnish

# without aliases (not recommended)
docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml restart varnish
```

## The `502 bad gateway` in production-like setup

First, check if the `app` container is `up`. You can do this by executing (look for the `scandipwa-base_app_1` container status):

```bash
docker-compose ps
```

If the `app` container is up, then you need to see the application logs to make a decision.

You can see when the application is ready to receive connections by watching `app` logs, using this command:

```bash
# if you have the alias set up
applogs

# without aliases (not recommended)
docker-compose logs -f --tail=100 app
```

If you can see following output, the application is ready!

```bash
NOTICE: ready to handle connections
```

Wait for output above, afterwards, the `502` error should be resolved.

If the app is ready to handle connections, but the site still respond with `502`, you might want to look into `app` logs a little deeper. Execute:

```bash
docker-compose logs -f app
```

Scroll those logs to the very top and see if any `error` appears. If it does, search for this error mentions in this FAQ. If there are no error, execute the same instructions as in the **The nginx can not find `varnish` host** FAQ section.

## The `composer` related issues

Inspect the `app` container logs, using following command:

```bash
# if you have the alias set up
applogs

# without aliases (not recommended)
docker-compose logs -f --tail=100 app
```

If you find the following error in the logs:

```bash
Please set COMPOSER_AUTH environment variable
```

Make sure you have a valid Magento 2 `COMPOSER_AUTH` set. This is an environment variable set on your host machine. To test if it is set, use:

```bash
env | grep COMPOSER_AUTH
```

If the output of this command is empty, or, if the output (JSON object) does not contain `"repo.magento.com"` key, you need to set / update the environment variable.

   1. Make sure you have a valid Magento account. You can [create](https://account.magento.com/applications/customer/create/) or [login to existing one](https://account.magento.com/applications/customer/login/) on Magento Marketplace site.

   2. Upon logging to your Magento Marketplace account follow the [official guide](https://devdocs.magento.com/guides/v2.3/install-gde/prereq/connect-auth.html) to locate and generate credentials.

   3. Now, using the following template, set the environment variable:

       ```bash
       export COMPOSER_AUTH='{"http-basic":{"repo.magento.com": {"username": "<PUBLIC KEY FROM MAGENTO MARKETPLACE>", "password": "<PRIVATE KEY FROM MAGENTO MARKETPLACE>"}}}'
       ```

       To set the environment variables follow [this guide](https://www.serverlab.ca/tutorials/linux/administration-linux/how-to-set-environment-variables-in-linux/). Make sure to make them persist (stay between reloads).

If upon ispection you see a different error:

```bash
COMPOSER_AUTH environment variable is malformed, should be a valid JSON object
```

Check if the environment variable is set properly, it must be valid JSON object.

This issue is common with AWS ECS setups. If you happened to use one, make sure to set it in the folowing way (without quotes):

```json
{
    "name": "COMPOSER_AUTH",
    "value": "{\"http-basic\":{\"repo.magento.com\": {\"username\": \"<PUBLIC KEY FROM MAGENTO MARKETPLACE>\", \"password\": \"<PRIVATE KEY FROM MAGENTO MARKETPLACE>\"}}}"
}
```

If the different, `Invalid credentials ...` error appears, like this, for example:

```bash
# the general one, like this:
Invalid credentials for 'https://repo.magento.com/packages.json', aborting

# the more specific one, like this:
The 'https://repo.magento.com/archives/magento/framework/magento-framework-102.0.3.0.zip' URL required authentication.
```

This indicates on:

- issue with credentials, try obtaining new ones from Magento Marketplace.

- the `COMPOSER_AUTH` might be valid JSON, but missing the `"repo.magento.com"` key in it. Again, refer to the instruction above to obtain tokens.

## The `orphans` warning

If the following waring appears during infrastracture run (using `up -d`):

```bash
WARNING: Found orphan containers (scandipwa-base_frontend_1) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up.
```

This indicates you missed the `--remove-orphans` flag. Please run your setups using it, like so:

```bash
# if you have the alias set up
dc up -d --remove-orphans

# without aliases (not recommended)
docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml up -d --remove-orphans
```

Or in **development** setup:

```bash
# if you have the alias set up
dcf up -d --remove-orphans

# without aliases (not recommended)
docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml -f docker-compose.frontend.yml up -d --remove-orphans
```

## The `index.php` in URL

This is common Magento issue. To resolve it, you need to go into Magento 2 admin. From there:

1. Go to _Stores > Configuration > General > Web > Search Engine Optimization > Use Web Server Rewrites_ set them to `Yes`

2. Go to _Stores > Configuration > General > Web > Base URLs_ check they end with `/`

3. Go to _Stores > Configuration > General > Web > Base URLs_ (Secure) check they end with `/`

## The `404` on homepage

If the homepage shows `404` - there could be mutiple reasons. Check following configurations:

1. Go to _Stores > Configuration > General > Web > Default Pages > CMS Home Page_ and check if it is set

2. Go to _Content > Pages_ make sure the column `Store View` is not empty for your Home Page CMS page. If it is empty, click on the page, select neccessary stores and click save (the stores might appear selected, igonre it).

## The `Operation not permited` (permission issues)

If at any point when looking on logs of the `app` container the following message pops up:

```bash
<ANY ACTION> Operation not permited
```

You have a permission issue. To resolve it, run following command on your host machine, from the `scandipwa-base` project directory:

```bash
sudo chmod -R 777 .
```

Why this issue occured?

You could have ran some command in the `app` container as `root` user. You must run them from `user`. How?

```bash
# use `inapp` alias to get inside of the `app` container as `user`
inapp bash

# use `-u user` argument to execute as a user
docker-compose exec -u user app
```

## The `ERR_CERT_REVOKED` in Chrome

If the Google Chrome shows following issue in Chrome:

```bash
NET::ERR_CERT_REVOKED > issuer: ScandiPWA ...
```

Then, there are some problems with generated certificate. As a solution to that porblem, try:

1. Import & trust the `opt/cert/scandipwa-fullchain.pem` from the project source directory
2. Type `thisisunsafe` on the certificate error page

## The `address already in use` error on setup

If following error appears on container startup:

```bash
ERROR: for <CONTAINER NAME> Can not start service ... : listen tcp 0.0.0.0:<PORT>: bind: address already in use
```

This indicates that one or multiple ports required for the setup are already in use by other processes. Please make sure following ports are not in use: `80, 334, 3307, 1080, 5601`.

See [this instruction](https://appuals.com/how-to-kill-process-on-port/) to find out how to kill processess on specific ports.

## Database migration failed

First time, when uploading a demo-dump, you might stumble across the error:

```bash
Database migration failed: manual action required
```

This could mean, that the database dump apply was not executed successfully. In order to resolve this, run the migration again, but manually:

```bash
# if there is no mysql installed locally
docker ps | grep mysql # get the container ID (i.e. d7886598dbe2)
docker cp deploy/latest.sql <CONTAINER ID>:/tmp/dump.sql
docker-compose exec mysql bash
mysql -u root -pscandipwa -e "DROP DATABASE magento; CREATE DATABASE magento;"
mysql -u root -pscandipwa < deploy/latest.sql


# or if you have a mysql locally installed
mysql -h localhost -P 3307 --protocol=tcp -u root -pscandipwa < deploy/latest.sql
```

## The `ENV_VARIABLE` variable is not set

If when setting up, you notice the following issue:

```bash
# note: PROJECT_IMAGE is an example variable
WARNING: The PROJECT_IMAGE is not set. Defaulting to a blank string.
```

Your machine does not support symlinks. Possibly, you are setting up on Windows. To resolve the issue, fix following files: `.env` and `.application`. To fix them, replace the content of those files with the content of the file mentioned inside. So, for example:

```bash
.env # replace content with deploy/local/env
```

## Ratings are not displayed

First time, when uploading a demo-dump, the rating might not be properly displayed.

To resolve this, follow simple steps:
1. Go to _Stores > Attributes > Rating_
2. Click on every in the list and make sure the `visiblity` is set right

## Composer: `requirements could not be resolved`

When installing a theme using `scandipwa/installer` the following (or similar) error might appear:

```bash
Your requirements could not be resolved to an installable set of packages.
```

This could indicate to current Magento version not matching the the latest version of `scandipwa/installer`. To resolve this:

- For Magento versions below 2.3.3 please use installer ^1.0. Use following command:

    ```bash
    composer require scandipwa/installer ^1.0
    ```

!> **Note**: This will install older versions of ScandiPWA, and we suggest to upgrade Magento to 2.3.3 to make it possible to use latest ScandiPWA versions.

## Content customization does not work

If the customization selected in the BE configuration (_Stores > Configuration > ScandiPWA > Color customization_) is not working (not opening at all):

- Update the customization module to `1.0.1^` using following command:

    ```bash
    composer update scandipwa/customization
    ```

- Alternatively, make sure, there exists at least one:
  - CMS block
  - visible on frontend Attribute
  - Scandiweb Menu

## Customization is not displayed

If the customization selected is not displayed on FE, check the `frontend` container. It must be `stopped`, or not running at all. The command for this:

```bash
# if you have the alias set up
dcf ps | grep frontend

# without aliases (not recommended)
docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml ps | grep frontend
```

Must output nothing, or `stopped` in the container status. If it is running, the re-create the setup without frontend container:

```bash
# if you have the alias set up
dc up -d --remove-orphans

# without aliases (not recommended)
docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml up -d --remove-orphans
```

!> **Note**: the customization does not work in "development" mode - when the `frontend` container is running.

## Luma theme is displayed

If after following all steps of installation the `Luma` or other default theme keeps showing make sure following is true:

1. On the server (in the container) the theme folder (`app/design/frontend/<VENDOR>/<NAME>`, in docker-setup `app/design/frontend/Scandiweb/pwa`) has the folder named `Magento_Theme` inside. This folder must not be empty. It should contain two other folders. If this is not true, from themes root folder execute:

    ```bash
    npm ci && npm run build
    ```

    This should install and compile the theme, after command execution, the folder should appear. If it does not - you might have stumbled upon some compilation issue, please read the compilation logs to found out where and why.

2. The theme is set in admin. To check the _Content > Design > Themes_ (from Magento admin) and make sure your store has a ScandiPWA theme set.

3. In case all of above are true, but the theme is not appearing, please execute following:

    ```bash
    magento c:f
    ```

    Check the frontend again after that.

## Invalid regular expression: missing /
