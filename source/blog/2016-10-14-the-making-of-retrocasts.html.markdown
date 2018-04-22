---
title: The Making of RetroCasts
date: 2016-10-14 19:33 UTC
author: Scott Savage
tags:
  - flatiron school
  - learn.co
  - retrocasts
published: true

---

RetroCasts provides a command line utility (cli) for quickly accessing episode data from RailsCasts.com.  It provides a quick and convenient way to search the site without leaving the terminal.  This post discusses the process for making the RetroCasts gem.

The first major project for the Flatiron School's Online Web Developer program is the "CLI Data Gem Project."  So far the program has had several other larger projects, but this is the first project where a test suite is not provided as a framework.

READMORE

```
 _____      _              _____          _
|  __ \    | |            / ____|        | |
| |__) |___| |_ _ __ ___ | |     __ _ ___| |_ ___
|  _  // _ \ __| '__/ _ \| |    / _` / __| __/ __|
| | \ \  __/ |_| | | (_) | |___| (_| \__ \ |_\__ \
|_|  \_\___|\__|_|  \___/ \_____\__,_|___/\__|___/
Welcome to RetroCasts!
##################################################
1. Foundation - Jun 16, 2013
2. Form Objects - Jun 3, 2013
3. Model Caching (revised) - May 13, 2013
4. Upgrading to Rails 4 - May 6, 2013
5. Batch API Requests - Apr 27, 2013
6. Handling Exceptions (revised) - Apr 20, 2013
7. Fast Tests - Apr 10, 2013
8. Fast Rails Commands - Apr 4, 2013
9. Performance Testing - Mar 27, 2013
10. Eager Loading (revised) - Mar 20, 2013
Please select an option...
Episodes: 1 to 10  | home | search {search terms} | next | back | exit
>
```

Since previous projects were largely test driven, the structure of the code was mostly already determined.  The real challenge of the RetroCasts project is how to structure the code into modules and classes, and determining how those objects should interact.

The project requires the development of a Ruby program that will scrape a website or pull data from a public api, and then present that information through a cli to the user.  Optionally the project could be created as a gem to be hosted on RubyGems.  

When I read the requirements for the project two things came to mind.  First, if I'm going to be creating a gem, it should be something that I would find useful, and perhaps other would people too.  Second, it should be built as test driven as possible. 

As mentioned, all of the labs at Learn.co are test driven in the sense that each lab has a series of pre-written tests and the students are responsible for writing code that passes the tests.  We gain familiarity with TDD by understanding the test suite output and by reading the tests for better understanding.  However, we are not writing the tests.  

I had completed a Ruby on Rails app in grad school called QuestionFair.com [[Website](http://questionfair.com)] [[GitHub](https://github.com/snsavage/QuestionFair)].  For that project, I had tried to use TDD, but I was so new to web development I hardly knew where to begin.  Dealing with the added complexity of Rails and my limited knowledge of Ruby, I quickly abandoned TDD.  However, I learned a lesson from the project.  Tests are important!!!  As the project grew in complexity, manually testing became increasingly more difficult.  

Since RSpec is so widely used in the Ruby on Rails community and is also the test suite used in the Learn.co labs, I chose RSpec for my testing framework.  I chose RailsCasts.com as the site to scrape.  RailsCasts is a great resource, even though the newest episode is from 2013.  It was invaluable while I was working on QuestionFair and I still continue to reference the material when I want to see a quick overview on a topic.  

## Creating a Project Skeleton
Since I wanted to create a Ruby gem from this project, a few things needed to be setup to create a gem skeleton.  Fortunately, Bundler has the ```bundler gem``` command.  This worked out really well by providing all of the files and folders required to build a gem.  You can find the docs [here](http://bundler.io/v1.13/man/bundle-gem.1.html).

```bundle gem``` also provides a number of helpful utilities.  For instance, the ```bin/console``` script launches ```irb``` or ```pry``` with the project's code preloaded.  Also, two ```rake``` commands are provided, ```build``` and ```install```, that will build and install the gem on your local machine.  The framework also sets up the test suite and provides a ```.gemspec``` template.

Here is the file structure provided by ```bundle gem``` at the start of the RetroCasts project. 

```
$ tree
.
├── CODE_OF_CONDUCT.md
├── Gemfile
├── Gemfile.lock
├── LICENSE.txt
├── README.md
├── Rakefile
├── bin
│   ├── console
│   └── setup
├── coverage
├── lib
│   ├── retro_casts
│   │   └── version.rb
│   └── retro_casts.rb
├── pkg
│   └── retro_casts-0.1.0.gem
├── retro_casts.gemspec
└── spec
    ├── retro_casts_spec.rb
    └── spec_helper.rb
```

## Committing to Good Commit Messages
One area that I've neglected until now was understanding what makes a good Git commit message.  Prior to this project I had always just used the ```git commit -am {commit message}``` shortcut without much thought to how the message should be structured.  After a little research I found an excellent blog post by [Chris Beams](https://twitter.com/cbeams) on [How to Write a Git Commit Message](http://chris.beams.io/posts/git-commit/).  

I think the best tip he provides is to write commit messages as if you were completing the sentence, "If applied, this commit will...".  This single tip has gone a long way to improving my messages.  Additionally, the post has great advice on how to format messages.  

I hadn't realized in the past, although I had heard people discuss it, that commit messages could be multiple lines long.  I had only ever used the ```-m``` flag for writing a message at the command prompt.  As it turns out, something was wrong with my Git and Bash setup that prevented the commit message from opening properly in my text editor.  Instead I would just get a blank Vim buffer.  Getting this problem fixed opened up an entirely new world of Git!

Here is a sample of my nicely formatted commit messages...

```
commit a9a3cbc49312dd3ec480b08a14402746a87f2765
Author: Scott Savage <snsavage@gmail.com>
Commit: Scott Savage <snsavage@gmail.com>

    Move CLI display methods to RailsCasts

    These methods were moved with the idea that RailsCasts should know how
    to print episodes to the screen.  This will allow for additional sources
    to be added in the future.

commit 91e1508b5dd6d5890a725a470acd7ebb77fdbf16
Author: Scott Savage <snsavage@gmail.com>
Commit: Scott Savage <snsavage@gmail.com>

    Add site caching

    Prior to this commit, each website page load was completely on demand.
    For instance, starting the program, going to the next page, and then
    going back a page required 3 requests to railcasts.com.  This was
    somewhat slow and inefficient.

    Since, RailsCasts creates new instances each time new episodes are
    requested, a cache could not be stored in that class.  Because, the
    Website class already acts as a wrapper for website requests, it seems
    like the best place to also handle caching webpages for future use.
```

## Testing with RSpec

As noted earlier, I've tried TDD in the past, but didn't have much success with the process.  I figured that trying TDD on a project that was only Ruby would greatly simplify the process.  

As a refresher on RSpec and how to approach testing a Ruby CLI project, I watched [Xavier Shay's](https://twitter.com/xshay) Pluralsight course [Testing Ruby Applications with RSpec](https://www.pluralsight.com/courses/rspec-ruby-application-testing).  

This video is listed on the [rspec.info](http://rspec.info) website and is an excellent resource.  It moves a little fast at times, but it really helped me to clarify some of my thinking about testing.  

For instance, just understanding how to use Spec's ```describe```, ```context```, and ```it``` blocks was helpful.  As shown in the example below, I used the convention of ```describe``` to indicate the class or method, ```context``` to differentiate between the circumstances of the test, and ```it``` describe the expected result.  This helped a lot with organizing the project's specs, as well as thinking through which specs should be written.  

```ruby
describe RetroCasts::RailsCasts, vcr: vcr_default do
...
  describe '#new' do
    context 'with a valid host' do
      it 'accepts two arguments' do
        expect(klass).to respond_to(:new).with(4).arguments
        site
      end
    end
  end
end      
```

As of writing this post, the project has 75% test coverage.  The biggest gap is in the code that controls the user-facing cli.  This code remains untested because manually testing the code was straightforward and due to time constraints with the project.  Unsurprisingly, this section of code is also the least organized. 

One problem that I had early on with testing was a slow test suite caused by the number of HTTP request made to the RailsCasts website.  To fix this problem, I added [VCR](https://github.com/vcr/vcr) gem.  VCR records HTTP calls from the test suite and then plays back those recordings each time the test suite runs.  Essentially, the gem saves a copy of the webpage and then it intercepts the HTTP calls by responding with the saved page.  This trick greatly improved the test suite speed.   

Overall, I'm happy with the TDD approach.  Having the tests definitely helped me think through each problem the code is solving.  Additionally, it's a very efficient way to interact with your code, as opposed to manually testing everything in a Ruby console.       

## Code Structure

One of the biggest challenges faced during the RetroCasts project, was how to best structure the code.  Even though I was primarily writing tests first, I quickly found that I needed to be thinking a little bit further ahead about how my code should interact.  On a number of occasions code was moved from one class to another or modules were turned into classes. 

I was also trying to work with some thought toward future expansion of the project.  In particular, how I could easily add additional data sources.  This idea influenced many of my design choices.   

The ```Website``` class acts as a wrapper for calls http requests and calls Nokogiri.  These were two areas of the code that required some basic error handling.  A basic Null Object pattern was used with ```NullWebsite``` to help in other areas of the code when something goes wrong with the ```Website``` class.  

The ```Website``` class also handles caching requested pages.  This way a second call to the same RailsCasts page will pull from the cache instead of making an HTTP request.  This makes the CLI much faster, particularly for moving back and forth between pages.  This class was also created to be used with any site, so adding another source site in the future shouldn't effect this code. 

The ```RailsCasts``` class handles anything specific to the RailsCasts site.  Much of this class is specific to how the RailsCasts website is structured whether that is how episodes are shown in html and css, what data should be included with an episode, or how search and pagination urls are structured.  In the future some parts of this class would be extracted into a super class that could be used with another data source.

One choice with the ```RailsCasts``` class was how to handle changes of state in a class instance when requesting a new page from RailCasts.com.  These updates occur with searching and changing pages.  Instead of changing all of the internal instance variables I chose to instead return a new instance of the class.  

For instance, as shown below, the ```#get_search``` method in ```RailsCasts``` simply creates a new class instance by calling ```#new``` with different parameters.  I chose this method because ```#new``` was already setup to handle processing a search request.  This method simplified the overall code for the class, but in the future I might change this to a more traditional object-oriented approach.  

```ruby
def get_search(search_term)
  self.class.new(search: search_term, website: website)
end
```

## Going Forward
Overall I'm happy with RetroCasts.  The cli does a great job of providing a quick method for searching the RailCasts website through the command line.  

There are a few areas for improvement.  First, the cli code should be tested and divided into separate methods.  Second, the overall testing should be double checked for missing or uneeded tests.  Finally, I would like to update the cli to handle multiple sources.  Any suggestions for other sources would be greatly appreciated!

*This is a blog post for the Flatiron School's Online Web Developer program.  You can find more information here: [learn.co/with/snavage](http://learn.co/with/snavage).*
   
