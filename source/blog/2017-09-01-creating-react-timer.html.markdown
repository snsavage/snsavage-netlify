---
title: Creating React Timer with React, Redux, and Ruby on Rails
date: 2017-09-01 20:15 UTC
author: Scott Savage
tags: flatiron school, learn.co, react, redux, ruby on rails
published: true
---

I started the Flatiron School’s Online Web Developer program in March 2016.  Sitting here on September 1st, 2017, with the completion of my final project, I’ve invested over 1,200 hours, completing over 650 lessons and 5 major projects.  [React Timer](https://github.com/snsavage/timer-react), my final project for the Flatiron School, represents the culmination of this effort.  For me it represents a big step in my progress as a software developer.  Here is a little bit about how React Timer came together.

READMORE

![](../images/react-timer-screenshot.png)

## Introduction
The Flatiron School’s requirements for the project were to built a React based single-page application with a Ruby on Rails API backend.  My idea behind React Timer was to build a workout timer that could handle complex workout routines with groups of intervals that could be repeated.  As with most of my Flatiron School projects, the idea of this project was based on a specific personal need.  While I would still consider this project a work in progress, it still has all of the functionality that I need for it to be useful.  And I’ve very happy with the result!

## Thinking in React, and Redux

![](../images/react-timer-thinking.jpg)

When I first started the project, I hadn’t yet built any projects with React, aside from labs in the React and Redux section of the program.  Development with React is significantly different in approach from backend development with Ruby on Rails or even front-end development with JavaScript and jQuery.  React itself is fairly straight forward.  To me the design patterns are what make it so powerful and what add the complexity.  However, adding Redux into the mix can complicate even more things.  This is definitely the simple, but not easy paradigm.      

To get started I built a small sample version of a timer with just React.  This simple timer became the basis for the homepage of React Timer and served as a good reference as I developed the more complicated Routine Timer.

I then started working on the Ruby on Rails API.  While I’ve built several Rails projects, this one was different since it didn’t include any front-end, just the API endpoints.  I’ll talk more about that in a minute.

The trouble with React started when I began building the full front-end application with React.  My simple timer had been built as a single React component.  Understanding where and how to break my application idea into separate components was a challenge.  As I started to think about how to build the app, I put together several drawlings of the user interface.  A sample drawling is shown above.  

After struggling for a bit I came across the [Thinking in React - React](https://facebook.github.io/react/docs/thinking-in-react.html) article in the React docs.  I consider this a must read!  It’s explanation of how to organize React applications was extremely helpful.  As shown in the drawling above, I spent some time with colored pencils outlining different components in the section of React Timer that I was building.  Going through this process once was enough to get me thinking about how to approach React development.  

I also found Dan Aramov’s article about [Presentational and Container Components](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0) to be helpful in better understanding how to build and reuse my components.  This was helpful when integrating with Redux as well.  I noticed that as the React Timer project progressed and I became more comfortable with React and Redux the construction of my components began to improve.  Unfortunately, this means that the code reflects this changing understanding and lacks some consistency.  Improving the consistency of the codebase will be a focus as I continue to work on the project.    

## Ruby on Rails API
As I noted earlier, I’ve worked on several Ruby on Rails projects, but React Timer was the first to use Ruby on Rails as an API only.  Getting started with this took some thought.  I used the [Rails API](https://github.com/rails-api/rails-api) version of Rails to exclude any of the needed view layer extras.  

I found two different bloggers to be extremely helpful.  Sophie DeBenedetto’s [JWT Authentication with React + Redux](http://www.thegreatcodeadventure.com/jwt-authentication-with-react-redux/) article provided a great overview of implementing JWT authentication for a Rails API.  I also found Alex Fedoseev’s [Universal React with Rails: Part II](https://blog.shakacode.com/isomorphic-react-with-rails-part-ii-614980b65aef) article to be extremely helpful with setting up and testing the API.  There’s a lot in that article that I might not have thought about creating an API backend.

```json
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "type": "object",
  "require": ["routine"],
  "properties": {
    "routine": {
      "type": "object",
      "required": [
        "id",
        "name",
        "description",
        "link",
        "times",
        "user_id",
        "public",
        "groups",
        "duration"
      ],
      "properties": {
        "id": { "type": "integer" },
        "name": { "type": "string" },
        "description": { "type": "string" },
        "link": { "type": "string" },
        "times": { "type": "integer" },
        "user_id": { "type": "integer" },
        "public": { "type": "boolean" },
        "duration": { "type": "integer" },
        "groups": {
          "type" : "array",
          "required": [
            "id",
            "order",
            "times",
            "intervals"
          ],
          "properties": {
            "id": { "type": "integer" },
            "order": { "type": "integer" },
            "times": { "type": "integer" },
            "intervals": {
              "type" : "array",
              "required": [
                "id",
                "name",
                "order",
                "duration"
              ],
              "properties": {
                "id": { "type": "integer" },
                "name": { "type": "string" },
                "order": { "type": "integer" },
                "duration": { "type": "integer" }
              }
            }
          }
        }
      }
    }
  }
}
```

One consideration that I thought a lot about was how to handle the data structure for the routines.  I settled on a nested structure (as seen above) for the API endpoint in order to best reflect the database structure.  This is against the [recommendation](http://redux.js.org/docs/recipes/reducers/NormalizingStateShape.html) of the Redux developers, but it also initially seemed to solve some problems.  However, this made writing the routine reducers in more difficult.  This represents another area of improvement in the future. 

As a final note on the Rails side.  The Rails app has a significant test suite built with RSpec.  However, testing the API’s JSON output was not something that I had done before.  A used the article [Validating JSON Schemas with an RSpec Matcher](https://robots.thoughtbot.com/validating-json-schemas-with-an-rspec-matcher) from Laila Winner at ThoughtBot as reference for one approach and I was very happy with the result.  The code above is one of the JSON schemas that I used testing the app. 

## Semantic UI
For the front-end I decided to try a new-to-me front-end framework.  In the past I’ve used [Bootstrap](http://getbootstrap.com/) and the [Bourbon.io](http://bourbon.io/) suite of tools, but Bootstrap looked too much like, well Bootstrap, and Bourbon.io took a lot of manual intervention.  

For React Timer I choose [Semantic UI](https://semantic-ui.com/) and the [Semantic UI React](https://react.semantic-ui.com/introduction) integration for React.  I was really happy with the result.  Having the framework integrated with React components made the development process straightforward.  I also liked that I could just use React components to style the front-end instead of switching between html and css.  

## Conclusion
At this point, as I write these words, it’s hard to believe that I’m at the of the program.  I’ve learned so much and have become a much stronger developer.  As a final project, React Timer was very rewarding.  I really enjoyed the interactivity on the front-end provided by React.  And I like the patterns behind React and Redux.  The React Timer still has a long way to go.  I’ll be continuing to improve the project over the next several weeks.  Check back for updates!
