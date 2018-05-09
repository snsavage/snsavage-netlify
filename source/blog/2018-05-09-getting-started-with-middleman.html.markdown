---
title: Getting Started with Middleman
author: Scott Savage
date: '2018-05-09 19:11 UTC'
tags:
  - Middleman
  - Static Sites
  - Ruby
---


Often times when building websites, a "full stack approach" isn't always necessary.  Sometimes the content isn't dynamic, or it changes infrequently.  However, building a website completely by hand my be too tedious or time consuming.  Static site generators are tools that can help to fill the gap.

A static website, is just a website that uses static files including HTML, CSS and JavaScript, but without the backing of a web application server.  In these cases users see essentially the same thing each time a page is requested.  This isn't anything new and improvements in front-end development technology are increasingly blurring these lines.

READMORE


\## What are static site generators?

\### Tools for Programming Static Sites


^ Static site generators provide a toolchain for building static site, borrowing tools from web application frameworks, but with the end result static web pages instead of dynamic webpages.  

^ Web frameworks for static pages.

^ Growing popularity possibly a reaction to the size and complexity of web application ^ frameworks and CMSs like WordPress. 

^ WordPress powers 26% of the internet



\---



\## Why are they useful?

\### Benefits for Both Development & Deployment



\---



\## Development



\* Templating

\* Content Models

\* Asset Pipeline

\* Extensibility



^ Building pages by hand is likely to introduce all kinds of errors.

^ Programmatically building static pages.

^ Code reuse.

^ Content Models instead of a database.

^ Compile, combine, and minify JavaScript and CSS.

^ Add functionality.



\---



\## Deployment



\* Simplicity

\* Speed

\* Caching

\* Security



^ Simplicity - No CMS, web application or database to process request.

^ Speed - Without extra overheard, sites can be 6 to 10x faster.

^ Scaling easier.

^ Caching - No dynamic content to worry about, pages change infrequently.



\---



\## When to use a static site generator?

\### Depends on the Content



\---



\## What about dynamic features?



^ With front-end frameworks and tons of different apis, what you need is probably available from a third party.



^ What about the dynamic features that I need?



^ With the maturation of browsers, many features that used to require dynamic code running on a server can be moved entirely to the client. Want comments on your website? Add Disqus, Isso or Facebook comments. Want social integration? Add Twitter or Facebook’s JavaScript widget to your website. Want real-time data updating live on your website? Add a squirt of Firebase. Want search? Add Swiftype. Want to add live chat support? Olark is there. Heck, you can even add an entire store to a static website with Snipcart.



^ Apart from that, modern web apps built with Ember.js, AngularJS or React are often deployed entirely as static websites and served directly from a CDN with a pure API back end that’s shared between the website’s UI and the mobile client.



^ JAMStack - https://jamstack.org



\---



\## What are the problems?



\* Less Mature Ecosystem than a CMS Like WordPress

\* Not Designed for Non-Technical Users



^ Doesn't have the mature marketplace of themes and support services.

^ Content editing.



\---



\## Who is using static site generators?



\* Google

\* Vox Media

\* MailChimp

\* Sphero

\* GitHub

\* Carrot - Roots

\* Instrument - Middleman



^ Carrot - A full-service digital agency.

^ Intrument - We're an independent digital creative agency in Portland, Oregon. We build brands, experiences and campaigns for every screen.



\---



\## Static Site Generators

!\[inline](Images/StaticGenv2.png)



^ Too many options?

^ Jekyll & Octopuses

^ Pelican - Python

^ Roots - JS

^ Hugo - Go

^ \[Smashing Magazine - Static Website Generators Reviewed](https://www.smashingmagazine.com/2015/11/static-website-generators-jekyll-middleman-roots-hugo-review/)







\---



\# Part 2 

\# \*Middleman\*



!\[inline ](Images/Middleman.png)



\---



\## Middleman



\* Built with Ruby

\* Templating Engine - Ruby (ERb)

\* Content - Site Map Resource & Collections

\* Asset Pipeline - Sprockets or External Pipeline

\* Extending - Extensions Available



^ How I'm using Middleman.

^ Installed a Ruby Gem

^ Two versions middleman and middleman-blog



\---



\## Development Cycle



\`\``bash

	$ middleman init NEW_MIDDLEMAN_PROJECT_NAME

	OR middleman init NEW_MIDDLEMAN_BLOG_NAME --template=blog

	$ middleman server

	$ middleman console

	$ middleman build

\`\``



^ Server Pages

^ \[Middleman Local Development Server - http://localhost:4567/](http://localhost:4567/)

^ \[Middleman Configuration Options](http://localhost:4567/__middleman/config/)

^ \[Middleman Sitemap](http://localhost:4567/__middleman/sitemap/)



\---



\## Directory Structure



	mymiddlemansite/

	+-- Gemfile

	+-- Gemfile.lock

	+-- config.rb

	+-- build

	+-- data

	+-- lib

	+-- source

\    +-- images

\    ¦   +-- background.png

\    ¦   +-- middleman.png

\    +-- index.html.erb

\    +-- javascripts

\    ¦   +-- all.js

\    +-- layouts

\    ¦   +-- layout.erb

\    +-- stylesheets

\    +-- all.css

\    +-- normalize.css

\    

^ Blogging template provides a sample article, calendar, xml feed, and tag page.

^ Source - Contains files to be built.

^ Build - Compiled static site files.

^ Data - Local data in \`\`\`.yml\`\`\`, \`\`\`.yaml\`\`\`, or \`\`\`.json\`\`\` formats.

^ Lib - Ruby modules containing "helper" classes and methods.



\---



\## Templating



1. Layout & Partials

2. Ruby Mixed with HTML



^ Programmatically Generate Content

^ Code Reuse



\---



\## Ruby Code Mixed with HTML



\* ERb Enables Ruby Directly Inside HTML

\* Ruby Added Between the \`\`\`<%\`\`\` & \`\`\`%>\`\`\` Tags

\* Code Inside the \`\`\`<%= %>\`\`\` Tags Substituted Into the Document



^ Using \`\`\`<%=\`\`\` as the opening delimiter will substitute the ruby output into the document.



\---



\## Layouts & Partials



\* Layouts \`\`\`<%= yield %>\`\`\`  to the Current Page Ex. index.html

\* Partials Insert HTML Snippets Ex. \`\`\`<%= partial "nav" %>\`\`\`



\---





\## Example:

\### snsavage.com



!\[right fit](Images/snsavage with borders.png)



\---



\## \`\`\`source/layout.erb\`\`\`



\`\``erb

	<!doctype html>

	<html>

	  <head>

\    <%= partial "head" %>

	  </head>

	  <body>

\    <div id="container">

\    <header>

\    <%= partial "nav" %>

\    </header>

\    <main>

\    <div id="main" role="main">

\    <%= yield %>

\    </div>

\    ...

\    </main>

\    <footer>

\    <%= partial "footer" %>

\    </footer>

\    </div>

	  </body>

	</html>

\`\``



\---



\## \`\`\`source/partials/_nav.erb\`\`\`



\`\``erb

	<nav class="clearfix hidden-nav-menu">

	  <h1>snsavage.com</h1>

	  <h1 class="hidden-nav-trigger">

	  	<a href="#">

	  	  <i class="fa fa-bars fa-lg" aria-hidden="true"></i>

	  	</a>

	  </h1>

	  <ul class="nav-menu">

\    <%= partial "nav_links" %>

	  </ul>

	</nav>

\`\``



\---



\## \`\`\`source/partials/_nav_links.erb\`\`\`



\`\``erb

	<li><%= link_to "Home", "/" %></li>

	<li><%= link_to "About", "about.html" %></li>

	<li><%= link_to "Contact", "contact.html" %></li>

\`\``



\---



\## \`\`\`build/index.html\`\`\`



\`\``erb

  <!doctype html>

  <html>

  <head>

\    ...

  </head>

  <body>

\    <div id="container">

\    <header>

\    <nav class="clearfix hidden-nav-menu">

  			<h1>snsavage.com</h1>

  			<h1 class="hidden-nav-trigger">

  			  <a href="#"><i class="fa fa-bars fa-lg" aria-hidden="true"></i></a>

  			</h1>

  			<ul class="nav-menu">

\    			<li><a href="/">Home</a></li>

				<li><a href="/about.html">About</a></li>

				<li><a href="/contact.html">Contact</a></li>

		 	</ul>

\    </nav>

\    </header>

	   ...

\`\``

\---



\## Example:

\### snsavage.com



!\[right fit](Images/snsavage with borders.png)



\---



\## Generating Lists of Articles

\`\``erb

	<ol>

	  <% blog.articles\[0...10].each do |article| %>

\    <li>

\    <%= link_to article.title, article %> 

\    <span><%= article.date.strftime('%b %e') %></span>

\    </li>

\    <% end %>

\    </ol>

\`\``



\---



\## Titles Based on Page Content

\`\``erb

	<title>

\    snsavage.com

\    <%= ' - ' + current_article.title unless current_article.nil? %>

\    </title>

\`\``



\---



\## Middleman Content Model



\### Pages, Frontmatter, & Local Data



\---



\### Pages



\* Add a New HTML File to Add Pages



\* Adding the \`\`\`\*.erb\`\`\` Extension to Include Ruby  



\* Add a Blog Article with \`\`\`$ middleman articles ARTICLE_TITLE\`\`\`



^ HTML and Markdown files are rendered into layouts.



\---



\## Frontmatter Format



\`\``

\---

	title: Middleman Blog with GitHub Pages

	author: Scott Savage

	date: 2016-02-04 02:40 UTC

	tags: middleman, github, github pages, tutorial

	published: true

\---

\`\``



\---



\## Using Frontmatter Data



\`\``erb

	<% wrap_layout :layout do %>

	  <article>

\    <h2><%= current_page.data.title %></h2>

\    <h3><%= current_page.date.strftime('%B, %e %Y') %></h3>

\    <h4>By <%= current_page.data.author %></h4>

\    <%= yield %>

	  </article>

	<% end %>

\`\``



\---



\## Local Data



\* Stored in the \`\`\`data\`\`\` Directory

\* Files in the \`\`\`.yml\`\`\`, \`\`\`.yaml\`\`\`, or \`\`\`.json\`\`\` Formats

\* Accessed by the \`\`\`data\`\`\` Object



\---





\## Helper Methods



\### Simplify Common HTML Tasks



\* Links - \`\`\`link_to\`\`\` 

\* Tags - \`\`\`tag\`\`\`, \`\`\`content_tag\`\`\`

\* Forms - \`\`\`form_tag\`\`\`, \`\`\`label_tag\`\`\`, \`\`\`sumbit_tag\`\`\`

\* Formatting - \`\`\`pluralize\`\`\`, \`\`\`word_wrap\`\`\`, \`\`\`truncate\`\`\`



\---



\## Middleman Asset Pipeline



\* Rails Asset Pipeline (Sprockets) - v3

\* External Pipeline - v4



^ Middleman ships with support for the ERb, Haml, Sass, Scss and CoffeeScript engines. 



\---



\## Middleman Extensions



\* \`\`\`middleman-blog\`\`\` - Middleman Blogging Extension

\* \`\`\`middleman-syntax\`\`\` - Code Syntax Highlighting

\* \`\`\`contentful_middleman\`\`\` - Contentful CMS API

\* \`\`\`middleman-deploy\`\`\` - Deploy Using sync, ftp, sftp, or git

\* \`\`\`middleman-disqus\`\`\` - Integrate Disqus Into Middleman



\---



\# Part 3

\# \*Example Workflow\*



!\[inline](Images/snsavage homepage.png)



^ Evolution of my personal website.



\---



\## GitHub Pages



!\[inline](Images/GitHub Pages.png)



^ Easy to use with middleman-deploy, but the setup is a little tricky.

^ Great free solution, but managing your git repo can be a little tricky.



\---



\## Netlify



!\[inline](Images/Netlify.png)





^ Static Site Hosting

^ CDN, SSL, Continuous Deployment, Rollbacks

^ Netlify will build your site.



\---



\## What if a website has non-technical users?



\---



\## Contentful



!\[inline](Images/Contentful.png)



^ Custom CMS with API

^ Allows a non-technical user to manager content without developer input.

^ To demonstrate how this would work.

^ Important to Note! The end-user doesn't user Contentful.  The content is static.  



\---



\## \`\`\`snsavage.com/portfolio.html\`\`\`



!\[inline](Images/Portfolio.png)



\---



\## Custom Contentful CMS



!\[inline](Images/Contentful CMS.png)



^ Content Created & Managed on Contentful.com



\---



\## \`\`\`source/portfolio.html.erb\`\`\`



\`\``erb

	<div class="portfolio">

	  <% data.portfolio.project.each do |id, project| %>

\    <div class="project">

	

\    <h2><%= project\["name"] %></h2>

\    ...

\    <div class="project-description">

\    <p><%= project\["description"] %></p>

	

\    <div class="project-links">

\    <h4>Find Out More:</h4>

\    <% if project.links %>

\    <% project.links.each do |link| %>

\    <%= link_to link.name, link.url %>

\    <% end %>

\    <% end %>

\    </div>

\    </div>

\    </div>

	  <% end %>

	</div>

\`\``



\---



\## Publishing New Content



\* Clicking Publish in Contentful Calls Netlify Webhook

\* Content is Updated with \`\`\`$ middleman contentful\`\`\`



\---

\## Netlify Admin



!\[inline](Images/Netlify Admin.png)



\---



\## Resources



\* \[Middleman](https://middlemanapp.com/)

\* \[Smashing Magazine - Why Static Website Generators Are The Next Big Thing](https://www.smashingmagazine.com/2015/11/modern-static-website-generators-next-big-thing/)

\* \[Smashing Magazine - Static Website Generators Reviewed](https://www.smashingmagazine.com/2015/11/static-website-generators-jekyll-middleman-roots-hugo-review/)  

\* \[Static Webtech Meetup - Dynamic to Static](http://www.staticwebtech.com/presentations/from-dynamic-to-static/)

\* \[Netlify](https://www.netlify.com/)

\* \[Contenful](https://www.contentful.com/)

\* \[YouTube - Middleman External Pipeline + Gulp](https://www.youtube.com/watch?v=-io8EeB3GHI)



\---



\## About Me:

\* E-Mail: snsavage@gmail.com

\* Website: snsavage.com

\* GitHub: github.com/snsavage



\# !\[inline 125%](Images/FlatironSchool_logo_2014_horiz_W.png)



\* \[Flatiron School](https://flatironschool.com)

\* \[learn.co/with/snsavage](learn.co/with/snsavage)



\---



\## Questions?



^ Topics for Conversation

^ What workflow tools are you currently using?

^ Have you used any static site generators?

^ When have static site generators worked best?
