defmodule CardAccess.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :first_name, :string
      add :middle_name, :string
      add :last_name, :string
      add :email, :string

      add :active, :string
      add :resident, :string
      add :staff, :string
      add :resident_name, :string

      add :slack_handle, :string
    end
  end
end
