---
title: Middleman Blog with GitHub Pages
author: Scott Savage
date: 2016-02-04 02:40 UTC
tags: middleman, github, github pages, tutorial
published: true
---

![Press - Image from Unsplash](https://source.unsplash.com/BVyNlchWqzs/600x400 "Press - Image from Unsplash") 

Middleman is a static site generation framework with an available blog extension package.  I've tried to set up a blog with Middleman in the past, but I've always had trouble with deploying to GitHub pages.  To me it's not as straight forward as it could be, but I think with a few tips it can easily be done.  Here are the steps that worked for me.  

READMORE

Start off by creating a new Middleman Blog, change into the new directory and initialize a new git repo.  

```shell
$ middleman init snsavage.github.io --template=blog
$ cd snsavage.github.io/
$ git init
```

GitHub Pages uses two different conventions depending on whether the pages are for a user, organization or a project.  User pages are created in a GitHub repo with a `username.github.io` naming scheme and are served using files on the `master` branch of that repo.  Project pages on the other hand use the `http(s)://<username>.github.io/<projectname>` naming scheme and are served from the `gh-pages` branch.  Here are the instructions for [setting up your GitHub Pages repo](https://pages.github.com "GitHub Pages") and more [detail on page types and naming conventions](https://help.github.com/articles/user-organization-and-project-pages/ "User, Organization, and Project Pages").

After you have setup your GitHub repo, don't forget to add the remote to your local repo.

```shell
$ git remote add origin https://github.com/snsavage/snsavage.github.io.git
```

Because GitHub Pages use the `master` branch for deploying your site, you'll need to create a new branch for developing your site.  Understanding how this branch structure works with GitHub Pages is extremely important.  This is what caused most of my headaches.  

Create a new branch called `development`, add the files to the repo and then commit the changes.   

```shell
$ git checkout -b development
$ git add .
$ git commit -a -m "Initial Middleman Blog Setup"
```

At this point your site should only have a `development` branch.  Nothing was committed to the original `master` branch before creating the `development` branch.  During my setup I created the `master` branch and tested adding a file to that branch.  More information on manually creating pages can be found [here](https://help.github.com/articles/creating-project-pages-manually/ "Creating Project Pages Manually").

First, create the new `master` branch as an [orphan](https://git-scm.com/docs/git-checkout/1.7.3.1 "git-checkout Manual Page") branch.  Then remove all files from that branch.  I also had to remove a directory that remained behind.  

```shell
$ git checkout --orphan master
$ git rm -rf .
$ rm -rf source
```

Second, create an index.html file, add the file to the repo, commit the file and push to `origin`.  As noted earlier, more on these steps can be found [here](https://help.github.com/articles/creating-project-pages-manually/ "Creating Project Pages Manually").

```shell
$ echo "My Page" > index.html
$ git add index.html
$ git commit -a -m "First pages commit"
$ git push origin master
```

At this point your website should be live with the sample `index.html` page.  Your web address will be `<username>.github.io`.  But now that you know that isn't working, it's time to finish setting up Middleman.  Start by removing the `index.html` file.

```shell
$ git rm index.html
```
  
Now it's time to head back to the `development` branch to finish the Middleman setup.  

```shell
$ git checkout development
```
I used the Middleman Deploy extension to handle deploying to GitHub Pages.  The following instructions can be found [here](https://github.com/middleman-contrib/middleman-deploy "Middleman Deploy").  As of this writing there is a typo in the Middleman Deploy `README.md`.  I've noted it below.     

Add to your Gemfile.

```ruby
gem 'middleman-deploy', '~> 1.0'
```

Add the following lines to your `config.rb`.

```ruby
activate :deploy do |deploy|
  deploy.method = :git  # This is shown as deploy.deploy_method in the README.
  deploy.remote = "origin"
  deploy.branch = "master"
end
```

Build and deploy your blog.

```shell
$ middleman build
$ middleman deploy
```

This is the process that worked for me.  Please let me know if you have any feedback.

