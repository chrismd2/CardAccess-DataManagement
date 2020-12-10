defmodule CardAccess.CardHolders do
  use Ecto.Schema

  schema "card_holders" do
    field :first_name, :string
    field :middle_name, :string
    field :last_name, :string
    field :email, :string

    field :access_group, :string
    field :card_number, :string
    field :imprint, :string
    field :card_status, :string

    field :notes, :string
  end
end
