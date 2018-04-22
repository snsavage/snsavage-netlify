---
title: Creating Photo Vistas with Sinatra
date: 2016-12-20 17:06 UTC
author: Scott Savage
tags:
  - flatiron school
  - unsplash
  - learn.co
  - photo vistas
published: true
---

[Photo Vistas](https://photovistas.com) provides customized browser homepages using photos from [Unsplash](http://unsplash.com).  The app enables users to link their Unsplash account and add Unsplash photos they've liked or added to collections to their Photo Vistas queue.  Homepage photos are rotated daily.  

Photo Vistas uses the Sinatra web development domain specific language (DSL).  The project was created for the [Flatiron School's Online Web Developer Program](https://flatironschool.com/programs/online-web-developer-career-course/).  Here is an overview of the process for creating the web app.     

READMORE

![](../images/pv-homepage.png)

## Introduction

When I started this project I had a simple goal in mind.  I wanted a replacement for Chrome browser plugins such as [Momentum](https://momentumdash.com) or [Unsplash Instant](https://instant.unsplash.com).  I've used Momentum in the past, but I couldn't stand how quickly Chrome drains my laptop's battery.  So I found myself using Safari again and missing those daily photos.

With Photo Vistas I wanted to create a version of those products that didn't require a plugin and therefore could be used with any browser [^1].  Instead of a plugin, the web app would provide each user with a custom homepage url to access their queue.  The site would only need a few pages such as a sign up, log in and settings page, in addition to the custom homepage.    

Given that the scope of the project was fairly limited, I determined that it fit well into the project requirements for my Flatiron School Sinatra Portfolio Project.  Of course, as these things go, simple projects with limited scope do not always translate to easy or quick projects.  As with any good project, I pushed the boundaries of my knowledge and quickly came to a good understanding of the benefits and limitations of the Sinatra DSL.

## The Quantified Project
Since starting the program at the Flatiron School, I've been tracking my time with [Harvest](http://harvestapp.com).  Time tracking has been helpful both as a motivational tool and as a way of tracking my progress toward the program's 600 to 800 hours for completion..  I've been working on the program for just over 500 hours.  About 100 of those hours have been for ancillary projects, such as building [snsavage.com](http://snsavage.com) and the talk that I gave about creating [Static Sites with Middleman](https://www.snsavage.com/blog/2016/cpsoc_2016_static_sites_with_middleman.html). 

So what about Photo Vistas?  Here are the stats.

* Time Spent - 125+ Hours
* Lines of Code - 317+ Lines of Ruby (Does not include HTML and CSS)
* Test - 100 Specs in RSpec
* Code Coverage - 91%
* Git Commits - 128 Commits

What a project!!!  Never did I think that the Photo Vistas project would take so long.  One thing that I definitely don't have a sense for yet is how to estimate time frames for these projects.  But I certainly learned a lot and I'm extremely proud of the project that I completed.  Here are some of the highlights.

## Sinatra vs. Rails
Back in grad school I built a project called [QuestionFair.com](http://questionfair.com) using Ruby on Rails.  Whereas "Rails has everything you need" [^2], Sinatra includes just the basics.  At first, I found this approach to web development very refreshing.  Sinatra is much easier to understand from end-to-end and its simplicity makes getting started easy.  

However, I quickly began to miss many of the features included out of the box with Rails.  For instance, for any Sinatra web app requiring one then one controller sharing an environment and site wide configurations become important.  For this project I used the convention of creating an ```config/environment.rb``` file for my environment setup.  

```ruby
ENV['RACK_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

Dotenv.load if ENV['RACK_ENV'] != "production"

require_rel "../app/"
require_rel "../lib/"
```

Using an ```environment.rb``` such as this is helpful for defining all of the required site wide environment settings in one place.  This one helps with setting the ```RACK_ENV```, starting ```bundler``` for gem requirements, managing environment variables in development, and requiring all of the files for the app.  

A database and ActiveRecord configuration is notably missing from ```environment.eb```.  Photo Vistas is hosted with Heroku, uses PostgreSQL for the database and ActiveRecord for the ORM.  Getting this combination working took some trial and error, but in the end using the ```sinatra-activerecord``` gem greatly simplified the process.  When supplied with a ```config/database.yml``` file the gem handles the setup required to get everything working.  Adding the correct setup in ```database.yml``` was the only configuration required.  

Another setup related problem that I found with Sinatra involves site wide configurations that are defined within your controller class.  Photo Vistas is a 'modular' style Sinatra app and therefore has several different controllers.  But it's not exactly clear how to set configurations to work across all controllers.  The solution that I used is to set one primary controller, in this case ```ApplicationController``` to inherit from ```Sinatra::Base``` while then having any other controllers inherit from ```ApplicationController```.  

Here is the start of ```app/controllers/application_controller.rb```:

```ruby
require 'sinatra/base'
require 'sinatra/asset_pipeline'

class ApplicationController < Sinatra::Base
  set :assets_paths, %w(./../assets/stylesheets ./../assets/images)
  set :assets_precompile, %w(app.js app.css bookmark.css clear.css *.png *.jpg *.svg *.eot *.ttf *.woff *.woff2)

  register Sinatra::AssetPipeline

  helpers SessionHelpers
  helpers UnsplashHelper
...
``` 

```app/controllers/users_controller.rb``` then inherits from ```ApplicationControlller```:

```ruby
require_relative 'application_controller'

class UsersController < ApplicationController
  get '/bookmark/default' do
    redirect to "/" if !logged_in?

    @photo = User.default.current_photo

    erb :'/users/bookmark', locals: {bookmark: true}
  end
...
``` 

Using this setup, all of the settings defined in ```ApplicationController``` are set in the other controllers.

Web asset management is another area where I missed Rails.  In Rails the Asset Pipeline automatically performs tasks such as compiling SASS and CoffeeScript files, minifying CSS and JavaScript files, and fingerprinting assets for cache invalidation.  Sinatra on the other hand doesn't have a built in asset pipeline.  

Fortunately, there are gems available to fill this gap.  Sprockets, the library used by Rails for web assets, is available as a stand alone gem.  Sprockets on it's own will handle compiling assets, but it doesn't come with built in asset helpers (used for linking to assets) or with the required Rake task to build assets on Heroku when an app is deployed.

Again, fortunately, there are gems to fill this gap.  Adding the ```sprockets-helpers``` provided a Sinatra implementation of the asset helpers that Rails provides and adding the ```sinatra-asset-pipeline``` gem rounded out the asset pipeline functionality by managing tasks like precompiling the assets.  

I've heard it said before that when you're using Sinatra you end up rebuilding Rails.  I definitely had this experience.  Having used Rails before, when I needed something that Sinatra doesn't provide, I wanted to turn to the same tools that I found familiar from Rails.  

With the Photo Vistas project, I felt like I was recreating Rails.  And this was frustrating.  Instead of building features for my app, I was wasting time bolting new functionality into Sinatra.  This feeling was partially compounded by the fact that I've never build a project in Sinatra before, so the next time around I'll have a better understanding of what is needed and how to get everything working correctly the first time.  

Having said all that, this limitation wouldn't prevent me from using Sinatra again.  For a simple project, or a project that isn't view heavy, Sinatra offers a lot of benefits.  And I certainly enjoyed many aspects of working with the framework.   

## Unsplash API
One of the major obstacles encountered while build Photo Vistas was working with the Unsplash API.  This project was my first time working with an API, and accordingly a lot effort was spent just figuring out what was going on.  Unsplash has an official [Ruby wrapper for the Unsplash API](https://github.com/unsplash/unsplash_rb) which was very helpful in putting the project together.  

The obstacle that I encountered was just being able to authenticate an Unsplash user's account.  Photo Vistas enables a user to 'link' their Photo Vistas account with Unsplash in order to access photos that they've liked or collected at Unsplash.com and then add these photos to their Photo Vistas queue.  

This authorization takes several steps.  First, a user is sent to an Unsplash authorization url where they can authorize Photo Vistas to access their account.  Second, after authorization, Unsplash will redirect the user to a Photo Vistas callback route with an authorization code.  Finally, the authorization code must be sent back to Unsplash which then provides an authorization token.  The token is what gives Photo Vistas permission in the future to access that user's Unsplash account information.  

The problem I encountered was that the Unsplash API wrapper didn't provide a method for saving the token for future use.  Therefore, without a persisted token, the user would need to re-authenticate on every request.  

To solve this problem I forked the Unsplash API Ruby wrapper and added two methods to the Unsplash::Connection class, one method to extract the token information and another method to add the token into the API wrapper on future request.  These methods allow Photo Vistas to persist the user's token in the database and then reauthorize on future requests.  The changes to the API wrapper where then submitted back to Unsplash as a [pull request](https://github.com/unsplash/unsplash_rb/pull/29).  

## Testing with RSpec
As with my Ruby gem project, [RetroCasts](https://github.com/snsavage/retro_casts), I wanted to built this project with Test Driven Development (TDD).  This process went better then expected.  There were only two places where writing tests was difficult, Sinatra helpers and the Unsplash authorization process.  The first was difficult because you don't have a direct way to access there helpers when testing.  The second was difficult because of the manual intervention needed authorize Photo Vistas with Unsplash.    

The rest of the testing process went well.  Feature tests were written with Capybara to cover the 'happy path' for the features and then controller test were written with Rack::Test to cover various scenarios for each route.  These controller test where then helpful when it came time to refactor the routes with more complex logic, like the ```get '/settings/?:username?'``` route that needed to load information about the user's queue, Unsplash photos, and Photo Vistas account information.  

## Bourbon, Neat, Bitters, & Refills
For the design of the site I turned to the [Bourbon.io](http://bourbon.io) Sass tool set.  I've used Twitter's Bootstrap in the past and wanted to try something that was more light weight.  The Bourdon.io tool set includes four different tools.  Bourbon is a Sass mixin library.  Neat is a grid system.  Bitters is a scaffold (think very light framework) to be used with Bourbon.  And Refills provides components and patterns to be used with Bourdon and Neat. 

Overall I found the tools to be helpful.  I feel like my css asset files are much smaller than if I had used Bootstrap.  The Neat grid system was very helpful in particular because you use Sass mixins instead of classes to add you HTML into the grid.  This removed a lot of clutter from my CSS files.  

I also used several of the Refills components and one of the Refills type systems.  The Type system worked well, but I had mixed results with the components.  In the end I reused code from one of my other projects for elements such as the navigation bar and footer.  

## Conclusion
I'm very happy with how this project turned out.  At the beginning I wanted to build a project that I would use everyday.  I wanted the end result to be as production ready as possible and hopeful a tool that other people would use too.   

There are certainly areas for improvement.  For instance when a user adds photos from Unsplash to their Photo Vistas queue, that process takes a considerable amount of time on the backend.  At some point this process should be moved into a background process.  Similarly on the settings page, the list of a users liked photos and photo collections should be handled on the front-end with JavaScript to allow the web app server to response faster.

*The code for this project can be found on [GitHub](https://github.com/snsavage/photovistas).*

[^1]: Turns out that this didn't work out as I expected.  Normally I use Safari which lets you customize what happens when you open new windows and new tabs.  However, much to my disappointment, both Chrome and Firefox don't let the user choose what page opens when they open a new tab.  Plugins are available for both browsers, but in some ways this lessens the usefulness of the Photo Vistas project.  However, if you want to view photos in your new browser tabs and your want to be able to customize your queue, then Photo Vistas is a great choice.    

[^2]: [Ruby on Rails: Rails has everything you need](http://rubyonrails.org/everything-you-need/)



