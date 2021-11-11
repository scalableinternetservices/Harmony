# README
## Harmony

Harmony is a Discord-like Web Service.

For anyone who might have issues running the program

```
docker-compose run web bundle install
docker-compose build web
docker-compose run web rails db:migrate
docker-compose up
```

If you have merge conflicts in `db/schema.rb`, follow [this](https://stackoverflow.com/questions/7614215/managing-conflict-in-schema-rb-created-by-git-operation) stackoverflow post.

If the db is in a bad state, to create a fresh database, follow [this link](https://stackoverflow.com/a/4116124/7263373)

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
