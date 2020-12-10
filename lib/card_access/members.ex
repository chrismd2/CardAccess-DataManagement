defmodule CardAccess.Members do
  use Ecto.Schema

  schema "members" do
    field :first_name, :string
    field :middle_name, :string
    field :last_name, :string
    field :email, :string

    field :active, :string
    field :resident, :string
    field :staff, :string
    field :resident_name, :string

    field :slack_handle, :string
  end
end
