# Dugway [![Build Status](https://travis-ci.org/bigcartel/dugway.png)](https://travis-ci.org/bigcartel/dugway)

**_The easy way to build Big Cartel themes._**

Dugway allows you to run your Big Cartel theme on your computer, test it in any browser, write code in your favorite editor, and use fancy new tools like CoffeeScript, Sass, and LESS. It's awesome.

## Disclaimer

**Dugway is a very new project and likely has several bugs and rough edges.** If you run into something weird, see if it's a [known issue](https://github.com/bigcartel/dugway/issues), and otherwise [report it](https://github.com/bigcartel/dugway/issues/new) and we'll do our best to fix it up. Thanks.

## Install

Dugway is Ruby gem so you'll need to have Ruby installed. Ruby is usually pre-installed on Mac OS X and Linux, and Windows users can install it using [RubyInstaller]. From there, simply install the **dugway** gem from the terminal:

    gem install dugway

## Creating a new theme

With Dugway installed, you can now create a new theme, simply give it a name:

    dugway create mytheme

This will create a new directory named *mytheme* that contains a few configuration files and a starter theme to get you going.

## Developing your theme

All of the assets and source code for your theme belongs in the **source** directory. Here's how it breaks down:

### HTML

Develop the HTML for your theme using our [Theme API](http://help.bigcartel.com/customer/portal/articles/772788-creating-a-custom-theme). Barebones versions of all of the required HTML pages for your theme are provided by default, so feel free to expand on those or replace them entirely.

### CSS

All CSS for your theme is handled by the **styles.css** file. If you don't have much CSS, or you're just a glutton for punishment, you could simply put all of your CSS in **styles.css**. However, we recommend you use [Sprockets](http://getsprockets.org).

#### Using Sprockets

We recommend you break your CSS into multiple files and put them in a separate directory. We've created a **stylesheets** directory by default that you can use, but you could delete that and put them anywhere you'd like. After that, use [Sprockets directives](https://github.com/sstephenson/sprockets#the-directive-processor) to package them into **styles.css**. Ex:

    /*
     *= require stylesheets/example_1
     *= require stylesheets/example_2
     */

This also allows you to use [Sass](http://sass-lang.com) in your separate files by appending the **.sass** or **.scss** extension after **.css**, or you can also use [LESS](http://lesscss.org) appending the **.less** extension.

#### Embedding CSS

You can embed your CSS into your theme by passing the theme variable to the [theme_css_url](http://help.bigcartel.com/customer/portal/articles/772749-filters#url) filter:

    <link href="{{ theme | theme_css_url }}" media="screen" rel="stylesheet" type="text/css">

#### JavaScript

All JavaScript for your theme is handled by the **scripts.js** file. If you don't have much JavaScript, or you're just a glutton for punishment, you could simply put all of your JavaScript in **scripts.js**. However, we recommend you use [Sprockets](http://getsprockets.org).

#### Using Sprockets

We recommend you break your JavaScript into multiple files and put them in a separate directory. We've created a **javascripts** directory by default that you can use, but you could delete that and put them anywhere you'd like. After that, use [Sprockets directives](https://github.com/sstephenson/sprockets#the-directive-processor) to package them into **scripts.js**. Ex:

    //= require javascripts/example_1
    //= require javascripts/example_2

This also allows you to use [CoffeeScript](http://coffeescript.org) in your separate files by appending the **.coffee** extension after **.js**.

#### Embedding JavaScript

You can embed your JavaScript into your theme by passing the theme variable to the [theme_js_url](http://help.bigcartel.com/customer/portal/articles/772749-filters#url) filter:

    <script src="{{ theme | theme_js_url }}" type="text/javascript"></script>

### Images

All images for your theme should go in the **images** directory. You can reference an image in your code by passing its name to the [theme_image_url](http://help.bigcartel.com/customer/portal/articles/772749-filters#url) filter:

    {{ 'sample.png' | theme_image_url }}

### Settings

Set your theme's name, version, and customizable options in the **settings.json** file. We'll be documenting more about this soon, but for now see the starter file generated for you.

## Running your theme

Run your theme in any browser by starting the Dugway server:

    dugway server

By default this will serve your theme at http://0.0.0.0:9292. You can then stop the server by hitting CTRL+C.

#### Pow

Tired of all the manual starting and stopping? Good news, Dugway is built on top of Rack, which means you can use [Pow](http://pow.cx) on Mac. This also allows you to access your theme at a pretty URL like _mytheme.dev_.

## Building your theme

When you're finished with a new version of your theme, it's time to build it:

    dugway build

This will create a zip file for the current version in your **builds** directory containing all HTML, images, and packaged JS and CSS.
