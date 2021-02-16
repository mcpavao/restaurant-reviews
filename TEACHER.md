Hoje nos vamos ir um pouco além dos CRUD actions que vocês aprenderam ontem. Algumas vezes será interessante criar outras rotas além das 7 que voc~es aprenderam... que são index, create, new, edit, show, update e destroy.

## SET UP -> follow slides
hoje vamos trabalhar com 2 modelos, restaurant e review
<!-- 
rails new rails-poject-name --skip-active-storage --skip-action-mailbox
cd rails-poject-name
git add .
git commit -m "rails new"
hub create
git push origin master -->

## SLIDES SET UP

## CREATES MODELS -> design database
Restaurants(table)
id
name
rating
address

Reviews(table)
id
content
restaurant id (references restaurants id)

## SCAFFOLD
EU ESTOU USANDO O SCAFFOLD PESSOAL PELO SIMPLES FATO DELE GERAR TODAS AS ROTAS COM SEUS RESPECTIVOS METODOS PRONTOS, DESSA FORMA NOS PODEMOS COMEÇAR A AULA DE HOJE EXATAMENTE DE ONDE PARAMOS ONTEM. TUDO BEM?

check migration
db:migrate
LINK THEM IN THE MODEL
FILES GENERATED:
- migration file create restaurants
- restaurant model

## check migration file
## check schema
## check model
## check route
## check controller

## CREATE
o metodo create esta um pouco diferente comparado ao que vcs fizeram na aula de ontem. Mas não se preocupem vamos passar por aqui trabalhando linha por linha e vou mostrar pra vcs o que ha de diferente no nosso metodo create de hoje.

## CREATE A SEED
## ADD FAKER TO GEMFILE
## BUNDLE INSTALL

`puts 'cleaning up database...'`
`Restaurant.destroy_all`
`puts 'database is clean!'`


`puts 'Creating restaurants'`
`100.times do`
  `restaurant = Restaurant.create(`
    `name: Faker::Restaurant.name,`
    `address: Faker::Address.city,`
    `rating: rand(1..5),`
  `)`
  `puts "restaurant #{restaurant.id} is created."`
`end`

`puts 'All Done!'`

## RAILS DB:SEED
## RAILS DB:MIGRATE

## LET'S CHECK RAILS C!
## GIT ADD . GIT COMMIT -M "SEEDED 100 RESTAURANTS

## LET'S CHECK OUT RAILS S!
## SCAFFOLD TAMBEM GEROU OS MEUS ARQUIVOS VIEW.

Já criamos nosso modelo, controller, rotas e nosso seed. Então
vamos agora além do CRUD.

Digamos que eu queira listar os TOP restaurants do meu app. Nós temos nosso atributo rating no nosso modelo restaurant, e esse rating vai de um a cinco. Eu quero então listar todos os restaurantes que possuem o rating 5.

Vamos então no nosso rails c, e eu quero q vcs me ajudem a criar o query necessário para buscar essa informação.
Bom sabemos que estamos no nosso modelo Restaurant, mas qual metodo do active record vamos utilizar para filtrar esse dado? (find vai retornar UM, o primeiro registro da base, e o where vai retornar varios.)
`Restaurant.where(rating: 5)`

## ROUTES
Então no nosso route, vamos introduzir dois novos metodos
um chamado collection e o outro chamado member.
Vamos então abrir um bloco e o metodo que eu inserir aqui dentro desse bloco estara dentro contexto restaurant.

`resources :restaurants do`
  a rota do metodo que eu inserir aqui vai sempre começar com /restaurants/... a rota que eu criar
  collection do
    get :top
  end
`end`

COLLECTIONS:
é um método em rails que nos permite criar novas rotas dentro do contexto em que estamos: nesse caso, dentro do resources restaurants;

## vamos ver o que foi gerado em rails routes
percebam que temos nossos crud action e uma rota adicional que é nossa rota top restaurants.

é justamente pq colocamos nosso top dentro do context de restaurants que rails sabe que nosso metodo top irá dentro do restaurants controller.

A forma antiga seria fazer:
`# get 'top', to: 'restaurants#top', as: :top_restaurants`
foi o que vcs fizeram ontem, e funciona perfeitamente tb. mas não precisamos mais escrever tudo isso. rails existe pra facilitar nossa vida.

## ENTÃO CRIAMOS NOSSA ROTA, QUAL PROXIMO PASSO?
## CRIAR O METODO TOP NO CONTROLLER

def top
  @restaurants = Restaurant.where(rating: 5)
end

e agora o que precisamos fazer é criar nosso view.
top.html.erb


######
<h1>My top Restaurants</h1>

<% @restaurants.each do |restaurant| %>
  <p> <%= restaurant.name %> <%= '⭐' * restaurant.rating %></p>
<% end %>
##### 

### qual a rota de nosso top restaurants?
`http://localhost:3000/restaurants/top`


ANINHAMENTO: SOMENTE NAS ROTAS COLLECTION, NUNCA NAS ROTAS MEMEBER!
vamos aninhar a rota de nossos reviews dentro de nossos restaurantes porque os reviews são relacionados ao seu respectivo restaurante e toda vez que eu crio um review novo
eu preciso pegar um id de restaurante pela qual eu quero escrever meu review. Este id vem do url.

## slide about the chef
## vamos utilizar o metodo member agora
digamos que eu queira adicionar um chef aos meus restaurantes.
a primeira coisa que precisamos fazer é adicionar a coluna chef_name no meu modelo. Pra isso precisamos de um novo migration:
sempre seguindo a convençao td bem pessoal? NUNCA, JAMAIS mexer no schema manualmente.

## ADDING AND REMOVING COLUMNS
- Create a migration:
rails g migration AddAddressToRestaurants address:string
rails g migration AddChefNameToRestaurants address:string

rails g migration AddPriceToRestaurants price:integer
rails g migration RemovePriceFromRestaurants price:integer

`rails g migration AddChefNameToRestaurants chef_name:string`

==================================================
`TO DESTROY A MIGRATION GENERATED BY MISTAKE:`
rails generate migration dropAddressFromRestaurants address:string (BAD)
rails destroy migration dropAddressFromRestaurants address:string (BAD)

## ADDING AND REMOVING COLUMNS
vamos olhar nosso arquivo, pra ver se a migração foi adicionada corretamente.

rails db:migrate

## PRECISAMOS ALTERAR NOSSO SEED FILE!!!
`chef_name: ['Roberta Sudbrack', 'Helena Rizzo', 'Alain Ducasse', 'Jamie Oliver'].sample`

rails db:seed

## GIT ADD GIT COMMIT -M "ADDED CHEF_NAME TO RESTAURANTS"

Ainda dentro do contexto resources restaurant vamos criar nosso metodo member:
resources :restaurants do
    collection do
      # /restaurants/top
      get :top
    end

    member do
      # /restaurants/:id/chef
      get :chef
    end
  end

Vamos então dar uma olhada nas rotas que foram geradas:
Percebam então a diferença entre collection e member. Nosso metodo collection possui somente /o padrão restaurants/top. nosso metodo member possui /restaurants/:id/chef

utiliamos collection quando não precisamos de um id
/restaurants/top
utilizamos member quando precisamos de um id
/restaurants/:id/chef

## RESTAURANTS CONTROLLER
primeiro precisamos encontrar o restaurante!
ja temos um private metodo que faz isso pra gente. então a unica coisa que precisamos fazer é adicionar o metodo chef em nosso before action.

def chef
  @chef_name = @restaurant.chef_name
end
`chef.html.erb`

## view
<h1><%= @restaurant.name %>'s chef is <%= @chef_name %>.</h1>

## NESTED RESOURCES:
Hora de adicionar nosso reviews model, vamos ver como fazer nested resources, ou seja, aninhamento das rotas, que deverá o routing mais complexo q vcs irao fazer.... não haverá nada mais complexo que isso. Eu diria que 99% das vezes, vcs não precisarão de routing mais complexo que esse.

DB schema add review
let's generate our model

`rails g model review content:text restaurant:references`

look at migration
rails db:migrate

## SLIDE MODELS
Precisamos agora linkar nosso modelo review com nosso modelo restaurant, certo?
`class Restaurant < ApplicationRecord`
  `has_many :reviews, dependent: :destroy`
`end`

`class Review < ApplicationRecord`
  `belongs_to :restaurant`
`end`

## SLIDE ROUTING
nos vamos aninhar nosso reviews dentro do nosso restaurant. porque? porque nos precisamos do id do restaurante para deixar um review.
`resources :restaurants do`
  `resources :reviews, only: [ :new, :create ]`
`end`

Vamos ver como ficou rails routes.
Vamos criar nosso controller

## GENERATE THE CONTROLLER
rails g controller reviews

def new
  @review = Review.new
end
def create
end
vamos começar por aqui, e depois faremos o resto.
new.html.erb

Vamos usar simple form:
<%= simple_form_for @review do |f| %>
  <%= f.input :content %>
  <!-- adds bootstrap button  -->
  <%= f.submit class: 'btn btn-primary' %>
<% end %>
O que esse codigo vai gerar pra gente? Ele vai gerar um formulario e qual será o action desse formulário?
<form action="/restaurants/28/reviews/new" method="post"></form>
é isso aqui que nos queremos. Mas não é exatamente o que nosso codigo vai gerar. Percebam que eu não tenho nenhuma referencia ao meu restaurante, então de onde tiramos o id?
Eu preciso encontrar meu restaurante pra gerar esse action que nos falamos agora. Porque do jeit que esta aqui esse simple form so vai gerar isso aqui ó...
<form action="reviews" method="post"></form>
Percebam que seu eu for no meu localhost do jeito que está aqui... 
ele vai quebrar. olha o que ele ta falando:
undefined method `reviews_path' for #<#<Class:0x00007fa85003d6f8>:0x00007fa850047db0>
Did you mean?  review_path
Porque ele ta falando isso? Porque nosso codigo do jeito que está aqui vai gerar um formulário comente com a ação 'reviews'! ele vai retornar o erro: método indefinido `reviews_path` 'que é apenas /reviews porém, não temos /reviews em nossas rotas em nossas rotas temos:
/restaurants/:restaurant_id/reviews


ENTÃO, A PRIMEIRA COISA QUE PRECISAMOS FAZER É ENCONTRAR NOSSO RESTAURANTE NO NOSSO REVIEWS CONTROLLER.

Vamos criar um metodo privado:
  private

  def find_restaurant
    #na nossa rotar reviews diz :restaurant_id
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

entao:
before_action :find_restaurant

Agora podemos adicionar o restaurante na declaração do nosso simple form.
vamos passar um array [@restaurant, @review]
Agora sim noss simple form vai gerar o formulario que precisamos.
`PODEMOS INVERTER? NÃO, porque não TEMOS O PATH: reviews/review_id/restaurants` -> temos o contrario.


## VAMOS ENTÃO ESCREVER O CODIGO DO NOSSO METODO CREATE

`@review = Review.new(review_params)`

`def review_params`
  `params.require(:review).permit(:content)`
`end`

E agora, pessoal, eu posso simplesmente fazer um @review.save? Esta faltando uma informação aqui pessoal. o que esta faltando? vamos olhar nosso schema.

eu preciso associar o restaurant_id ao meu review.

Sim podemos redirectionar... onde seria interessante redirecionarmos nosso usuario? Show page do restaurante certo?
`redirect_to restaurant_path(@restaurant)`

FINAL
`@review = Review.new(review_params)`
`@review.restaurant = @restaurant`
`@review.save`
`redirect_to restaurant_path(@restaurant)`

Vamos criar um review la no rails console:
Review.create!(content: 'jfdsjfhdfhdsjh')
ele vai me retornar um erro dizendo que preciso de um restaurante.

Bom, vamos adicionar um link para review no nosso restaurant show page. Me ajuda aqui pessoal.

<%= link_to 'Leave a review', new_restaurant_review_path(@restaurant) eu preciso de um id do restaurante. %>


## SLIDE CREATE go over them
Vamos ver se esta tudo funcionando:
RESTAURANT SHOW PAGE:
COMO FAÇO PARA ITERAR SOBRE OS REVIEWS?
tenho minha instancia de restaurants (@restaurant) como faço pra listar todos os meus reviews?
porque no meu modelo restaurant tenho que restaurant has many reviews então posso chamar esse metodo.
e que tipo de objeto `@restaurant.reviews` vai me retornar pessoal?
um array!

<% @restaurant.reviews.each do |review| %>
  <p><%= review.content %></p>
  <%= link_to 'delete', review_path(review), method: :delete %>
  <hr>
<% end %>


OKAY, PERGUNTA... e se eu escrever o. ele vai aceitar?
vamos deixar tb um review em branco.

volatamos para a pagina do restaurante, não recebi nenhum feedback, o review não foi criado eu não faço ideia do que aconteceu.

COmo podemos consertar isso? Alguma idea? Com um if else statement do nosso reviews controller. Nosso create precisa verificar se nosso review foi salvo. 

vamos no console.
review = Review.new(content: 'anb', restaurant_id: 28)
review.save
review.valid?
review.errors.messages

podemos passar isso na nossa condição. podemos falar:
if @review.save:
  redirect_to restaurant_path(@restaurant)
else
  mostrar o erro no formulario. Isso é feito pelo simple form
  não precisamos fazer nada no nosso view. A unica coisa que precisamos fazer será nesse if else que vamos adicionar no controller.


## REVIEWS CONTROLLER
aqui eu vou dizer, 

if @review.save
  redirect_to restaurant_path(@restaurant)
else
  render :new
end


esta instância de avaliação é criada com erros de validação, precisamos associar nossa avaliação a um restaurante (restaurant_id) 

if @ review.save
  redirect_to restaurant_path (@restaurant)
caso contrário, permaneceremos no create action, mas exibiremos o template do new page
a única diferença é que não estou usando a "nova" instância de @review, estou
usando a instância de review que não salvou.

o simpe form lida com isso:
O render renderiza algum html, renderiza uma página, e se o @review,save falhar, ele renderizará uma nova página, e o que é esta nova página?
essencialmente meu formulario.

percebamm que meu url diz
http://localhost:3000/restaurants/7/reviews
ESTOU NO MEU CREATE.

e nao http://localhost:3000/restaurants/7/reviews/new

change Review.new in reviews show page

redirect to review `redirect_to new_restaurant_review_path(@restaurant)`

## DESTROY
alguem consegue me dizer porque o destroy não está aninhado no resources restaurants?

resources :reviews, only: [:destroy]
porque nao precisamos do id do restaurante pra deletar um review. A unica coisa que precisamos é encontrar nosso review e deletá-lo!.

Vamos então pro nosso reviews controller e escrever nosso metodo destroy.

def destroy
  <!-- # se por acaso tivessemos aninhado a rota:  -->
  <!-- @restaurant = Restaurant.find(params[:restaurant_id]) -->
  @review = Review.find(params[:id])
  @review.destroy
  <!-- # restaurant show page -->
  <!-- aqui o `@review.restaurant` eu chamo o restaurante que possui a instancia do review que eu quero apagar-->
  redirect_to restaurant_path(@review.restaurant) 
end

Vamos agora adicionar um link delete pra cada review.
RESTAURANT SHOW PAGE
## ADD LINK INSIDE REVIEW ITERATION!
<% @restaurant.reviews.each do |review| %>
  <p><%= review.content %></p>
  <!-- review_path[DELETE](review)[NEED AN ID] -->
  <!-- O DEFAULT É GET IN THIS CASE WE ARE DELETING SO WE USE METHOD DELETE -->
  <%= link_to 'delete', review_path(review), method: :delete %>
  <hr>
<% end %>

IT WILL BREAK!!!
REMEMBER TO LOOK INTO REVIEWS CONTROLLER AND except: [ destroy ]

# SHALLOW NESTING
eplain

GO TRHU SLIDES TILL THEY ARE DONE!


