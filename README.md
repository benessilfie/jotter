# Jotter API - Documentation

## API Overview

This note taking app provides two API options: a REST API and a GraphQL API. Both APIs allow users to perform CRUD operations (Create, Read, Update, Delete) on notes. The APIs also allow users to perform account-related operations such as creating a new account, logging in with existing credentials, and logging out of the current session. Users can be either an admin or regular members.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

```
ruby
rails
sqlite
```

### Setting up a development environment

#### Step 1: Clone the repository

```
git clone https://github.com/benessilfie/jotter.git
```

or with Github CLI

```
gh repo clone benessilfie/jotter
```

#### Step 2: Run Bundle install

```
bundle install
```

#### Step 3: Create and Migrate your database

```sh
rails db:create
```

```sh
rails db:migrate
```

#### Step 4: start the server

```
rails start
```

#### Step 5: Running the Tests

run this command in the project directory to run the tests

```sh
rspec
```

## Documentation

You can either go to the interactive postman documentation at `http://localhost:3000/docs` or use the api testing tool of your choice with the API documentation below.

## REST API

The REST API follows a traditional RESTful architecture and uses HTTP verbs to interact with resources. It supports the following endpoints:

### User Endpoints

- `GET /users/:id` - Get a specific user by ID
- `POST /users` - Create a new user account
- `PUT /users/:id` - Update a specific user by ID
- `DELETE /users/:id` - Delete a specific user by ID

### Notes Endpoints

- `GET /notes` - Get a list of all notes
- `POST /notes` - Create a new note
- `GET /notes/:id` - Get a specific note by ID
- `PUT /notes/:id` - Update a specific note by ID
- `DELETE /notes/:id` - Delete a specific note by ID

### Session

- `POST /auth/login` - Log in with an existing user account
- `DELETE /auth/logout` - Log out of an existing user account

### User Roles

Users can be either an admin or a regular member. Admin users have additional permissions, such as the ability to view and modify notes from all users. Regular members can only perform operations on their own notes.

You can specify a user's role during account creation by setting the `role` column to either `admin` or `member`. This allows you to grant different levels of access to different users within the app.

## GraphQL API

The GraphQL API provides a more flexible and efficient way to query and mutate data. It supports the following types and operations:

#### Types

- `Note` - represents a single note
- `User` - represents a user account
- `RoleEnum` - represents the two values `member` and `admin` to assign user roles

#### Operations

`Query`

- `Profile` - fetches the profile of the current logged in user
- `ViewNote` - fetches a specific note by ID
- `ViewNotes` - fetches a list of all notes of the current logged in user

`Mutation`

`User

- `createUser` - creates a new user account
- `updateUser` - updates an existing user account
- `deleteUser` - deletes a specific logged in user (requires `user password`)

`Note`

- `createNote` - creates a new note
- `updateNote` - updates a specific note by ID
- `deleteNote` - deletes a specific note by ID

## Data Schema

Both APIs use the same data schema to represent notes and users. The schema is as follows:

### Note Schema

```json
{
  "id": "string",
  "title": "string",
  "content": "string",
  "published": boolean,
  "userId": "string",
  "createdAt": DateTime,
  "updatedAt": DateTime
}
```

### User Schema

```json
{
  "id": "string",
  "email": "string",
  "password": "string",
  "role": Integer, // default: 1, default role is member
  "authToken": "string",
  "createdAt": DateTime,
  "updatedAt": DateTime
}
```

### Examples

#### Creating a user account (REST API)

- curl

```sh
curl --location --request POST 'http://localhost:3000/users' \
--header 'Content-Type: application/json' \
--data-raw '{
    "email": "test@hey.com",
    "password": "password",
    "role": "member"
}'
```

- httpie

```sh
http -v :3000/users email=test@hey.com password=password role=member
```

- postman

```sh
{
    "email": "test@hey.com",
    "password": "password",
    "role": "member"
}
```

#### Response

```sh
{
    "data": {
        "id": "1",
        "type": "user",
        "attributes": {
            "email": "test@hey.com",
            "role": "member",
            "created_at": "2023-05-11T21:37:43.555Z",
            "updated_at": "2023-05-11T21:37:43.555Z"
        },
        "relationships": {
            "notes": {
                "data": []
            }
        }
    }
}
```

#### Creating a user account (GraphQL)

```json
mutation {
    createUser(input: {
        email: "test@hey.com"
        password: "password"
        role: member
    }) {
        user {
            email
            role
        }
    }
}
```

#### Response

```json
{
  "data": {
    "createUser": {
      "user": {
        "email": "test@hey.com",
        "role": "member"
      }
    }
  }
}
```

## Author

[Benjamin Essilfie Quansah](https://www.github.com/benessilfie/)
