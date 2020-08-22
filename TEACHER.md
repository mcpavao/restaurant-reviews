## SET UP -> follow slides

## CREATES MODELS -> design database
Restaurants
id
name
rating
address

Reviews
id
content
rstaurant id (conneceted to restaurants id)

## GENERATE MODEL:
rails g model restaurant name address rating:integer
FILES GENERATED:
- migration file create restaurants
- restaurant model
- routes -> let's code!!!
- restaurants controller

rails generate model review content:text restaurant:references
check migration
db:migrate
LINK THEM IN THE MODEL

SEQUENCE:
ROUTES
collection bc i dont need the restaurant id
/restaurants/top
memner bc i need an id
/restaurants/:id/chef
CONTROLLER:
top restaurants - > Restaurant.where(rating: 5)
26mins random array items seed

NESTED RESOURCES:



