---
title: How to Deploy a React App with API Request Proxying
date: 2017-09-21 19:07 UTC
author: Scott Savage
tags: react, ruby on rails
published: true
---

I recently completed my final project for the [Flatiron School's Full Stack Web Development](https://flatironschool.com/programs/online-web-developer-career-course/) program.  This project consisted of a React front-end paired with a Ruby on Rails API backend.  As the project came to an end the question became, how to deploy this thing?

READMORE

## Deploying the Rails API
The Rails side of the application is fairly straight forward.  I’ve always just deployed to Heroku’s free tier, which works well for these types of side projects.  Heroku has good instructions [here](https://devcenter.heroku.com/articles/getting-started-with-rails5).  

The quick synopsis is to: 
1. Create your Rails app.
2. Check it into git.
3. Setup PostgreSQL as your DB.

Then you can simply run…

```bash
$ heroku create
$ git push heroku master
$ heroku run rake db:migrate
$ heroku open
```

Making sure to regularly run `git push heroku master` as you develop your app will help to prevent any Rails/Heroku related deployment issues along the way.

## So what about React?
The React portion of my app was created with [create-react-app](https://github.com/facebookincubator/create-react-app).  If you’re using React, `create-react-app` is a great way to get up an running quickly.  It provides some tools and scaffolding to get you started.  Also, if you haven’t read the [REAME.md](https://github.com/facebookincubator/create-react-app/blob/master/README.md) there is some great information contained inside!

When developing a React app with `create-react-app` the `npm start` command runs the local development server and changes to files are watched and updated in the browser providing an interactive development experience.  However, for deployment a different set of steps are required.  With `create-react-app` the `npm run build` command will handle all of the necessary steps to make the application production ready.  These steps includes building all of the JavaScript files into the build folder and optimizing the app for best performance.  This process will create a small set of static files containing all of the code necessary for your app.  After the React app has been built, only a static web host is required to serve the files.

### Deploying with Netlify

The deployment section of the `README` has information on how to deploy to specific hosting services.  I’m going to focus on a specific provider, [Netlify](https://www.netlify.com/), who I’ve used in the past for my [personal website](https://www.snsavage.com).  Netlify has some great features and is easy to use, so I turned to it for this project too.  

To deploy your app Netlify will pull your code from GitHub (or other hosted Git provider).  If your React app’s code is already on GitHub you can just select the repo for your app.    Netlify will setup all of the required settings for your, which in this case is to use the `master` branch, run `npm run build` to build the app, and use the `/build` directory to publish the app.  The instructions from `create-react-app` can be found [here](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#netlify).  Subsequent pushes of your code to GitHub will trigger a build on Netlify and deploy the updated version of the app.  The mechanism provides a quick and easy way to keep your site up to date.    

### Adding a `_redirects` File

The final step to deploy with Netlify is to add a `_redirects` file to the `public` folder of your application.  The `_redirects` file will handle two situations.  The first is supporting `pushState`, which you’ll need to use [React Router](https://reacttraining.com/react-router/) or to support url changes while having a single-page React application.  The second is to proxy requests for your API calls.  

For the first situation add a line containing `/*  /index.html  200` to your `public/_redirects` file.  This is just telling Netlify to send all requests for your React app to `/index.html` instead of the actual requested route.  For example a request to `your-app.com/articles` will be redirected to `/index.html`.  Because React apps are single-page applications with only one HTML file, if this was not enabled requests to other routes would try to access files that don’t exist on your server.

The second use of the `_redirects` file is to avoid [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS) issues when calls are made from your React app to your API.  Netlify allows you to proxy requests through their hosting service.  To use proxying with Netlify, simply add another line to your `/public/_redirects` file.  The example Netlify provides is `/api/*  https://api.example.com/:splat  200`, which tells their servers to redirect any requests made to `/api/*` to your API server.  In my case this line looked like `/api/* https://timer-rails.herokuapp.com/api/:splat  200`.  I placed this first in the file to make sure that the previously discussed `/*` redirect did not override calling out to the API.  The documentation from Netlify can be found [here](https://www.netlify.com/docs/redirects/)..

Here is the final `/public/_redirects` file for my site:

```
/api/* https://timer-rails.herokuapp.com/api/:splat  200
/*  /index.html  200
```

## Conclusion

I’ve been happy with this setup so far.  Getting this working was straightforward and I haven’t had any issues.  The code for this project can be found [here](https://github.com/snsavage/timer-react).  Please direct questions and comments [here](https://www.snsavage.com/contact).
