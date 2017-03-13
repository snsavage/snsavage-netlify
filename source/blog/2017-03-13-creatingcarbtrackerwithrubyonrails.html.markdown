---
title: Creating Carb Tracker with Ruby on Rails
date: 2017-03-13 15:25 UTC
author: Scott Savage
tags: flatiron school, learn.co, carb tracker
published: true
---

[Carb Tracker](https://carbtracker.herokuapp.com) allows users to track their nutrition in order to reach their health goals.  The original idea for the app was to build a tool to help users manage their diet based on [The Primal Blueprint Carbohydrate Curve](http://www.marksdailyapple.com/the-primal-carbohydrate-continuum/).  Users are able to add foods, create recipes, and log their food consumption.  Total nutrition statics are provided to help users understand their total consumption.  The [Nutrition Ix API](https://www.nutritionix.com/business/api) was used to allow users to search for foods and automatically receive nutrition data when creating recipes. 

Carb Tracker uses the Ruby on Rails web development framework.  The project was created for the [Flatiron School's Online Web Developer Program](https://flatironschool.com/programs/online-web-developer-career-course/).  Here is an overview of the process for creating the web app.   

READMORE

![](../images/carb-tracker-homepage.png)

## Introduction
The original idea is simple.  Most followers of the Paleo Diet have likely come across [The Primal Blueprint](http://www.marksdailyapple.com) and the [Carbohydrate Curve](http://www.marksdailyapple.com/the-primal-carbohydrate-continuum/).  This idea is that to maintain or lose weight the focus should be on daily carbohydrate consumption.  For example, to maintain weight, daily carbohydrate consumption should range between 100 to 150 grams per day and to lose weight consumption should range between 50 to 100 grams per day.

There are many nutrition trackers available, but most focus specifically on calorie consumption.  The idea with Carb Tracker was to focus more specifically on carbohydrate consumption per the Carbohydrate curve.  

This project was completed as part of the Flatiron School's Online Web Developer program.  Accordingly, the app was required to use a few different features of the Rails framework.  Some of these requirements included at least one many-to-many model relationship, nested forms, user authentication, and a nested resource. 

## NutritionIx API
One of the problems when building these student projects is the balance between creating a project purely for learning purposes and creating a usable "real world" project.  Having good data to work with can really help to create a more realistic final project.  For Carb Tracker, I wanted the user to be able to search for foods and to be able to get back nutrition information for those foods.

To achieve feature, I settled on using the [Nutrition Ix API](https://www.nutritionix.com/business/api).  There are a lot of food nutrition APIs that are available, but I settled on the Nutrition Ix for one particular reason.  The API has an endpoint for natural language searching.  This allows the end user describe the food with a phrase like "1 large apple" or "1 cup flour".  The API will interpret that language and return nutrition information based on the food and quantity provided.  Using this feature of the API greatly simplified the programming for Carb Tracker, by reducing requirements around handling different food quantities and measurements.  

Unlike my previous project that had a well written and comprehensive Ruby wrapper library for their API, the Nutrition Ix libraries were not well suited to this project.  To solve this problem, I created a ```NutritionIx``` class with the ```HTTParty``` gem to handle calls to the api.  The following code in an abbreviated version of the class.     

```ruby
class NutritionIx
  include HTTParty

...

  base_uri "https://trackapi.nutritionix.com"

  # The class is initialized with a food search string.
  def initialize(search = "", line_delimited = true)
    @search = search
    @line_delimited = line_delimited
  end

  # Test for API errors.
  def errors?
    data[:message] ? true : false
  end

...

  # Returns the parsed list of foods to be used in the Rails app.
  def foods
    return [] if errors?

    parse_foods
  end

...
  
  # Calls the API and caches the parsed data.
  def data
    @data ||= call_api
  end

...

  private
  # Handles the cleanup of the returned JSON data.
  def parse_foods
    parse = data[:foods].deep_dup

    @foods = parse.collect do |food|
      food[:tag_id] = food[:tags][:tag_id]

      self.class.filter_keys!(food, ALLOWED_KEYS)
      self.class.remove_nf_from_keys!(food)

      food
    end
  end

  # Uses the HTTParty gem to make the HTTP request to the API.
  def call_api
    response = self.class.post(
      "/v2/natural/nutrients", headers: headers, body: body
    ).parsed_response

    response.deep_symbolize_keys!
  end

...

end
```

To use this class a new instance is created with a search term and then the ```foods``` method is called.  For example, ```NutritionIx.new("1 apple").foods```.  

When the class is initialized, no calls to the API are made.  Only when ```foods``` is called does the class make a request to the API.  The ```data``` method handles when requests to the API are made.  It caches the result to prevent multiple API calls for the same data.  The full code can be found [here](https://github.com/snsavage/carb_tracker/blob/master/app/models/nutrition_ix.rb).

## Creating Recipes

Most of the Carb Tracker app followed a normal CRUD design pattern and fit nicely into the Rails framework.  However, one page was a little unusual and caused some problems.  

In order for a user to track the foods they've consumed, I wanted them to be able to create recipes.  With this app foods are logged by logging recipes.  That way a user can log both a single food (just a recipe with one food) or a more complex recipe.  In order to achieve this goal, the form to create a recipe became fairly complex.  The ```RecipesController#create``` action, which processes that form, is shown below.      

```ruby
def create
  @recipe = Recipe.new(recipe_params)

  if params[:commit] == "Search"
    api = NutritionIx.new(params[:recipe][:search])

    @recipe.foods << Food.find_or_create_from_api(api.foods)
    @foods_for_select = policy_scope(Food)

    flash.now[:alert] = api.messages if api.errors?
    flash[:notice] = t ".search.success" unless api.errors?
    render :new

  elsif params[:commit] == "Create Recipe"
    @recipe.save

    if @recipe.invalid?
      @foods_for_select = policy_scope(Food)

      render :new and return
    end

    redirect_to recipe_path(@recipe)
  end
end
```

The form to create a recipe allows the user to create a recipe one of three ways.  Either by creating a new food, adding an exiting ingredient that is already in the database, or by searching for new foods from Nutrition Ix.  

![](../images/carb-tracker-search.png)

Searching for new foods (shown above) was one of the first features added to this form.  Users can add their search terms and click on the search button.  This calls the API through the NutritionIx class discussed either, saves those foods to the database, and then renders the form.  

The form is processed this way by the above ```#create``` method when the form has a ```search``` ```:commit``` ```param```.  The call to ```Food.find_or_create_from_api``` ensures that no duplicate foods are created and is written to handle the data from the NutritionIx class.

The Cocoon gem was used to add some nice JavaScript interaction to the form.  Using Cocoon allowed me to create dynamic fields for the foods and ingredients.  This allows the end-user to add and remove those nested field values.  The alternative would have been allowing only one of each or a certain preset number.  

However, allowing this dynamic functionality also caused some problems, particularly around form submissions that were not valid.  For instance, if a user added a new food, but did not properly fill out the form, a list of blank ingredients would accumulate on the re-rendered form.  One for each invalid food submission.  This happened because a blank ```ingredient``` instance would be created as the join between the new food and the new recipe.  This blank ```ingredient``` would then be rendered in the form.  On each invalid submission the blank ```ingredient``` would be submitted and another one would be create for the invalid ```food```.  

```ruby
<%= f.fields_for :ingredients do |ingredient| %>
  <% if ingredient.object.food.valid? %>
    <%= render "ingredient_fields", f: ingredient %>
  <% end %>
<% end %>
```

The solution was to filter ingredients without a ```food_id``` from being displayed the form as shown above.  However, I'm not very happy with that solution and in the future I might change out the current process into a [form object](https://robots.thoughtbot.com/activemodel-form-objects).   

## Nutrition Statistics

One of the more complex problems that I encountered while working on Carb Tracker was how to handle nutrition statistics.  In order for users to track how many carbs they were consuming each day, the app needed a way to sum all of the foods in each recipe that was logged for a given day.  There was additional complex around quantities that were added on the join tables between recipe and food, as well as log and recipe.  After trying to use ActiveRecord for these queries I turned to a different solution.

In the end I choose a gem called [Scenic](https://github.com/thoughtbot/scenic).  Scenic helps developers create "versioned database views for Rails".  Database views are essentially just saved SQL queries that act like a database table.  

```sql
SELECT recipes.id AS recipe_id,
  ingredients.id AS ingredient_id,
  foods.id AS food_id, 
  foods.food_name AS name,
  foods.calories * ingredients.quantity / recipes.serving_size AS calories,
  foods.total_carbohydrate * ingredients.quantity / recipes.serving_size AS carbs,
  foods.protein * ingredients.quantity / recipes.serving_size AS protein,
  foods.total_fat * ingredients.quantity  / recipes.serving_size AS fat
FROM foods
JOIN ingredients ON foods.id = ingredients.food_id
JOIN recipes ON ingredients.recipe_id = recipes.id
GROUP BY recipes.id, ingredients.id, foods.id, foods.food_name
ORDER BY recipes.id ASC;
```

Using Scenic allowed me to use the SQL queries that I knew worked along with ActiveRecord and migrations.  The SQL query for ```recipe``` nutrition statistics is shown above.  The SQL above is for the ```Stat``` table and adjusts the nutrition information for each ingredient in a recipe by the ```ingredient.quantity``` and ```recipe.serving_size```.     

```ruby
class Stat < ApplicationRecord
  belongs_to :recipe

  def self.per_recipe
    select(
      "recipe_id,
      sum(calories) AS total_calories,
      sum(carbs) AS total_carbs,
      sum(protein) AS total_protein,
      sum(fat) AS total_fat"
    ).group("recipe_id")
  end
end
```

The beauty of this approach is that it allows you to use your database view as an ActiveRecord model, as shown above.  The ```Stat``` model is just a representation of the SQL.  Nothing extra is stored in the database, but the SQL query.  This same process was repeated to create the total nutrition statistics for the logs.    

## Authorization with Pundit

```ruby
class RecipePolicy < ApplicationPolicy
  def show?
    record_belongs_to_user? || record.public?
  end

  def edit?
    record_belongs_to_user?
  end

  def update?
    edit?
  end

  def destroy?
    edit? && record_not_used_in_entry?
  end

  class Scope < Scope
    def resolve
      Recipe.where(user_id: user.id).or(Recipe.where(public: true))
    end
  end

  private
  def record_not_used_in_entry?
    !Entry.exists?(recipe_id: record.id)
  end
end
```

On a previous project, I used the CanCanCan gem to handle user authorization.  So for this project I turned to Pundit to better understand Pundit's approach.  The code above shows the policy class for ```Recipe```.  I found using Pundit to be much more straight forward then using CanCanCan.  Pundit has less of the "magic".  As shown above it's just a simple Ruby class without a DSL.  I will certainly use this gem in the future.   

## Conclusion

As compared to my previous Sinatra project, working with Rails was a huge benefit.  When I created the [PhotoVistas](https://www.photovistas.com) project with Sinatra, so much of the battle was getting all of the "Rails like" features that I needed to create a complete web app.  With this project, much more of my energy was spend on the actually creating the app.  

While, the project definitely lacks some usability and polish that I would have liked to see I'm pleased with the results.  Since working on my last Rails project back in 2015, I know that I have certainly come a long way as a developer.  I understand what Rails is during the background much better and I am much more confident as a Ruby developer.  The Carb Tracker project allowed me to use some new gems, improve my skills with using APIs, and further my understanding of Rails.  Overall a success!

*The code for this project can be found on [GitHub](https://github.com/snsavage/carb_tracker).*









     
