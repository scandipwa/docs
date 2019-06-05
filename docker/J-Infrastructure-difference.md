## ScandiPWA infrastructure diffecrence

ScandiPWA has additional requirements to the Magento stack and has some requirements:

1.  Theme install and registration
2.  Persisted Query
3.  SSR - Rendertron and it's routing

Other parts of Magento setup are pretty standard for Varnish, PHP, Nginx, MySQL and Redis

### Magento

These changes are theme installation specific and couple things are required

#### Theme install

The ScandiPWA theme is distributed through `scandipwa/installer`
To install theme on running Magento you need to execute:

1.  `composer require scandipwa/installer` to fetch and install PWA components
2.  `magento scandipwa:theme:bootstrap Scandiweb/pwa` to install theme files from vendor to proper place in Magento themes
3.  `magento setup:upgrade` to register PWA theme in magento
4.  Build theme, for example, like this
```bash
 cd $BASEPATH/app/design/frontend/Scandiweb/pwa || exit
npm ci
npm run build
```

#### Persisted Query

The persisted queries are cached in Redis, each time graphql receives a query, its response is cached with unique hash in redis, if reposnse changes, new hash will be used.

Magento configuration must be set in order to use Redis as storage for persisted queries

```bash
bin/magento setup:config:set \
    --pq-host=redis \
    --pq-port=6379 \
    --pq-database=5 \
    --pq-scheme=tcp
```

Note that `pq-database` must be a new database in Redis and is not used elsewhere.

### Server Side Rendering implementation

The main component for SSR is [rendertron](https://github.com/GoogleChrome/rendertron), and API wrapper around [puppeteer](https://github.com/GoogleChrome/puppeteer) a headless Chrome to render and proxy result to bots

#### Building rendertron

There is prebuild docker container for Rendertron available - <https://hub.docker.com/r/scandipwa/rendertron>

If you need to manually build it, can borrow its script from here - <https://github.com/scandipwa/scandipwa-base/blob/master/build/rendertron/Dockerfile>

#### Routing traffic to Rendertron

Sample nginx configuration to route traffic through rendertron or directly to the Magento

```bash
location / {
  set $prerender 0;
  if ( $http_user_agent ~* 'Googlebot|slackbot') {
    set $prerender 1;
  }
  
  if ( $http_x_renderer ~* 'rendertron' ) {
    set $prerender 0;
  }
  
  if ($uri ~* "\.(js|css|xml|less|png|jpg|jpeg|webp|gif|pdf|doc|txt|ico|rss|zip|mp3|rar|exe|wmv|doc|avi|ppt|mpg|mpeg|tif|wav|mov|psd|ai|xls|mp4|m4a|swf|dat|dmg|iso|flv|m4v|torrent|ttf|woff|svg|eot)") {
    set $prerender 0;
  }

  proxy_set_header Host              $http_host;
  proxy_set_header X-Real-IP         $remote_addr;
  proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
  proxy_redirect off;
  proxy_read_timeout 600s;

  if ($prerender = 1) {
    proxy_pass http://rendertron:8083/render/https://$host$request_uri;
  }
  if ($prerender = 0) {
    proxy_pass http://varnish:80;
  }
}
```

Full config is here - <https://github.com/scandipwa/scandipwa-base/blob/master/deploy/shared/conf/nginx/cache-router.conf>

