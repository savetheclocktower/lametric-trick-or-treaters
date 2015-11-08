# Trick or Treaters

A demo app for [LaMetric](http://lametric.com "LaMetric Time - smart clock for home and office") that counts arbitrary things — in our case, the number of trick-or-treaters that knocked on our door this Halloween.

# How it works

Well, it's keeping track of exactly one number, so it's pretty simple. I used Heroku with Redis as my data store.

There's a web frontend for incrementing the number. The LaMetric will poll every so often and update the displayed count. There's a `/lametric` endpoint that returns JSON of the form:

```js
{
  "frames": [
    {
      "index": 0,
      "text": "trick or treat",
      "icon": "a77"
    },
    {
      "index": 1,
      "text": "250 served",
      "icon": null
    }
  ]
}
```

This will display two "frames" on the LaMetric: first, it'll say "trick or treat" with an icon on the left-hand side, then it'll show "250 served" with no icon.

When you increment the total via the frontend, the new number will show up on the device within a few seconds, depending on how often you configured the LaMetric app to poll.

A "More" link at the bottom of the page hides advanced controls — a way to reset the counter to zero, and a way to set an arbitrary value for the counter.

# Adding it to your LaMetric

Go to LaMetric's developer site and login. Create a new "indicator" app and you'll see something like this:

![screenshot](http://i.imgur.com/mVY3eNi.png)

As depicted here, you'll need to create two frames that correspond to the frames you'll be sending from the endpoint. The text you enter for these frames will be the initial state of the app, before it requests data. (If you want your app to show, say, three frames, make sure to create three here instead, or else the third frame from your `/lametric` endpoint will be ignored.)

Select "Poll" for the communication type. Select whatever poll frequency you like — I left it at "5 sec" — and then give it the URL for your endpoint, which should end with `/lametric`.

Once you've created **and published** the app, it should be available for putting onto your LaMetric within a minute or two. Go to your LaMetric iOS/Android app, click on the plus sign at the end of your app list, then use the dropdown to switch the source to "Private." You should see your app and be able to add it.

