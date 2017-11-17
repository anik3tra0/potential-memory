## Sample Application with API for React Project
[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/0f88520f11a56a74769b)
![Heroku](https://heroku-badge.herokuapp.com/?app=heroku-badge) 

[Checkout the API](https://documenter.getpostman.com/view/2368014/potential-memory/77o4Lz4)

### Instructions

This needs postgres to work so update your database.yml file with the below configs. Replace the ENV with your relevant username and password

```
bundle install
rake db:drop db:create db:migrate
```

```
development:
  adapter: postgresql
  encoding: unicode
  database: potential_memory_dev
  host: localhost
  pool: 5
  username: <%= ENV["USERNAME"] %>
  password: <%= ENV["PASSWORD"] %>
```