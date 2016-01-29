# ventry-api

An app housing Ventry's Api. Deployed on Heroku.

This application support the ventry-api on Heroku.

Ruby version ruby 2.2.0p0 (2014-12-25 revision 49005)

## Running Locally

Make sure you have Ruby installed.  Also, install the [Heroku Toolbelt](https://toolbelt.heroku.com/).

```sh
$ git clone https://BiiGRiiG@bitbucket.org/gimmee/ventryapi.git
$ cd VentryApi
$ bundle install
$ bundle exec rake db:create db:migrate
$ rails s
```

Your app should now be running on [localhost:3000](http://localhost:3000/).

## Deploying to Heroku (Must have Heroku toolbelt installed)

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

This endpoint creates a user

_POST /users_

**This endpoint creates a user and returns the details of the newly created user. When a user is created, default channels are automatically created for that user based on parent channels that have the `default` field set to `TRUE`.

*Payload*
```sh
{
  "firstName":"Some first name",
  "lastName":"Some last name",
  "email":"Some email",
  "username":"Some username",
  "phone":"some phone number"
}
```
*Response*
```sh
{
  "id": 14
  "created_at": "2016-01-07T04:30:55.043Z"
  "firstName": null
  "lastName": null
  "updated_at": "2016-01-07T04:30:55.043Z"
  "username": null
  "email": null
  "encrypted_password": null
  "salt": null
  "phone": null
}
```

This endpoint returns all products in the Gimmee database and each product's info.

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
This endpoint returns all channels for a specified user.

_GET /v0/users/:id/channels_
**response**
```sh
{
  {
    "user_id": "####",                            --UUID
    "id": "##",                                   --Integer
    "created_at": "YYYY-MM-DDTHH:MM:SS.353Z",     --Date/Time
    "updated_at": "YYYY-MM-DDTHH:MM:SS.353Z",     --Date/Time
    "parent_channel_id": 1,                       --Integer
    "view_count": "##"                            --Integer
  }
}
```
This endpoint returns the parent channel info of the specified user's channels.

_GET /v0/users/:id/parent\_channels_
**response**
```sh
{
  { 
    "id": "##",                              --Integer
    "created_at": "YYYY-MM-DDTHH:MM:SS.395Z",--Date/Time
    "updated_at": "YYYY-MM-DDTHH:MM:SS.395Z",--Date/Time
    "title": "some_title",                   --String
    "image_url": "Some_url",                 --String
    "tags": ""                               --Hash
  }
  {
    ...
  }
}
```
This endpoint adds products to the specified channel and then returns the ids of the newly added products.

_GET /v0/channels/addproducts/:id_
```sh
{
  0:  "###"                                    --Integer
  1:  "###"                                    --Integer
  2:  "###"                                    --Integer
  3:  "###"                                    --Integer
  ...
}
```

_POST /v0/activities_

**Request**
```sh
{
  user_id: "####",                             --UUID
  product_id: "####",                          --Integer
  channel_id: "####",                          --Integer
  gimmee: "true/false",                        --Boolean 
  like: "true/false",                          --Boolean
  view_time: "####",                           --float
  channel_view_count: "##"                     --Integer
}
```
**Response**
```sh
{
  activity_id: "####"                          --Integer
}
```

_GET /v0/users/:id/activities_

**Response**
```sh
{
  "user_id": "####"                            --UUID
  "id": 1                                      --Integer
  "product_id": 1                              --Integer
  "created_at": "2016-01-25T01:32:16.688Z"     --Date/Time
  "updated_at": "2016-01-25T01:32:16.688Z"     --Date/Time
  "shared_activity_id": null                   --Integer
  "channel_id": 1                              --Integer
  "gimmee": null                               --Boolean
  "like": null                                 --Boolean
  "view_time": null                            --Float
  "channel_view_count": null                   --Integer
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
      "initiated_friendship": "BOOL"
    }
-1: {
        "user_id": "##"
        ...
    }
```


_POST /friendships_

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
  "initiated_friendship: "BOOL"
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
    "initiated_friendship": "BOOL"
  }-
  "reverse friendship": {
    "id": "##"
    "user_id": "##"
    "friend_id": "##"
    "created_at": "YYYY-MM-DDTHH:MM:SS.178Z"
    "updated_at": "YYYY-MM-DDTHH:MM:SS.178Z"
    "accepted": "BOOL"
    "initiated_friendship": "BOOL"
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