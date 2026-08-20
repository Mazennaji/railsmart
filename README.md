# railsmart

A full-stack e-commerce store built with Ruby on Rails 8 and PostgreSQL — product catalog, categories, a session-based shopping cart, and checkout with order management. Built as a portfolio project to demonstrate clean Rails architecture end to end.

---

## Overview

railsmart is a working online storefront. Visitors browse products by category, add them to a cart that persists across a session, and place an order that is recorded with line items and a computed total. The codebase favors the conventional Rails approach — fat-free controllers, expressive models, and Hotwire for interactivity — so it reads clearly and stays easy to extend.

## Tech stack

| Layer | Choice |
|---|---|
| Language | Ruby 3.2+ |
| Framework | Rails 8.1 |
| Database | PostgreSQL |
| Front end | Hotwire (Turbo + Stimulus), Propshaft |
| Server | Puma |
| Testing | Minitest, Capybara |

## Features

- **Product catalog** — products organized into categories, with price and live stock tracking.
- **Category browsing** — filter the catalog down to a single category.
- **Product detail pages** — full description, price, and availability.
- **Shopping cart** — session-based; add, update quantities, and remove items without an account.
- **Checkout** — captures customer details and converts the cart into a persisted order.
- **Order management** — each order stores its line items and a server-computed total, with a status lifecycle (`pending → paid → shipped`, or `cancelled`).
- **Stock safety** — orders validate against available inventory.

## Data model

```
Category ──< Product ──< OrderItem >── Order
```

- A **Category** has many **Products**.
- A **Product** has many **OrderItems**.
- An **Order** has many **OrderItems**, and many **Products** through them.
- An **OrderItem** records the quantity and the price captured at the time of purchase, so historical orders stay accurate even if a product's price changes later.

## Getting started

### Prerequisites

- Ruby 3.2 or newer
- PostgreSQL 14 or newer
- Bundler (`gem install bundler`)

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/railsmart.git
cd railsmart

# 2. Install dependencies
bundle install

# 3. Configure the database password (see below), then:
rails db:create
rails db:migrate
rails db:seed

# 4. Start the server
rails server
```

Visit **http://localhost:3000**.

### Database configuration

The app reads the PostgreSQL password from an environment variable rather than committing it. Set it before running any `rails` command:

```bash
# macOS / Linux
export DATABASE_PASSWORD="your_postgres_password"

# Windows (PowerShell)
$env:DATABASE_PASSWORD="your_postgres_password"
```

`config/database.yml` picks this up automatically.

## Seed data

`rails db:seed` loads a set of sample categories and products so the store is populated on first run. Re-running it is safe — it clears and reloads the sample set.

## Testing

```bash
rails test
```

## Project structure

```
app/
  models/          Category, Product, Order, OrderItem
  controllers/     Products, Categories, Cart, Orders
  views/           Storefront templates
  assets/          Styles and images
config/
  routes.rb        Application routes
  database.yml     PostgreSQL configuration
db/
  migrate/         Schema migrations
  seeds.rb         Sample catalog data
```

## Roadmap

Ideas for extending the project:

- User accounts and authentication
- Admin dashboard for managing inventory
- Payment integration (Stripe)
- Product images via Active Storage
- Search and filtering

## License

Released under the MIT License. See [`LICENSE`](LICENSE) for details.