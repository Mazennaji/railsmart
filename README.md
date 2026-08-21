<p align="center">
  <img src="app/assets/images/logo.png" alt="railsmart" width="380">
</p>

<h1 align="center">railsmart</h1>

<p align="center">
  A full-stack e-commerce store built with Ruby on Rails 8 and PostgreSQL. Product catalog with search, user accounts, a session-based shopping cart, Stripe checkout, an admin back office, and product image uploads. Built as a portfolio project to demonstrate clean Rails architecture end to end.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white" alt="Ruby">
  <img src="https://img.shields.io/badge/Rails-D30001?style=for-the-badge&logo=rubyonrails&logoColor=white" alt="Rails">
  <img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/Stripe-635BFF?style=for-the-badge&logo=stripe&logoColor=white" alt="Stripe">
  <img src="https://img.shields.io/badge/Hotwire-FF4785?style=for-the-badge&logo=hotwire&logoColor=white" alt="Hotwire">
</p>

---

## Overview

railsmart is a working online storefront. Visitors browse and search a product catalog, create an account, add items to a session cart, and pay by card through Stripe Checkout. Administrators sign in to a separate back office to manage products, categories, inventory, and order status, and to upload product images. The codebase favors the conventional Rails approach — lean controllers, expressive models with chainable scopes, and Hotwire for interactivity — so it reads clearly and stays easy to extend.

## Tech stack

| Layer | Choice |
|---|---|
| Language | Ruby 3.2+ |
| Framework | Rails 8.1 |
| Database | PostgreSQL |
| Authentication | `has_secure_password` (bcrypt) |
| Payments | Stripe Checkout |
| File storage | Active Storage |
| Front end | Hotwire (Turbo + Stimulus), Propshaft |
| Server | Puma |
| Testing | Minitest |

## Features

### Storefront
- **Product catalog** — products organized into categories, with price and live stock tracking.
- **Search, filter & sort** — search by name, filter by category and price range, and sort by name, price, or newest. All filter state lives in the URL, so results are shareable and bookmarkable.
- **Category browsing** — narrow the catalog to a single category.
- **Product detail pages** — full description, price, availability, and product image.
- **Shopping cart** — session-based; add, update quantities, and remove items.
- **Stripe checkout** — requires a logged-in account; card payment is handled on Stripe's hosted page, so card details never touch the server.
- **Order confirmation** — a receipt page with line items, total, and payment date.

### Accounts
- **Sign up & log in** — email and password authentication built on `has_secure_password`, no external auth gem.
- **Order history** — logged-in users can review all of their past orders.
- **Gated checkout** — orders belong to a user; checkout redirects guests to log in.

### Admin back office
- **Protected `/admin` namespace** — reachable only by users with an admin flag; non-admins are turned away.
- **Dashboard** — product, category, order, and revenue counts, plus recent orders and low-stock alerts.
- **Product & category management** — full create, edit, and delete, with pagination.
- **Product images** — upload images via Active Storage, resized into variants with libvips and shown across the storefront with a graceful fallback for products without one.
- **Order management** — review any order and advance its status through the lifecycle (`pending → paid → shipped`, or `cancelled`).

### Under the hood
- **Stock safety** — stock is decremented only after payment is confirmed, inside a database transaction, so abandoned payments never lock up inventory.
- **Verified payments** — the success path re-checks payment status directly with Stripe rather than trusting the redirect.
- **Price capture** — each order item records the price at the time of purchase, so historical orders stay accurate even if a product's price changes later.
- **Test coverage** — model and controller tests across products, orders, users, cart, and admin authorization.

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
- libvips (for image variants)
- A Stripe account (test mode is free)
- Bundler (`gem install bundler`)

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/railsmart.git
cd railsmart

# 2. Install dependencies
bundle install

# 3. Configure environment variables (see below), then:
rails db:create
rails db:migrate
rails db:seed

# 4. Start the server
rails server
```

Visit **http://localhost:3000**.

### Environment variables

The app reads secrets from the environment rather than committing them. Set these before running the app (or place them in a gitignored `.env` file if using dotenv):

```bash
DATABASE_PASSWORD=your_postgres_password
STRIPE_SECRET_KEY=sk_test_your_key
STRIPE_PUBLISHABLE_KEY=pk_test_your_key
```

Stripe test keys are available in your Stripe dashboard under Developers → API keys.

## Seed data

`rails db:seed` loads sample categories, products, and an admin account so the store is populated on first run. Re-running it is safe — it clears and reloads the sample set.

Default admin credentials (change these before deploying anywhere public):

```
Email:    admin@railsmart.test
Password: password123
```

## Payments

Checkout uses Stripe Checkout in test mode. Use Stripe's test card to simulate a successful payment:

```
Card:   4242 4242 4242 4242
Expiry: any future date
CVC:    any 3 digits
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
  assets/              Stylesheets, logo, and favicon
config/
  routes.rb            Application routes
  database.yml         PostgreSQL configuration
  initializers/        Stripe and Pagy configuration
db/
  migrate/             Schema migrations
  seeds.rb             Sample catalog and admin data
test/                  Model and controller tests
```

## Roadmap

Ideas for extending the project:

- Email receipts on successful payment
- Stripe webhooks for asynchronous payment confirmation
- Product reviews and ratings
- Wishlists for logged-in users
- Discount codes and promotions

## License

Released under the MIT License. See [`LICENSE`](LICENSE) for details.