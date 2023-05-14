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

### Setting up locally

#### Step 1: Clone the repository

```
git clone https://github.com/benessilfie/jotter.git
```

or with Github CLI

```
gh repo clone benessilfie/jotter
```

#### Step 2: Install gems

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
rails server
```

#### Step 5: Running the Tests

run this command in the project directory to run the tests

```sh
rspec
```

## Documentation

## REST API

The REST API follows a traditional RESTful architecture and uses HTTP verbs to interact with resources. It supports the following endpoints:

### User Endpoints

##### 1. Get User

- `GET /users/:id` - Get a specific user by ID

- `Headers` - `{Authorization: 'Bearer <token>'}`

**Response**

`200 - OK`

```json
{
  "data": {
    "id": "integer",
    "type": "string",
    "attributes": {
      "email": "string",
      "role": "string",
      "created_at": "dateTime",
      "updated_at": "dateTime"
    },
    "relationships": {
      "notes": {
        "data": []
      }
    }
  },
  "included": []
}
```

##### 2. Create User

- `POST /users` - Create a new user account

**Request Body**

```json
{
  "email": "string",
  "password": "string",
  "role": "string"
}
```

**Response**

`201 - Created`

```json
{
  "data": {
    "id": "integer",
    "type": "string",
    "attributes": {
      "email": "string",
      "role": "string",
      "created_at": "dateTime",
      "updated_at": "dateTime"
    },
    "relationships": {
      "notes": {
        "data": []
      }
    }
  }
}
```

##### 3. Update User

- `PUT /users/:id` - Update a specific user by ID

- `Headers` - `{Authorization: 'Bearer <token>'}`

**Request Body**

```json
{
  "email": "string",
  "role": "string"
}
```

**Response**

`200 - OK`

```json
{
  "data": {
    "id": "integer",
    "type": "string",
    "attributes": {
      "email": "string",
      "role": "string",
      "created_at": "dateTime",
      "updated_at": "dateTime"
    },
    "relationships": {
      "notes": {
        "data": []
      }
    }
  }
}
```

- `DELETE /users/:id` - Delete a specific user by ID

##### 4. Delete User

- `PUT /users/:id` - Update a specific user by ID

- `Headers` - `{Authorization: 'Bearer <token>'}`

**Response**

`204 - No Content`

### Notes Endpoints

##### 1. Get All Notes

- `GET /notes` - Get a list of all notes

- `Headers` - `{Authorization: 'Bearer <token>'}`

**Response** (with at least a note, otherwise an empty array `[]`)

`200 - OK`

```json
{
    "data": [
        {
            "id": "integer",
            "type": "string",
            "attributes": {
                "title": "string",
                "content": "string",
                "published": boolean,
                "created_at": "dateTime",
                "updated_at": "dateTime"
            },
            "relationships": {
                "user": {
                    "data": {
                        "id": "integer",
                        "type": "string"
                    }
                }
            }
        }
    ]
}
```

##### 2. Create Note

- `POST /notes` - Create a new note

- `Headers` - `{Authorization: 'Bearer <token>'}`

**Request Body**

```json
{
    "title": "string",
    "content": "string",
    "published": boolean

}
```

**Response**

`201 - Created`

```json
{
    "data": [
        {
            "id": "integer",
            "type": "string",
            "attributes": {
                "title": "string",
                "content": "string",
                "published": boolean,
                "created_at": "dateTime",
                "updated_at": "dateTime"
            },
            "relationships": {
                "user": {
                    "data": {
                        "id": "integer",
                        "type": "string"
                    }
                }
            }
        }
    ]
}
```

##### 3. Get Note

- `GET /notes/:id` - Get a specific note by ID

- `Headers` - `{Authorization: 'Bearer <token>'}`

**Response** (with at least a note, otherwise `404 Not Found`)

`200 - OK`

```json
{
    "data": [
        {
            "id": "integer",
            "type": "string",
            "attributes": {
                "title": "string",
                "content": "string",
                "published": boolean,
                "created_at": "dateTime",
                "updated_at": "dateTime"
            },
            "relationships": {
                "user": {
                    "data": {
                        "id": "integer",
                        "type": "string"
                    }
                }
            }
        }
    ]
}
```

##### 4. Update Note

- `PUT /notes/:id` - Update a specific note by ID

- `Headers` - `{Authorization: 'Bearer <token>'}`

**Request Body**

```json
{
    "title": "string",
    "content": "string",
    "published": boolean

}
```

**Response**

`200 - OK`

```json
{
    "data": [
        {
            "id": "integer",
            "type": "string",
            "attributes": {
                "title": "string",
                "content": "string",
                "published": boolean,
                "created_at": "dateTime",
                "updated_at": "dateTime"
            },
            "relationships": {
                "user": {
                    "data": {
                        "id": "integer",
                        "type": "string"
                    }
                }
            }
        }
    ]
}
```

##### 5. Delete Note

- `DELETE /notes/:id` - Delete a specific note by ID

- `Headers` - `{Authorization: 'Bearer <token>'}`

**Response**
`204 - No Content`

### Session

##### 1. Login

- `POST /auth/login` - Log in with an existing user account

**Request Body**

```json
{
  "email": "string",
  "password": "string"
}
```

**Response**
`200 - OK`

```json
{
  "token": "JWT Token"
}
```

##### 2. Logout

- `DELETE /auth/logout` - Log out of an existing user account

- `Headers` - `{Authorization: 'Bearer <token>'}`

**Response**
`204 - No Content`

### User Roles

Users can be either an admin or a regular member. Admin users have additional permissions, such as the ability to view and modify notes from all users. Regular members can only perform operations on their own notes.

You can specify a user's role during account creation by setting the `role` column to either `admin` or `member`. This allows you to grant different levels of access to different users within the app.

## GraphQL API

The GraphQL API provides a more flexible and efficient way to query and mutate data. It supports the following types and operations:

### Types

- `Note` - represents a single note
- `User` - represents a user account
- `RoleEnum` - `member` or `admin`, represents the two roles a user can be assigned

### Operations

#### `Query`

##### 1. Fetch User Profile

- `Profile` - fetches the profile of the current logged in user

**Request Body**

- `Headers` - `{Authorization: '<token>'}`

```json
query {
  profile {
    id
    email
    role
    createdAt
    updatedAt
  }
}
```

**Response**

`200 - OK`

```json
{
    "data": {
        "profile": {
            "id": "integer",
            "email": "string",
            "role": roleEnum,
            "createdAt": "dateTime",
            "updatedAt": "dateTime"
        }
    }
}
```

##### 2. View Note

- `ViewNote` - fetches a specific note by ID

**Request Body**

- `Headers` - `{Authorization: '<token>'}`

```json
query {
    viewNote(id: integer) {
        id
        title
        content
        published
        user {
            email
            role
        }
    }
}
```

**Response**

`200 - OK`

```json
{
    "data": {
        "viewNote": {
            "id": integer,
            "title": "string",
            "content": "string",
            "published": boolean,
            "user": {
                "email": "string",
                "role": roleEnum
            }
        }
    }
}
```

##### 2. View All Notes

- `ViewNotes` - fetches a list of all notes of the current logged in user

**Request Body**

- `Headers` - `{Authorization: '<token>'}`

```json
query {
    viewNotes {
        id
        title
        content
        published
        user {
            email
            role
        }
    }
}
```

**Response**

`200 - OK`

```json
{
    "data": {
        "viewNotes": [
            {
                "id": integer,
                "title": "string",
                "content": "string",
                "published": boolean,
                "user": {
                    "email": "string",
                    "role": roleEnum
                }
            }
        ]
    }
}
```

### `Mutation`

#### `User

##### 1. Create User

- `createUser` - creates a new user account

**Request Body**

```json
mutation {
    createUser(input: {
        email: "string"
        password: "string"
        role: roleEnum
    }) {
        user {
            email
            role
        }
    }
}
```

**Response**

`200 - OK`

```json
{
    "data": {
        "createUser": {
            "user": {
                "email": "string",
                "role": roleEnum
            }
        }
    }
}
```

##### 2. Update User

- `updateUser` - updates an existing user account

- `Headers` - `{Authorization: '<token>'}`

**Request Body**

```json
mutation {
    updateUser(input: {
        email: "string"
        role: roleEnum
    }) {
        user {
            email
            role
        }
    }
}
```

**Response**

`200 - OK`

```json
{
    "data": {
        "createUser": {
            "user": {
                "email": "string",
                "role": roleEnum
            }
        }
    }
}
```

##### 3. Delete User

- `deleteUser` - deletes a specific logged in user (requires `user password`)

- `Headers` - `{Authorization: '<token>'}`

**Request Body**

```json
mutation {
    deleteUser(input: {
        password: "string"
    }) {
        message
    }
}
```

**Response**

`200 - OK`

```json
{
  "data": {
    "deleteUser": {
      "message": "string"
    }
  }
}
```

#### `Note`

##### 1. Create Note

- `createNote` - creates a new note

- `Headers` - `{Authorization: '<token>'}`

**Request Body**

```json
mutation {
    createNote(input: {
        title: "string"
        content: "string"
        published: boolean
    }) {
        note {
            title
            content
            published
            user {
                id
                email
                role
            }
        }
    }
}
```

**Response**

`200 - OK`

```json
{
    "data": {
        "createNote": {
            "note": {
                "title": "string",
                "content": "string",
                "published": boolean,
                "user": {
                    "id": "integer",
                    "email": "string",
                    "role": roleEnum
                }
            }
        }
    }
}
```

##### 2. Update Note

- `updateNote` - updates a specific note by ID

- `Headers` - `{Authorization: '<token>'}`

**Request Body**

```json
mutation {
    updateNote(input: {
        id: integer
        title: "string"
        content: "string"
        published: boolean
    }) {
        note {
            title
            content
            published
            user {
                id
                email
                role
            }
        }
    }
}
```

**Response**

`200 - OK`

```json
{
    "data": {
        "updateNote": {
            "note": {
                "title": "string",
                "content": "string",
                "published": boolean,
                "user": {
                    "id": "integer",
                    "email": "string",
                    "role": roleEnum
                }
            }
        }
    }
}
```

##### 3. Delete Note

- `deleteNote` - deletes a specific note by ID

- `Headers` - `{Authorization: '<token>'}`

**Request Body**

```json
mutation {
    deleteNote(input: {
        id: note
    }) {
        message
    }
}
```

**Response**

`200 - OK`

```json
{
  "data": {
    "deleteNote": {
      "message": "string"
    }
  }
}
```

## Data Schema

Both APIs use the same data schema to represent notes and users. The schema is as follows:

### Note Schema

```json
{
  "id": "string",
  "title": "string",
  "content": "string",
  "published": boolean,
  "userId": integer,
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
  "role": integer, // default: 1, default role is member
  "authToken": "string",
  "createdAt": DateTime,
  "updatedAt": DateTime
}
```

### Example

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
