# ruby-getting-started

A barebones Rails app, which can easily be deployed to Heroku.

This application support the [Getting Started with Ruby on Heroku](https://devcenter.heroku.com/articles/getting-started-with-ruby) article - check it out.

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
  id: "###"
  user_id: "###"
  created_at: "2015-11-10T00:07:53.270+00:00"
  updated_at: "2015-11-10T00:07:53.270+00:00"
  productids: ["###"]
  0:  "###"
  1:  "###"
  2:  "###" 
  3:  "###"
  ...
  tag: "Category Name"
}
```


For more information about using Ruby on Heroku, see these Dev Center articles:

- [Ruby on Heroku](https://devcenter.heroku.com/categories/ruby)