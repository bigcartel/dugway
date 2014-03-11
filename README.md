# Dugway [![Build Status](https://travis-ci.org/bigcartel/dugway.png?branch=master)](https://travis-ci.org/bigcartel/dugway) [![Gem Version](https://badge.fury.io/rb/dugway.png)](http://badge.fury.io/rb/dugway)

**_The easy way to build Big Cartel themes._**

Dugway allows you to run your Big Cartel theme on your computer, test it in any browser, write code in your favorite editor, and use fancy new tools like CoffeeScript, Sass, and LESS. It's awesome.

[![Walkthrough](http://cl.ly/image/101e1z3Y3B1w/Screen%20Shot%202013-04-01%20at%205.04.40%20PM.png)](https://vimeo.com/bigcartel/dugway)

## Disclaimer

**Dugway is a very new project and likely has several bugs, rough edges, and missing features.** If you run into something weird or have a cool idea, see if it's a [known issue](https://github.com/bigcartel/dugway/issues), and otherwise [report it](https://github.com/bigcartel/dugway/issues/new) and we'll do our best to hook you up. Thanks.

### Known Issues & Limitations

* *You can't currently upload a Dugway build/zip to Big Cartel.* This is next on our list, and is what we built Dugway in preparation for. For now you'll still need to copy/paste theme pages individually in the Big Cartel admin, and host images and JavaScript assets separately.
* *Big Cartel doesn't currently support custom settings.json.* Since we don't support fully uploadable themes yet (as mentioned above), you can't currently use a custom settings.json. For now you'll need to base your theme off of one of our [default themes](https://github.com/bigcartel-themes) and its settings.json.
* *Dugway doesn't currently support all discounts and shipping features.* For now it's best to test those with a live store so it can interact with actual discount and shipping information.

## Install

Dugway is Ruby gem so you'll need to have Ruby 1.9.3+ installed. Ruby is usually pre-installed on Mac OS X and Linux, and Windows users can install it using [RubyInstaller](http://rubyinstaller.org). From there, simply install the **dugway** gem from the terminal.

    gem install dugway

## Creating a new theme

With Dugway installed, you can now create a new theme, simply give it a name.

    dugway create mytheme

This will create a new directory named *mytheme* that contains a few configuration files and a starter theme to get you going.

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
    │   ├── checkout.html
    │   ├── contact.html
    │   ├── home.html
    │   ├── layout.html
    │   ├── maintenance.html
    │   ├── product.html
    │   ├── products.html
    │   ├── screenshot.jpg
    │   ├── settings.json
    │   ├── success.html
    │   ├── theme.css
    │   └── theme.js
    └── config.ru


## Developing your theme

All of the assets and source code for your theme goes in the **source** directory.

### HTML

Develop the HTML for your theme using our [Theme API](http://help.bigcartel.com/customer/portal/articles/772788-creating-a-custom-theme). Barebones versions of all of the required HTML pages for your theme are provided by default, so feel free to expand on those or replace them entirely.

### CSS & JavaScript

All CSS for your theme is handled by the **theme.css** file, and all JavaScript by **theme.js**. If you don't have much CSS or JavaScript, or you're just a glutton for punishment, you could simply put all of your code in these two files. However, we recommend you use [Sprockets](http://getsprockets.org) to break your code into multiple files in separate directories.

#### Using Sprockets

[Sprockets](http://getsprockets.org) allows you to bring in CSS and JavaScript from different directories into a single file. We've created **stylesheets** and **javascripts** directories by default that you can put your code in, but you could delete those and put files anywhere you'd like. After that, use [Sprockets directives](https://github.com/sstephenson/sprockets#the-directive-processor) to package them into **theme.css** and **theme.js**.

##### theme.css

    /*
     *= require stylesheets/example_1
     *= require stylesheets/example_2
     */

##### theme.js

    //= require javascripts/example_1
    //= require javascripts/example_2

#### Using Sass, Compass, LESS, and CoffeeScript

Dugway also allows you to use [Sass](http://sass-lang.com) in your separate files by appending the **.sass** or **.scss** extension after **.css**. You can even use [Compass](http://compass-style.org/) right out of the box to help author your stylesheets by utilizing its mixins for CSS3, typography, and its utilities.

Prefer [LESS](http://lesscss.org)? No problem, you'll just need to create a [Gemfile like this one](https://gist.github.com/ihearithurts/5569898) in the root directory of your theme, run ```bundle install```, and append the **.less** extension to your CSS files.

And finally, for you JavaScript folks, we've baked [CoffeeScript](http://coffeescript.org) support right in. Just append the **.coffee** extension after **.js** to your separate JS files.

#### Embedding CSS & JavaScript

You can embed the CSS and JavaScript into your theme by passing the theme variable to the [theme_css_url](http://help.bigcartel.com/customer/portal/articles/772749-filters#url) and [theme_js_url](http://help.bigcartel.com/customer/portal/articles/772749-filters#url) filters.

##### CSS (theme.css)

    <link href="{{ theme | theme_css_url }}" media="screen" rel="stylesheet" type="text/css">

##### JavaScript (theme.js)

    <script src="{{ theme | theme_js_url }}" type="text/javascript"></script>

### Images

And as you've probably guessed by now, all images for your theme go in the **images** directory. You can reference an image in your code by passing its name to the [theme_image_url](http://help.bigcartel.com/customer/portal/articles/772749-filters#url) filter.

    {{ 'sample.png' | theme_image_url }}

### Fonts

Fonts work more or less the same as images. Place font files (say if you have created a custom icon font) in the **fonts** directory. Reference them by passing its name to the `theme_font_url` filter. Please be aware of licensing restrictions. If you're using a font from a forge and don't have permission to host the files directly or have restrictions about only making them available to certain domains, you will need to use another mechanism for hosting your fonts. Any font uploaded as part of a Dugway bundle will essentialy be publicly available and not CORS-restricted to specific domains.

    {{ 'myfont.woff' | theme_font_url }}

### Settings

Set your theme's name, version, and customizable options in the **settings.json** file. We'll be documenting more about this soon, but for now see the starter file generated for you, and check out our [default themes](https://github.com/bigcartel-themes).

## Running your theme

Run your theme in any browser by starting the Dugway server:

    dugway server

By default this will serve your theme at http://0.0.0.0:9292. You can then stop the server by hitting CTRL+C.

### Pow

Tired of all the manual starting and stopping? Good news, Dugway is built on top of Rack, which means you can use [Pow](http://pow.cx) on Mac. This also allows you to access your theme at a pretty URL like _mytheme.dev_.

## Testing your theme

Part of building a great theme is making sure it works well in a variety of contexts and with a variety of content. Dugway makes it easy to test your theme's versatility by customizing the **options** in the **config.ru** file.

*Note:* changing the **config.ru** file will require you to restart the [server](#running-your-theme).

### Store content

The best way to see your theme under a different light is by previewing it with a different store's products, categories, pages, currency, and other content. To do this, simply set the **:store** option to any Big Cartel store's subdomain, and Dugway will bring in their content using the standard [Big Cartel API](http://help.bigcartel.com/customer/portal/articles/772771-api). By default we use **dugway** for [dugway.bigcartel.com](http://dugway.bigcartel.com).

    options[:store] = 'beeteeth'

*Note:* don't worry, any sensitive data like inventory levels and discount codes is faked by Dugway.

### Store customization

Another important thing to consider is how store owners will customize your theme. You establish what can be customized in your [settings.json](#settings) file, and Dugway allows you to simulate potential values people could choose by setting them in the **:customization** option. By default we use the **default** values from your **[settings.json](#settings)** file.

    options[:customization] = {
      :logo => {
        :url => 'http://placehold.it/200x50/000000/ffffff&text=My+Logo',
        :width => 200,
        :height => 50
      },
      :background_color => '#CCCCCC',
      :show_search => true,
      :twitter_username => 'mytwitter'
    }

## Building your theme

When you're finished with a new version of your theme, it's time to build it.

    dugway build

This will create a zip file for the current version in your **build** directory containing all HTML, images, and packaged JS and CSS.
