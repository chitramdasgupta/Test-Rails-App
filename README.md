# Requirements

This has been tested with the following:

1. Ruby 3.1.2
2. Rails 7.1.3

It is highly recommended that you use the above versions

# How to run this app?

Firstly clone the repository:

```sh
git clone https://github.com/chitramdasgupta/Test-Rails-App.git
```

Then `cd` into the directory:

```sh
cd Test-Rails-App/
```

Then you need to install the dependencies:

```sh
bundle install
```

And set up the database:

```sh
rails db:create
```

```sh
rails db:migrate
```

And also seed the database so that the sample data is available in the application:

```sh
rails db:seed
```

Finally run the server:

```sh
rails server
```

Then, open `http://localhost:3000/` in your web browser
