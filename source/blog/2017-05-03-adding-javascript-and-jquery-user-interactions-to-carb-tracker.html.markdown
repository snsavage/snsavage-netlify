---
title: Adding JavaScript and jQuery User Interactions to Carb Tracker
date: 2017-05-03 19:18 UTC
author: Scott Savage
tags:
  - flatiron school
  - learn.co
  - carb tracker
---

[Carb Tracker](https://carbtracker.herokuapp.com) was originally created as my Ruby on Rails project for the [Flatiron School's Online Web Developer Program](https://flatironschool.com/programs/online-web-developer-career-course/).  Following the Ruby on Rails coursework, the program continues with JavaScript, jQuery, and working with Rails APIs.  The JavaScript material culminates with updating your Ruby on Rails project with some JavaScript and jQuery.  The following is some information about the my JavaScript based updates to Carb Tracker.

More information the original Carb Tracker project can be found [here](https://www.snsavage.com/blog/2017/creatingcarbtrackerwithrubyonrails.html).

READMORE

![](carb-tracker-homepage.png)

## JavaScript Versions

One of the first challenges I noticed was dealing with different JavaScript versions.  Early on my RSpec tests with JavaScript enabled began to fail even though the underlying Ruby on Rails code had not changed.  After some investigation I found that the JavaScript driver I was using, `poltergiest`, doesn't support ES6 features.  

I looked at some options for integrating ES6 into the project, but in the end decided to skip ES6 and instead focused on JavaScript's older syntax and jQuery.  One significant driver of this choice was to get a more clear understanding of what JavaScript features fall into each category of standard JavaScript syntax, jQuery, and ES6.  While, the Online Web Developer program teaches pieces of all three, the distinctions were not always clear.  (I should note, I know that jQuery is not part of the JavaScript language, but I'm including it in this discussion because I wanted to have a clear understanding of how and when jQuery was useful in the context of the different JavaScript versions).

Now that the project is complete, I'm happy with that decision.  I'm sure that avoiding additional precompilers saved me some headaches and I feel like I was able to get a much better understanding of jQuery.  Additionally, the next (and final!) section of the project is React so at that point I'll be able to get a better understanding of the features and benefits of ES6.

## Active Model Serializers

The second major problem I encountered was handling JSON requests in my Rails controllers.  In particular, how to manage the data being sent in the JSON responses.  As we learned in the curriculum, I turned to the `active_model_serializers` gem.

I had mixed results with this gem.  It certainly works well for the most basic use cases, but I immediately ran into a few issues.  One I was able to solve well, the other I'm still not happy with.  

app/controllers/foods_controller.rb

```ruby
def search
...
  serializer = ActiveModelSerializers::SerializableResource
  foods_for_select = policy_scope(Food).order(unique_name: :asc)
  
  render json: {
	 foods: serializer.new(foods).as_json,
	 select: serializer.new(foods_for_select).as_json
  }, status: 200
end
```

Above is the code that I'm not happy with.  One of the AJAX use cases I had was to handle the food search on my recipes form.  The response needed to include both foods found by the search and the foods available to the user to be rendered in the foods select list on the form.  Creating a new hash on the fly to be rendered as JSON was the best way I found to combine these two datasets.  

app/serializers/log_serializer.rb

```ruby
class LogSerializer < ActiveModel::Serializer
  attributes :id,
             :user_id,
             :log_date,
             :per_recipe_stats,
             :total_stats,
             :next,
             :prev

  def next
    @object.next(@instance_options[:user])
  end

  def prev
    @object.prev(@instance_options[:user])
  end
end
```

The other roadblock I found with Active Model Serializers was how to handle including data from instance methods in the JSON response.  The above shows my solution.  By including ```#next``` and ```#prev``` wrapper methods in the serializers class, I was able to access the ```@object``` instance variable which references the object calling the serializer.

app/controllers/logs_controller.rb

```ruby
respond_to do |format|
  format.html { render :show }
  format.json { render json: @log, user: current_user }
end
```

I also needed to access ```current_user``` and I could do this by passing in the user when I called the serializer.  This argument was then made available through `@instance_options`.  I was happy with this solution since all of the serialization logic was handled in the serializer.  

*(As I'm writing this I realized a better way to handle the first situation, so a future refactoring is in order!  I can pass the ```foods_for_select``` into ```FoodSerializer``` and then expose that data by adding a method to the serializer.)* 

## Handlebars

Having followed the Rails MVC and separation of concerns conventions I wanted to keep those same conventions as much as possible for my front-end code.  Early on I realized that I would need some way to keep HTML out of my JavaScript.  I enjoyed working with [Handlebars](http://handlebarsjs.com) in the curriculum so I added Handlebars templates to my project using the [handlebars_assets](https://github.com/leshill/handlebars_assets) gem.

Using the `handlebars_assets` gem makes adding templates to a Rails project easy.  Just add your templates to the `app/assets/javascript/templates` folder with the `*hbs` extension.  Subfolders are allowed.  

In the end this was my directory structure:

```bash
app/assets/javascripts/templates/
├── flashes.hbs
├── foods
│   ├── foods_search_flash.hbs
│   └── index.hbs
├── logs
│   ├── history.hbs
│   └── stats.hbs
└── recipes
    ├── foods_select.hbs
    └── ingredient_fields.hbs
```

The templates don't need any additional syntax besides HTML and Handlebars.  Below is an example of one of my templates.  

app/assets/javascripts/templates/foods/index.hbs  

```handlebars
{{#each this}}
<div class="food">
  <a href="{{ showLink }}">{{ name }}</a>
</div>
{{/each}}
```
Accessing the template is simple too.  In your JavaScript the templates are accessed with `HandlebarsTemplates['subfolder/template-name']`.  Then the context, in this case `data`, can be passed into the template.

app/assets/javascripts/foods.js

```javascript
var template = HandlebarsTemplates['foods/index'];
$('#food-index').html(template(FoodHelpers.parse(data)));
```

Besides keeping HTML out of my JavaScript, Handlebars had two other benefits.  The first is shown in the example above.  Handlebars has several helpers to user inside the templates.  The example above shows how the `#each` helper is used to iterate through an array of data.

app/assets/javascripts/handlebars_helpers.js

```javascript
Handlebars.registerHelper('num', function(number) {
  return number.toFixed(1).toLocaleString();
});
```

Second, custom helpers can be created to handle project specific tasks.  I created several helpers, include the `num` helper shown above to help with the views created with the templates.  The `num` helper simply converts numbers to display with one decimal place.  Helpers can be used by calling them inside the Handlebars brackets.  For example: `<td class='data'>{{num calories}}</td>`.

## Testing

While working on my Ruby based projects, I've tried to use Test Driven Development (TDD) has much as possible.  However, I've learned that TDD only really works if you have some idea about how to approach the problem that you're trying to solve.  

This project was my first JavaScript based project, except for the labs in the curriculum.  So I manually tested as I went.  However, as I was wrapping up the project, I decided to try some testing of my finished JavaScript.  

One reason to test was that my code was a mess!  Because I was just figuring things out, I hadn't followed any type of organization, so I ended up with deeply nested callbacks, duplicate code, and unneeded variables.  I figured that my JavaScript test would help to reorganize my code.  

I chose [Jasmine](https://jasmine.github.io) because it had been used in a few of the labs, I like it RSpec like syntax, and I found the in browser test runner to be helpful.  Testing JavaScript in a Rails project is also demonstrated in [Rails 4 Test Prescriptions](https://www.amazon.com/Rails-Test-Prescriptions-Healthy-Codebase/dp/1941222196).  This provided a helpful guide to point me in the right direction.  

For setting up Jasmine, I used the [jasmine-rails](https://github.com/searls/jasmine-rails) gem, but I ran into some problems during the install process.  I was still able to use Jasmine, but I still seem to have some remaining issues from the initial bad install (for example, the command-line test runner doesn't work).  

Based on suggestions in Rails 4 Test Prescriptions, I also added the [jasmine-fixture](https://github.com/searls/jasmine-fixture) and [Sinon.js](http://sinonjs.org) libraries, to help with HTML fixtures and AJAX request, respectively.  I also added the [jasmine-jquery](https://github.com/velesin/jasmine-jquery) library for some jQuery specific matchers. 

### Unit Tests

spec/javascripts/foods_spec.js

```javascript
	...
  describe("FoodHelpers", function() {
    describe("rand", function() {
      it("creates a 10 digit random number", function() {
        expect(FoodHelpers.rand().toString().length).toBe(10);
        expect(typeof(FoodHelpers.rand())).toBe("number");
      });
    });

    describe("parse", function() {
      beforeEach(function() {
        data = [{
          "id": 90,
          "unique_name": "Apple - 1.0 - Medium (3\" Dia)"
        }, {
          "id": 91,
          "unique_name": "Banana - 1.0 - Medium (7\" To 7 7/8\" Long)"
        }, {
          "id": 110,
          "unique_name": "Blueberries - 2.0 - Cups"
        }];

        parsedData = FoodHelpers.parse(data);
      });

      it("returns an Array", function() {
        expect(parsedData instanceof Array).toBe(true);
      });

      it("returns an array of Food instances", function() {
        expect(parsedData[0] instanceof Food).toBe(true);
      });

      it("parses all foods in json data", function() {
        expect(parsedData.length).toBe(3);
      });
    });
  });
  ...
```

Unit testing went well.  The biggest result provided by the test was to move all of my "helper" functions that had been scattered throughout my JavaScript into `FoodHelpers` and `LogHelpers` objects.  These function were primarily for simple tasks and could be easily unit tested.  This kept them out of my jQuery AJAX related callbacks and organized them into a single place for reuse.  An example of the tests is above and an example of the helper object is below.  

app/assets/javascripts/foods.js

```javascript
var FoodHelpers = {
  rand: function() {
    return Math.floor(Math.random() * 9000000000) + 1000000000;
  },

  parse: function(data) {
    return $.map(data, function(element) {
      return new Food(element);
    });
  },

  parseWithSelect: function(data) {
    return {foods: FoodHelpers.parse(data.foods), select: data.select};
  }
}
```
### Event and AJAX Testing

While the unit tests went well, testing 'click' events and AJAX requests caused some problems.  This is definitely an area for future exploration.

When the Jasmine tests run, they don't load any HTML from your site.  They are completely independent of your existing site and only load your JavaScript files (stylesheets are added too).  

This is where the jasmine-fixtures library comes in.  jasmine-fixtures provides an `affix` method that adds elements to your DOM with jQuery selectors.  

spec/javascripts/foods_spec.js

```javascript
beforeEach(function() {
  links = affix('p');
  links.affix('a.foods-sort[href="/foods?sort=asc"]');
  links.affix('a.foods-sort[href="/foods?sort=desc"]');
  foods = affix('div#foods-index');
  ...
```
For example, as shown above, I used `affix` to add to links to my page as children of a `<p>` and then I added a `<div>` with `id="foods-index`.  This add just enough HTML for my jQuery powered events to attach and be called.  However, this didn't work.

As it turns out, `affix` seems to add those elements to the DOM after the page has been loaded.  So if your event as registered inside of a `$(function () { ... } );`, then the DOM created by `affix` won't be available and the events aren't registered.  

The way to solve this is to wrap `$()` call inside of something like `window.init = function () { ...your code here ... }` and then call `init();` in your JavaScript.  In your tests, `init();` can be called after your fixtures are setup with `affix`.  This [video](http://searls.testdouble.com/posts/2013-03-21-jasmine-tactics-screencast.html), recorded by [Justin Searls](https://github.com/searls) does an excellent job of explaining how to approach these tests.  

I also ran into a bunch of problems trying to use Sinon.js's fake `XMLHttpRequest` implementation.  While I was able to have some success, I know that I don't understand the details, so as I said, figuring all of this out will require some further exploration.

## Conclusion

When I first learned Ruby on Rails in grad school back in 2015, I avoided JavaScript at all costs.  At that point I was already overwhelmed by Ruby and Ruby on Rails, and I didn't have the time to learn another web development discipline. 

Since then I've been pushing off learning any JavaScript while at the same time letting its reputation as a difficult language sink into my head.  

But, now that I have some experience with the language I've found it to be enjoyable.  JavaScript is certainly a unique and somethings challenging language, but knowing JavaScript opens up a whole other world of possibilities that had previously been closed.  So at this point I'm feeling confident that I can be productive in the language and that I now have the skills to use JavaScript to improve the user experiences on my website projects.    
