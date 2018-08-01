# README

Rails application that runs some timers and prints things based on those timers. This is an API only application; there is no UI so the only output is printed in the terminal.

Run Instructions
---
* `rails db:setup` to seed database configs
* Redis must be running (`redis-server`)
* Sidekiq must be running (`bundle exec sidekiq`)
* `rails server`

Timer Endpoint
---
* **URL:** api/v1/timers
* **Purpose:** Start a timer, or cancel a timer if one already exists for the ID passed in.
* **Method:** POST 
* **URL Params:** N/a 
* **Headers:** N/a
* **JSON Body:**
  * Key: 'id', Value: 15 digit hexadecimal string
* **Success Response:** 
  * Code: 200
  * Content: `{ "status": "SUCCESS", "message": "POST succeeded" }`
* **Error Response:** 
  * Code: 400
  * Content: `{ "status": "FAILED", "message": "Invalid ID value" }`

Config Endpoint
---
* **URL:** api/v1/configs. 
* **Purpose:** Sets a configuration value. Only 'Timer expiration' config does anything, but can be extended.
* **Method:** POST 
* **URL Params:** N/a 
* **Headers:** N/a
* **JSON Body:**
  * Key: 'description', Value: A string
  * Key: 'value', Value: A number representing how long a timer should run before it is expired
* **Success Response:** 
  * Code: 200
  * Content: `{ "status": "SUCCESS", "message": "Updated config" }`
* **Error Response:** 
  * Code: 400
  * Content: `{ "status": "FAILED", "message": "Invalid Arguments" }`