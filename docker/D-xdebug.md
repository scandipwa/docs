# XDebug Setup and Usage

## Watch the video tutorial

<iframe width="560" height="315" src="https://www.youtube.com/embed/vCcT7TPv8lA" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Setup

php with xdebug is can be set for local, by changing $PROJECT_IMAGE variable to `xdebug` in corresponding `.env` files, ensuring corrent docker image to be used.

### PhpStorm configuration

#### Browser Plugin

Install browser extensions to supply cookie for enabling debug - <https://confluence.jetbrains.com/display/PhpStorm/Browser+Debugging+Extensions>

#### Debugger settings in IDE

Now to set the PhpStorm, go to:

_Preferences > Languages & Frameworks > PHP > Debug_

In this window check the following settings:

-   Xdebug section, set port 9111
-   "Can accept external connections" is checked
-   "Ignore external connections through unregistered server configurations" is checked
-   Other settings is up to your preferences of the debugger

Now we need to set up a server configuration, to map local files to remote application container, head to:

\_Languages & Frameworks > PHP > Debug > Servers\_\_

-   Add new configuration by clicking the **+** symbol
-   Host: <localhost>
-   Port: 3001, which is default nginx port, try to avoid using varnish port and disable varnish in magento configuration during debug sessions
-   Debugger: Xdebug
-   And map your local `./src/` directory to remote `/var/www/public`

### Setting up IP alias

To allow connections from container to debug console in PhpStorm you need to add following alias to you system, this setting is **not** persisted between restarts, update your env accordingly

**Linux**

`sudo ip address add 172.254.254.254/24 dev docker0`

**macOS**

`sudo ifconfig en0 alias 172.254.254.254 255.255.255.0`

Now the configuration is complete, happy debugging!
