# Scandi PWA documentation

The documentation is split in two parts:

## [ScandiPWA Theme](/theme/01-Project.md)

All related to PWA theme and it's internal components

## [Docker Setup](/docker/01-how-to-start.md)

All about Docker environment and local setup

## ScandiPWA Video guides

<style>
.video {
	width: 100%;
	max-width: 600px;
	padding-bottom: 56.25%;
	position: relative;
	margin: 1em 0;
}

.video iframe {
	margin: 0;
	position: absolute;
	object-fit: cover;
	width: 100%;
    height: 100%;
    left: 0;
    top: 0;
}
</style>

### Getting started - demo setup
<div class="video">
	<iframe src="https://www.youtube.com/embed/uMfuNiRNusM" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

### Theme structure overview
<div class="video">
	<iframe src="https://www.youtube.com/embed/MyMwFMr2Dns" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

### Theme customization (overrides)
<div class="video">
	<iframe width="560" height="315" src="https://www.youtube.com/embed/ukBQpajluXg" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

## Reporting issues

For theme issues create a ticket here: <https://github.com/scandipwa/base-theme/issues>  
For docker related issues create ticket here: <https://github.com/scandipwa/scandipwa-base/issues>  

Or ask in [Slack](https://scandipwa.com/#subscribe-slack) channel

## Developing docs

Documentation live version <https://docs.scandipwa.com>
Documentation repository <https://github.com/scandipwa/docs>

Docs written in Markdown, use any editor as you like  
**If you add new page to the docs, add it also to the `/_sidebar.md`**

[Docsify](https://docsify.js.org/#/?id=docsify) is used to make local preview, with additional plugins and generate  
To use local preview you will need:

-   Setup docsify with `npm install`
-   Execute `npm run serve` to start in dev mode
-   Preview the changes on <http://localhost:4000>
