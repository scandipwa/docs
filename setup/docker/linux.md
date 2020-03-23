# Linux local setup (using docker)

This guide is for setting up on linux machines. This guide is meant for **local installation only**.

## Follow me setting the theme up

?> **Note**: video is coming soon!

## Before you start

1. If you plan to make changes to the theme make sure to [create GitHub account](https://github.com/join), or [sign in](https://github.com/login) into existing one.

    1. Make sure you have a SSH key assigned to your GitHub account, and you current machine has the same key. Read [how to setup SSH key on GitHub](https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account).

    2. Make sure to fork [`scandipwa-base` repository](https://github.com/scandipwa/scandipwa-base). Read [how to fork repository on GitHub](https://help.github.com/en/github/getting-started-with-github/fork-a-repo).

2. Make sure you have `git` and `docker-compose` binaries installed. To test, execute following command in the bash terminal:

    ```bash
    git --version # it should be ^2
    docker-compose -v # it should be ^1.24
    ```

    - If `git` was not found, please follow [this installation instruction](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

    - If `docker-compose` was not found, please follow [this installation instruction](https://docs.docker.com/compose/install/).

3. Choose an installation directory. It can be anywhere on your computer. Folder `/var/www/public` is not necessary, prefer `~/Projects/` for ease of use.

4. Make sure the virtual memory `max map count` on your host machine is set high-enough. Follow [the instruction](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html#vm-max-map-count) to set it to appropriate level.

5. To make your life easier, make sure to create an aliases for docker-compose commands. Follow [the guide](https://www.tecmint.com/create-alias-in-linux/) to create **permanent** aliases. We recommend defining following:

    ```bash
    # use `dc` to start without `frontend` container
    alias dc="docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml"

    # use `dcf` to start with `frontend` container
    alias dcf="docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml -f docker-compose.frontend.yml"

    # use `inapp` to quickly get inside of the app container
    alias inapp="docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml -f docker-compose.frontend.yml exec -u user app"

    # use `applogs` to quickly see the last 100 lines of app container logs
    alias applogs="docker-compose logs -f --tail=100 app"

    # use `frontlogs` to quickly see the last 100 lines of frontend container logs
    alias frontlogs="docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml -f docker-compose.frontend.yml logs -f --tail=100 frontend"
    ```

    Those aliases are required to have all services available at all times. Otherwise, if just using `docker-compose` only services defined in `docker-composer.yml` will be available. Understand what services are available at all by reading [this part of our documentation](https://docs.scandipwa.com/#/docker/03-services?id=list-of-available-services).

6. Make sure you have a valid Magento 2 `COMPOSER_AUTH` set. This is an environment variable set on your host machine. To test if it is set, use:

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


7. Execute following command to add `scandipwa.local` to your `/etc/hosts` file and map it to the `127.0.0.1`:

    ```bash
    echo '127.0.0.1 scandipwa.local' | sudo tee -a /etc/hosts
    ```

## When you are ready

1. Get the copy of `scandipwa-base` - clone your fork, or clone the original repository. **Do not try to download the release ZIP - it will contain outdated code**.

    ```bash
    # to clone the fork
    git clone git@github.com:<YOUR GITHUB USERNAME>/scandipwa-base.git

    # to clone the original repository
    git clone git@github.com:scandipwa/scandipwa-base.git

    # to clone via HTTPS (not recommended)
    git clone https://github.com/scandipwa/scandipwa-base.git
    ```

    > **Note**: sometimes, after the repository is cloned, the git chooses the `master` branch as default. This is the legacy (incorrect) default branch in case of `scandipwa-base`. Please make sure you are using `2.x-stable`. You can do it using following command:

    ```bash
    git status # expected output `On branch 2.x-stable`
    ```

    If any other output has been returned, execute the following command to checkout the correct branch:

    ```bash
    git checkout 2.x-stable
    ```

2. Generate and trust a self-signed SSL certificate.

    1. Begin with generating a certificate. Use the following command for that:

        ```bash
        make cert
        ```

        > **Note**: you will be asked to type in the password 6 times. **This is NOT your host machine password**, this is a **NEW** password for your certificate. This password must be at least 6 characters long.

    2. Add certificate to the list of trusted ones. Use this [guide](https://manuals.gfi.com/en/kerio/connect/content/server-configuration/ssl-certificates/adding-trusted-root-certificates-to-the-server-1605.html) (or [guide for Arch linux](https://bbs.archlinux.org/viewtopic.php?pid=1776753#p1776753)) to do it. The `new-root-certificate.crt` / `foo.crt` from these guide examples must be replaced with `<PATH TO PROJECT ROOT>/opt/cert/scandipwa-ca.pem`.

    3. Reload the Google Chrome. Sometimes, the Google Chrome caches the old-certificates. Make to completely exit chrome, before opening it back. Sometimes, the "invalid certificate" issues only disappears after the full host machine reload.

3. Pull all necessary container images

    > **Note**: `container image` != `media image`. Read more about [container images here](https://docs.docker.com/v17.09/engine/userguide/storagedriver/imagesandcontainers/).

    ```bash
    # if you have the alias set up
    dcf pull

    # without aliases (not recommended)
    docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml pull
    ```

***

There are two ways to use the setup: with `frontend` container and without it. The setup with `frontend` container is called **development**. The alias running it is `dcf`. The alias for **production**-like run is `dc`. If this is your first time setting up, run the (production-like) setup first (follow the step 4), otherwise the frontend container will not function properly.

?> **Note**: If you have already ran ScandiPWA in **production**-like mode once, you can safely skip to step 6. In case, of course, you plan on development.

***

4. Start the infrastructure in **production-like** mode

    ```bash
    # if you have the alias set up
    dc up -d --remove-orphans

    # without aliases (not recommended)
    docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml up -d --remove-orphans
    ```

    > **Note**: the `--remove-orphans` flag is necessary to remove all left-over containers. In example, if you switched from **development** to **production** setup, the `frontend` container won't keep running.

5. Wait until the infrastructure starts

    After the previous command is executed, the site won't be available quickly, it takes about 140s to start, you can see when the application is ready to receive the requests by watching `app` logs, using this command:

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

6. Start the development-setup (optional)

    ```bash
    # if you have the alias set up
    dcf up -d --remove-orphans

    # without aliases (not recommended)
    docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml -f docker-compose.frontend.yml up -d --remove-orphans
    ```

7. Wait until the development infrastructure starts

    In **development** setup - the page will be available much faster rather than in **production**-like setup - right after the theme compilation in `frontend` container. You can track the progress using following command:

    ```bash
    # if you have the alias set up
    frontlogs

    # without aliases (not recommended)
    docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml -f docker-compose.frontend.yml logs -f --tail=100 frontend
    ```

    If you can see following output, the frontend is ready!

    ```bash
    ℹ ｢wdm｣: Compiled successfully
    ```

    > **Note**: the requests to `/graphql` will still fail, you need to wait until the `app` container starts. See instruction in step 5 to see how.

## How to access the site?

1. Open your favorite browser, i.e. Google Chrome

2. Regardless of **production** or **development** setup go to [https://scandipwa.local](https://scandipwa.local)

    1. In **production** the Magento (`app` container) is fully responsible for what you see in browser

    2. In **development** the webpack-dev-server (`frontend` container) is responsible for frontend, while `/media`, `/graphql`, `/admin` URLs are still coming from Magento.

3. To access the Maildev, go to [http://scandipwa.local:1080/maildev](http://scandipwa.local:1080/maildev)

4. To access the Kibana, go to [http://scandipwa.local:5601](http://scandipwa.local:5601)

## Want to get the demo content?

To get the [demo.scandipwa.com](https://demo.scandipwa.com/) content (but without multi-store and languages) follow this step-by-step guide:

1. Stop the `app` container, using following command:

    ```bash
    # if you have the alias set up
    dc stop app

    # without aliases (not recommended)
    docker-compose stop app
    ```

2. Drop the existing database

    ```bash
    docker-compose exec mysql mysql -u root -pscandipwa -e "DROP DATABASE magento; CREATE DATABASE magento;"
    ```

3. Import the demo site database dump

    ```bash
    docker-compose exec -T mysql mysql -u root -pscandipwa magento < deploy/latest.sql
    ```

4. Recreate the infrastructure

    ```bash
    docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml up -d --force-recreate
    ```

5. Get the media files

    There are two options to get the media files - automatic (using wget), and manual.

    - Get media files automatically

        > **Note**: the following command requires you to have the `wget` binary available. To check if it is available, use following command:

        ```bash
        wget --version # should output version ^1
        ```

        If the `wget` command is not found, follow [this guide](https://www.tecmint.com/install-wget-in-linux/) to get it. Else, or after installation, execute following command to download & extract media:

        <!-- TODO: TEST FOLLOWING COMMAND -->

        ```bash
        wget -c https://scandipwa-public-assets.s3-eu-west-1.amazonaws.com/2.2.x-media.tar.gz -O - | sudo tar -xz -C <PATH TO PROJECT ROOT>src/pub/media
        ```

    - Get media files manually

        1. Download media files from [S3 bucket](https://scandipwa-public-assets.s3-eu-west-1.amazonaws.com/2.2.x-media.tar.gz)

        2. Move archive into the `<PATH TO PROJECT ROOT>src/pub/media` folder

        3. Extract the archive using following command:

            ```bash
            tar -zxvf scandipwa_media.tgz
            ```

## Want some development guidance?

Stuck? Don't know where to start? Checkout our development guide! It will guide you through the best-practices working with ScandiPWA! How to debug, configure the code-editor, code-style checker and create your first base-template! This, and much-much more in:

[<span class="Button">Our awesome development guide</span>](/scandipwa/development.md)

## Something does not work?

Follow this simple algorithm:

1. Refer to the [FAQ page](/setup/docker/faq.md). It most probably already has the solution to your problem.

2. If the issue still persists, [join our community slack](https://join.slack.com/t/scandipwa/shared_invite/enQtNzE2Mjg1Nzg3MTg5LTQwM2E2NmQ0NmQ2MzliMjVjYjQ1MTFiYWU5ODAyYTYyMGQzNWM3MDhkYzkyZGMxYTJlZWI1N2ExY2Q1MDMwMTk), and feel free to ask questions in `#pwa_tech` public channel.

3. Alternatively [create an issue on GitHub](https://github.com/scandipwa/scandipwa-base/issues/new/choose) - however, the response time there will be a little-bit longer than in community Slack.

