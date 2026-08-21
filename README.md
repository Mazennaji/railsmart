# railsmart

A full-stack e-commerce store built with Ruby on Rails 8 and PostgreSQL — product catalog, user accounts, a session-based shopping cart, checkout with order management, an admin back office, product image uploads, and catalog search. Built as a portfolio project to demonstrate clean Rails architecture end to end.

<p>
  <img src="https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white" alt="Ruby">
  <img src="https://img.shields.io/badge/Rails-D30001?style=for-the-badge&logo=rubyonrails&logoColor=white" alt="Rails">
  <img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/Hotwire-FF4785?style=for-the-badge&logo=hotwire&logoColor=white" alt="Hotwire">
  <img src="https://img.shields.io/badge/Puma-2C2C2C?style=for-the-badge&logo=puma&logoColor=white" alt="Puma">
</p>

---

## Overview

railsmart is a working online storefront. Visitors browse and search a product catalog, create an account, add items to a session cart, and place an order that is recorded with line items and a computed total. Administrators sign in to a separate back office to manage products, categories, inventory, and order status, and to upload product images. The codebase favors the conventional Rails approach — lean controllers, expressive models with chainable scopes, and Hotwire for interactivity — so it reads clearly and stays easy to extend.

## Tech stack

| Layer | Choice |
|---|---|
| Language | Ruby 3.2+ |
| Framework | Rails 8.1 |
| Database | PostgreSQL |
| Authentication | `has_secure_password` (bcrypt) |
| File storage | Active Storage |
| Front end | Hotwire (Turbo + Stimulus), Propshaft |
| Server | Puma |
| Testing | Minitest, Capybara |

## Features

### Storefront
- **Product catalog** — products organized into categories, with price and live stock tracking.
- **Search, filter & sort** — search by name, filter by category and price range, and sort by name, price, or newest. All filter state lives in the URL, so results are shareable and bookmarkable.
- **Category browsing** — narrow the catalog to a single category.
- **Product detail pages** — full description, price, availability, and product image.
- **Shopping cart** — session-based; add, update quantities, and remove items.
- **Checkout** — requires a logged-in account; captures customer details and converts the cart into a persisted order tied to the user.
- **Order confirmation** — a receipt page with line items and total.

### Accounts
- **Sign up & log in** — email and password authentication built on `has_secure_password`, no external auth gem.
- **Gated checkout** — orders belong to a user; checkout redirects guests to log in.

### Admin back office
- **Protected `/admin` namespace** — reachable only by users with an admin flag; non-admins are turned away.
- **Dashboard** — product, category, order, and revenue counts, plus recent orders and low-stock alerts.
- **Product & category management** — full create, edit, and delete.
- **Product images** — upload images via Active Storage, shown across the storefront with a graceful fallback for products without one.
- **Order management** — review any order and advance its status through the lifecycle (`pending → paid → shipped`, or `cancelled`).

### Under the hood
- **Stock safety** — orders validate against available inventory and decrement stock within a database transaction, so a failed order rolls back cleanly.
- **Price capture** — each order item records the price at the time of purchase, so historical orders stay accurate even if a product's price changes later.

## Data model

```
User ──< Order ──< OrderItem >── Product >── Category
```

- A **User** has many **Orders**.
- A **Category** has many **Products**.
- A **Product** has many **OrderItems** and has one attached image.
- An **Order** belongs to a **User**, has many **OrderItems**, and many **Products** through them.
- An **OrderItem** records the quantity and the price captured at purchase time.

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

`rails db:seed` loads sample categories, products, and an admin account so the store is populated on first run. Re-running it is safe — it clears and reloads the sample set.

Default admin credentials (change these before deploying anywhere public):

```
Email:    admin@railsmart.test
Password: password123
```

## Testing

```bash
rails test
```

## Project structure

```
app/
  models/              User, Category, Product, Order, OrderItem
  controllers/         Products, Categories, Carts, Orders, Users, Sessions
    admin/             Dashboard, Products, Categories, Orders (protected)
    concerns/          CurrentCart (session cart logic)
  views/               Storefront and admin templates
  assets/stylesheets/  application.css (storefront), admin.css (back office)
config/
  routes.rb            Application routes
  database.yml         PostgreSQL configuration
db/
  migrate/             Schema migrations
  seeds.rb             Sample catalog and admin data
```

## Roadmap

Ideas for extending the project:

- Order history for logged-in users
- Pagination for the catalog and admin lists
- Payment integration (Stripe)
- Automated test coverage across models and controllers
- Image variants via libvips for faster-loading thumbnails

## License

Released under the MIT License. See [`LICENSE`](LICENSE) for details.