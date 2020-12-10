# CardAccess

Description: Relate, and identify issues with that relationship, the guild roster and Keri card holders using Elixir to load and manage a Postgres database.

## Installation
Create the database
  mix ecto.create
Create tables with fields
  mix ecto.migrate
  
## Usage
Run the interactive elixir machine
  iex -S mix
Read and load the data
  CardAccess.setup
Write issues with the relationship
  CardAccess.write_output

### Understanding the output
File names should be describe the relationship/issue they capture.  For example members_with_out_email.csv lists the users who don't have emails in the members.csv which is needed for relating members to card holders.  Another example is conflicting_card_numbers.csv which shows the card holders that share the same card number.
  

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `card_access` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:card_access, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/card_access](https://hexdocs.pm/card_access).

