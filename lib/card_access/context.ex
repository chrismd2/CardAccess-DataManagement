defmodule Context do
  import Ecto.Query
  alias CardAccess.Repo
  alias CardAccess.CardHolders
  alias CardAccess.Members

  def duplicate_card_number do
    Repo.all(query_for_duplicate_card_number())
  end
  defp query_for_duplicate_card_number do
    require Ecto

    from c1 in CardHolders,
      join: c2 in CardHolders,
        on:  c1.card_number == c2.card_number and
             c1.id < c2.id and
            (c1.first_name != c2.first_name or
             c1.last_name != c2.last_name),
    select: {c1.card_number, c1.last_name, c2.last_name}
  end

  def update_card_holder_emails([]) do
    IO.write("done\n")
  end
  def update_card_holder_emails([card_holder|list]) do
    email = elem(card_holder, 0)
    card_number = elem(card_holder, 1)
    q = from c in CardHolders,
        where: c.card_number == ^(card_number),
        select: c.id
    results = Repo.all(q)
    if(length(results) == 1) do
      Repo.get_by!(CardHolders, card_number: card_number)
        |> Ecto.Changeset.change(email: email)
        |> Repo.update
    else
      IO.write("There's a card holder conflict")
    end
    update_card_holder_emails(list)
  end


  def query_join_members_and_card_holders_on_names do
    require Ecto
    q = from c in CardHolders,
        join: m in Members,
          on: c.first_name == m.first_name and
              c.middle_name == m.middle_name and
              c.last_name == m.last_name and
              m.email != ^(""),
        select: {m.email, c.card_number}
    q
  end
  def join_members_and_card_holders_on_names do
    q = query_join_members_and_card_holders_on_names
    Repo.all(q)
  end

  def query_exclude_card_holders_with_email do
    require Ecto
    q = from c in CardHolders,
        join: m in Members,
          on: c.first_name == m.first_name and
              c.middle_name == m.middle_name and
              c.last_name == m.last_name and
              m.email != ^("") and
              c.email == ^(""),
        select: {m.email, c.card_number}
    q
  end
  def exclude_card_holders_with_email do
    Repo.all(query_exclude_card_holders_with_email())
  end

  def card_holders_without_email do
    q = from m in CardAccess.CardHolders, where: like(m.email, ^(""))
    Repo.all(q)
  end

  def members_without_email do
    q = from m in CardAccess.Members, where: like(m.email, ^(""))
    Repo.all(q)
  end

  def card_holders_list do
    Repo.all(from e in CardHolders)
  end
  def add_card_holder() do
    IO.write("Parameters to add a new card holder are\n")
    IO.write("\tfirst_name, middle_name, last_name, email,\n\taccess_group, card_number, imprint, card_status,\n\tnotes\n")
    IO.write("Note: email, card_number, imprint, and card_status are required")
  end
  def add_card_holder(first_name, middle_name, last_name, email,
                      access_group, card_number, imprint, card_status,
                      notes) do
    Repo.insert!(%CardHolders{
      first_name: first_name,
      middle_name: middle_name,
      last_name: last_name,
      email: email,

      access_group: access_group,
      card_number: card_number,
      imprint: imprint,
      card_status: card_status,

      notes: notes
    })
  end

  def members_list do
    Repo.all(from e in Members)
  end
  def add_member() do
    IO.write("Parameters to add a new card holder are\n")
    IO.write("\tfirst_name, middle_name, last_name, email,\n\tactive, resident, staff, resident_name,\n\tslack_handle")
    IO.write("Note: email and active are required")
  end
  def add_member(first_name, middle_name, last_name, email,
                 active, resident, staff, resident_name,
                 slack_handle) do
    Repo.insert!(%Members{
      first_name: first_name,
      middle_name: middle_name,
      last_name: last_name,
      email: email,

      active: active,
      resident: resident,
      staff: staff,
      resident_name: resident_name,

      slack_handle: slack_handle
    })
  end
end
