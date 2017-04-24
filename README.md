# Shippo

## Motivation

While you _can_ use the Shippo API today by just using an HTTP client, you would be
adding more complexity to your application without any real benefit. Plug this library
in and spend your time doing what matters: making sure your application is as good as it can be.

## Goal

My goal in creating this library is to build an ergonomic and extensible way to access the Shippo API.
 
## Design

This library is intended to be developed as an OTP application built on top of
HTTPoison.

It will contain structs for all of the api objects and will eventually cover all of the api methods.

## Installation

This package can be installed by adding `shippo_client` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:shippo_client, "~> 0.1.0"}]
end
```

## Configuration

In order to access the Shippo API, you must supply your secret token in one of two ways:

1. By setting the `SHIPPO_SECRET` environment variable, or:
2. By adding the following line to your configuration:
```elixir
config :your_app, :shippo_client,
  secret_key: __YOUR SECRET KEY__
```
