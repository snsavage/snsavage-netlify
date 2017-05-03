---
title: Adding JavaScript and jQuery User Interactions to Carb Tracker
date: 2017-05-03 19:18 UTC
author: Scott Savage
tags: flatiron school, learn.co, carb tracker
published: true
---

[Carb Tracker](https://carbtracker.herokuapp.com) was originally created as my Ruby on Rails project for the [Flatiron School's Online Web Developer Program](https://flatironschool.com/programs/online-web-developer-career-course/).  Following the Ruby on Rails coursework, the program continues with JavaScript, jQuery, and working with Rails APIs.  The JavaScript material culminates with updating your Ruby on Rails project with some JavaScript.  The following is some information about the my JavaScript based updates to Carb Tracker.

More information the original Carb Tracker project can be found [here](https://www.snsavage.com/blog/2017/creatingcarbtrackerwithrubyonrails.html).

READMORE

![](../images/carb-tracker-homepage.png)

Unlike some of the previous projects that seemed to be a little more open ended, this 4th project in the course had some more specific requirements.  Specifically, the requirements are to use JavaScript and jQuery to render an index page (some kind of list of things), render a show page (one specific thing), render a has-many relationship, process a form, and translate JSON responses into JavaScript Model Objects.  

## JavaScript Versions

One of the first challenges that I faced was dealing with different JavaScript versions.  I notices early on that my RSpec tests that used JavaScript began to fail even though the underlying Ruby and Rails code had not changed.  After some investigation I found that the JavaScript driver I was using, `poltergiest`, doesn't support ES6 features.  

I looked at some options for integrating ES6 into the project, but in the end decided to skip ES6 and instead focused on JavaScript's older syntax and jQuery.  One significant driver of this choice was to get a more clear understanding of what JavaScript features fall into each category of standard syntax, jQuery, and ES6.  While, the Online Web Developer program teaches pieces of all three, the distinctions were not always clear.  (I should note, I know that jQuery is not part of the JavaScript language, but I'm including it in this discussion because I wanted to have a clear understanding of how and when jQuery was useful in the context of the different JavaScript versions).

Now that the project is complete, I'm happy with that decision.  I'm sure that avoiding additional precompiles saved me some headaches and I feel like I was able to get a much better understanding of jQuery.  Additionally, the next (and final!) section of the project is React so at that point I'll be able to get a better understanding of the features and benefits of ES6.

## Active Model Serializers

The second major problem that I encountered was how to handle JSON requests in my Rails controllers.  In particular, how to manage the data being sent in the JSON responses.  As we learned in the curriculum, I turned to the `active_model_serializers` gem.

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

Above is the code that I'm not happy with.  One of the AJAX use cases I had was to handle the food search form on my recipes form.  To do this the response needed to include both foods found by the search and the foods available to the user to be rendered in the foods select list on the form.  Creating a new has on the fly to be rendered as JSON was the best why I found to combine these two datasets.  

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

I also needed to access ```current_user``` and I could do this by passing in the user when I called the serializer.  I was happy with this solution since all of the serialization logic was handled in the serializer.  *(As I writing this I realized a better way to handle the first situation, so a future refactoring is in order!  I can pass the ```foods_for_select``` into ```FoodSerializer``` and then expose that data by adding a method.)* 

## Handlebars




## Testing


## Conclusion




