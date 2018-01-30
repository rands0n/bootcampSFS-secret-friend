# Secret Friend

This app is made to the OneBitCode Bootcamp. You can checkout my code here.

## Configuration

To build this project. Make sure you have the [Docker](https://docker.com) installed on your machine.

To build using Docker, run:

```bash
docker-compose build && docker-compose run --rm site bundle install
```

And to open up the app, run:

```bash
docker-compose up
```

### Initialization

To create our database, use `rails db:create`. After that you can migrate all the tables availables with `rails db:migrate`

## Tests

To run our tests, simply put the `rspec` command on terminal.

## Services

### Mail

In development we use [Mailcatcher](https://mailcatcher.me/). So when you open up the application the server is started on `http://localhost:1080`
