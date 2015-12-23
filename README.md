# ventry-api

An app housing Ventry's Api. Deployed on Heroku.

This application support the ventry-api on Heroku.

Ruby version ruby 2.2.0p0 (2014-12-25 revision 49005)

## Running Locally

Make sure you have Ruby installed.  Also, install the [Heroku Toolbelt](https://toolbelt.heroku.com/).

```sh
$ git clone git@github.com:heroku/ruby-getting-started.git
$ cd ruby-getting-started
$ bundle install
$ bundle exec rake db:create db:migrate
$ foreman start web
```

Your app should now be running on [localhost:5000](http://localhost:5000/).

## Deploying to Heroku

```sh
$ heroku create
$ git push heroku master
$ heroku run rake db:migrate
$ heroku open
```

## Pushing to Staging

staging GIT URL: git@heroku.com:ventry-api-staging.git

Root URL: www.ventry-api-staging.herokuapp.com

```sh
$ git status
$ git add .
$ git commit -am "Commit message"
$ git push staging master 
```

## Pushing to Production

production GIT URL: git@heroku.com:ventry-api.git

Root URL: www.ventry-api.herokuapp.com

```sh
$ git status
$ git add .
$ git commit -am "Commit message"
$ git push production master 
```

## API Endpoints

This endpoint returns all products in the Ventry database and each product's info.

_GET /products_
```sh
["###"]
0:  {
  id: "###"                                 --Integer
  productName: "Some Product Name"          --String
  user_id: "##"                             --Integer
  created_at: "2015-08-04T00:00:00.000Z"    --Date/Time
  updated_at: "2015-08-04T00:00:00.000Z"    --Date/Time
  supplier_id: "##"                         --Integer
  price: "$00.00"                           --String
  imageurl: "www.someimageurl.com"          --string
  externalId: "########"                    --string
  detailPageUrl: "www.someurl.com"          --string
  tag: "Random"                             --string
}

1: {
  id: "###"                                 --Integer
  ...
}

```
This endpoint returns the specified product's info.

_GET /products/:id_
```sh
{
  id: "###"
  productName: "Some Product Name"          --String
  user_id: "###"                            --Integer
  created_at: "2015-08-04T00:00:00.000Z"    --Date/Time
  updated_at: "2015-08-04T00:00:00.000Z"    --Date/Time
  supplier_id: "###"                        --Integer
  price: "$00.00"                           --String
  imageurl: "www.someimageurl.com"          --String
  externalId: "######"                      --Integer
  detailPageUrl: "www.someurl.com"          --String
  tag: "some_name"                          --String
}

```
This endpoint returns all productqueues and associated products.

_GET /productqueues_
```sh
["###"]
0:  {
  queue_id: "##"                             --Integer
  Tag: "some_name"                           --String
}

1: {
  queue:id: "##"                             --Integer
  ...
}
```
This endpoint returns the specified productqueue's info and product ids associated with that queue.

_GET /productqueues/:id_
```sh
{
  id: "###"                                    --Integer
  user_id: "###"                               --Integer
  created_at: "2015-11-10T00:07:53.270+00:00"  --Date/Time
  updated_at: "2015-11-10T00:07:53.270+00:00"  --Date/Time
  productids: ["###"]                          --Integer
  0:  "###"                                    --Integer
  1:  "###"                                    --Integer
  2:  "###"                                    --Integer
  3:  "###"                                    --Integer
  ...
  tag: "Category Name"                         --String
}
```
This endpoint adds products to the specified productqueue and then returns the productqueue info and the newly added products.

_GET /productqueues/addproducts/:id_
```sh
{
  id: "###"                                    --Integer
  user_id: "###"                               --Integer
  created_at: "2015-11-10T00:45:18.239+00:00"  --Date/Time
  updated_at: "2015-11-10T00:45:18.239+00:00"  --Date/Time
  productids: ["###"]
  0:  "###"                                    --Integer
  1:  "###"                                    --Integer
  2:  "###"                                    --Integer
  3:  "###"                                    --Integer
  ...
}
```

_POST /activities/share_
```sh
{
  user_id: "###"                               --Integer
  friend_id: "###"                             --Integer
  activity_id: "###"                           --Integer
}
```

_GET /v0/users/:id/friendships_
```sh
-0: {
      "user_id": "##"
      "id": "##"
      "friend_id": "##"
      "created_at": "YYYY-MM-DDTHH:MM:SS.264Z"
      "updated_at": "YYYY-MM-DDTHH:MM:SS.264Z"
      "accepted": "BOOL"
    }
-1: {
        "user_id": "##"
        ...
    }
```


_PATCH /friendships_

*Payload*
```sh
{"user_id":"##", "friend_id":"##"}
```

*Response*
```sh
{
  "id": "##"
  "user_id": "##"
  "friend_id": "##"
  "created_at": "YYYY-MM-DDTHH:MM:SS.810Z"
  "updated_at": "2015-12-22T20:35:33.810Z"
  "accepted": "BOOL"
}
```

_PATCH /v0/friendships/accept/:id_
```sh
{
  "friendship": {
    "id": "##"
    "user_id": "##"
    "friend_id": "##"
    "created_at": "YYYY-MM-DDTHH:MM:SS.810Z"
    "updated_at": "YYYY-MM-DDTHH:MM:SS.174Z"
    "accepted": "BOOL"
  }-
  "reverse friendship": {
    "id": "##"
    "user_id": "##"
    "friend_id": "##"
    "created_at": "YYYY-MM-DDTHH:MM:SS.178Z"
    "updated_at": "YYYY-MM-DDTHH:MM:SS.178Z"
    "accepted": "BOOL"
  }-
}
```
**When the friend accepts the request, we create a reverse friendship that mirrors the initial request. This occurs so that the friend can see the friendship as well as the original user who initiated the friend request.**

_PATCH /v0/friendships/reject/:id
```sh
{
  "message": "Friendship rejected"
}
```
**If the friendship is rejected, both the friendship and the reverse friendship are destroyed.**


For more information about using Ruby on Heroku, see these Dev Center articles:

- [Ruby on Heroku](https://devcenter.heroku.com/categories/ruby)