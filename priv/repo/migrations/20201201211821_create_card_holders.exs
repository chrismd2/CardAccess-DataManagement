defmodule CardAccess.Repo.Migrations.CreateCardHolders do
  use Ecto.Migration

  def change do
    create table(:card_holders) do
      add :first_name, :string
      add :middle_name, :string
      add :last_name, :string
      add :email, :string

      add :access_group, :string
      add :card_number, :string
      add :imprint, :string
      add :card_status, :string

      add :notes, :string
    end
  end
end
