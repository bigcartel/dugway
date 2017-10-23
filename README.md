# Dugway [![Build Status](https://travis-ci.org/bigcartel/dugway.png?branch=master)](https://travis-ci.org/bigcartel/dugway) [![Gem Version](https://badge.fury.io/rb/dugway.png)](http://badge.fury.io/rb/dugway)

**_The easy way to build Big Cartel themes._**

Dugway allows you to run your Big Cartel theme on your computer, test it in any
browser, write code in your favorite editor, and use fancy new tools like
CoffeeScript, Sass, and LESS. It's awesome.

[![Walkthrough](http://cl.ly/image/101e1z3Y3B1w/Screen%20Shot%202013-04-01%20at%205.04.40%20PM.png)](https://vimeo.com/bigcartel/dugway)

## Disclaimer

_Dugway is used internally by Big Cartel to develop our themes, and only we are
able to modify a theme's settings.json file, host a theme's assets, and upload
a fully packaged theme zip. You're free to use Dugway to develop a custom theme,
or modify one of our [default themes](https://github.com/bigcartel-themes), but
you'll need to base your settings.json on one of our [default themes](https://github.com/bigcartel-themes),
host images, fonts, and JavaScript assets separately, and copy/paste theme pages
individually in the Big Cartel admin._

## Install

Dugway is Ruby gem so you'll need to have Ruby 2.0+ installed. Ruby is
usually pre-installed on Mac OS X and Linux, and Windows users can install it
using [RubyInstaller](http://rubyinstaller.org). From there, simply install the
**dugway** gem from the terminal.

```
gem install dugway
```

## Creating a new theme

With Dugway installed, you can now create a new theme, simply give it a name.

```
dugway create mytheme
```

This will create a new directory named *mytheme* that contains a few
configuration files and a starter theme to get you going.

```
mytheme
├── source
|   ├── fonts
│   │   └── all font files for your theme
│   ├── images
│   │   └── all image files for your theme
│   ├── javascripts
│   │   └── all JavaScript files for your theme
│   ├── stylesheets
│   │   └── all CSS files for your theme
│   ├── cart.html
│   ├── contact.html
│   ├── home.html
│   ├── layout.html
│   ├── maintenance.html
│   ├── product.html
│   ├── products.html
│   ├── screenshot.jpg
│   ├── settings.json
│   ├── theme.css
│   └── theme.js
└── config.ru
```

## Developing your theme

All of the assets and source code for your theme goes in the **source** directory.

### HTML

Develop the HTML for your theme using our [Theme
API](https://developers.bigcartel.com/api/themes). Barebones versions of all
of the required HTML pages for your theme are provided by default, so feel free
to expand on those or replace them entirely.

### CSS & JavaScript

All CSS for your theme is handled by the **theme.css** file, and all JavaScript
by **theme.js**. If you don't have much CSS or JavaScript, or you're just a
glutton for punishment, you could simply put all of your code in these two
files. However, we recommend you use [Sprockets](#using-sprockets) to break
your code into multiple files in separate directories.

#### Using Sprockets

[Sprockets](https://github.com/sstephenson/sprockets) allows you to bring in
CSS and JavaScript from different directories into a single file. We've created
**stylesheets** and **javascripts** directories by default that you can put
your code in, but you could delete those and put files anywhere you'd like.
After that, use [Sprockets
directives](https://github.com/sstephenson/sprockets#the-directive-processor)
to package them into **theme.css** and **theme.js**.

##### theme.css

```css
/*
 *= require stylesheets/example_1
 *= require stylesheets/example_2
 */
```

##### theme.js

```js
//= require javascripts/example_1
//= require javascripts/example_2
```

#### Using Sass, Compass, LESS, and CoffeeScript

Dugway also allows you to use [Sass](http://sass-lang.com) in your separate
files by appending the **.sass** or **.scss** extension after **.css**. You can
even use [Compass](http://compass-style.org/) right out of the box to help
author your stylesheets by utilizing its mixins for CSS3, typography, and its
utilities.

Prefer [LESS](http://lesscss.org)? No problem, you'll just need to create a
[Gemfile like this one](https://gist.github.com/mattwigham/5569898) in the
root directory of your theme, run ```bundle install```, and append the
**.less** extension to your CSS files.

And finally, for you JavaScript folks, we've baked
[CoffeeScript](http://coffeescript.org) support right in. Just append the
**.coffee** extension after **.js** to your separate JS files.

#### Embedding CSS & JavaScript

You can embed the CSS and JavaScript into your theme by passing the theme
variable to the
[theme_css_url](https://developers.bigcartel.com/api/themes#theme_css_url)
and [theme_js_url](https://developers.bigcartel.com/api/themes#theme_js_url)
filters.

##### CSS (theme.css)

```html
<link href="{{ theme | theme_css_url }}" media="screen" rel="stylesheet" type="text/css">
```

##### JavaScript (theme.js)

```html
<script src="{{ theme | theme_js_url }}" type="text/javascript"></script>
```

### Images

And as you've probably guessed by now, all images for your theme go in the
**images** directory. You can reference an image in your code by passing its
name to the
[theme_image_url](https://developers.bigcartel.com/api/themes#theme_image_url)
filter.

```
{{ 'sample.png' | theme_image_url }}
```

### Fonts

Fonts work more or less the same as images. Place font files (say if you have
created a custom icon font) in the **fonts** directory. Reference them by
passing its name to the `theme_font_url` filter. Please be aware of licensing
restrictions. If you're using a font from a forge and don't have permission to
host the files directly or have restrictions about only making them available
to certain domains, you will need to use another mechanism for hosting your
fonts. Any font uploaded as part of a Dugway bundle will essentialy be publicly
available and not CORS-restricted to specific domains.

```
{{ 'myfont.woff' | theme_font_url }}
```

## Running your theme

Run your theme in any browser by starting the Dugway server:

```
dugway server
```

By default this will serve your theme at http://0.0.0.0:9292. You can then stop
the server by hitting CTRL+C.

### Pow

Tired of all the manual starting and stopping? Good news, Dugway is built on
top of Rack, which means you can use [Pow](http://pow.cx) on Mac. This also
allows you to access your theme at a pretty URL like _mytheme.dev_.

## Testing your theme

Part of building a great theme is making sure it works well in a variety of
contexts and with a variety of content. Dugway makes it easy to test your
theme's versatility by utilizing the **.dugway.json** file. This file will be
specific to your computer for your own testing, and shouldn't be checked into
source control.

*Note:* changing **.dugway.json** will require you to restart the
[server](#running-your-theme).

### Store content

The best way to see your theme under a different light is by previewing it with
a different store's products, categories, pages, currency, and other content.
To do this, simply set the **store.subdomain** variable in **.dugway.json** to
any Big Cartel store's subdomain, and Dugway will bring in their content using
the standard [Big Cartel API](https://developers.bigcartel.com/api/themes). By
default we use **dugway** for
[dugway.bigcartel.com](http://dugway.bigcartel.com).

```json
"store": {
  "subdomain": "beeteeth"
}
```

*Note:* don't worry, any sensitive data like inventory levels and discount codes is faked by Dugway.

### Store customization

Another important thing to consider is how store owners will customize your
theme. You establish what can be customized in your settings.json file, and 
Dugway allows you to simulate potential values people could choose by
setting them in the **customization** variable in **.dugway.json**. By default
we use the **default** values from your **settings.json** file.

```json
"customization": {
  "logo": {
    "url": "http://placehold.it/200x50/000000/ffffff&text=My+Logo",
    "width": 200,
    "height": 50
  },
  "background_color": "#CCCCCC",
  "show_search": true,
  "twitter_username": "bigcartel"
}
```
