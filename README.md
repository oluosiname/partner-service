# Partner Matching API

This is the Partner Matching API, which provides a list of partners based on their experience with specific materials and their proximity to a given location. This API is versioned to allow for future updates without breaking existing clients.

## Table of Contents

- [Introduction](#introduction)
- [API Documentation](#api-documentation)
- [Setup Instructions](#setup-instructions)
- [Versioning](#versioning)
- [Authentication](#authentication)
- [Contributing](#contributing)
- [License](#license)

## Introduction

The Partner Matching API helps clients find partners who have experience with specific materials and are located within a certain radius of a given location. The API returns partners sorted by rating and distance.

## Setup Instructions

### Prerequisites

- Ruby 3.3.0
- Rails 7.1.4
- PostgreSQL (Postgis)

### Installation

#### Clone the Repository:

```bash
git clone git@github.com:oluosiname/partner-service.git
```

```bash
cd partner-service
```

#### Install Dependencies:

```bash
bundle install
```

#### Setup the Database:

```bash
rails db:create
rails db:migrate
```

### Run the Server:

```bash
rails s
```

### Running Tests

```bash
bundle exec rspec
```

## API Documentation

### GET `/api/v1/partners`

- **Description:** Retrieves a list of partners that match the specified criteria.
- **Parameters:**
  - `material` (required): The material the partner should have experience with.
  - `lat` (required): The latitude of the customer's location.
  - `lon` (required): The longitude of the customer's location.
  - `square_meters` (optional): The size of the project in square meters.
  - `phone_number` (optional): The customer's phone number for contact purposes.
- **Responses:**
  - **200 OK**: A list of matching partners.
  - **400 Bad Request**: Returned if required parameters are missing or invalid.
- **Example Request:**
  ```bash
  curl -X GET "http://localhost:3000/api/v1/partners?material=wood&lat=40.7128&lon=-74.0060"
  ```
  Full API documentation on [API Documentation](http://localhost:3000/api-docs/index.html)
