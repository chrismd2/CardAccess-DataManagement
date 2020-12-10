defmodule CardAccess do
  def emails_for_card_holders do
    #join_members_and_card_holders_on_names
  end

  def exclude_card_holders_with_email([]) do
    "EOF"
  end
  def exclude_card_holders_with_email([row|list]) do
    "#{elem(row, 0)},#{elem(row, 1)}\n" <> exclude_card_holders_with_email(list)
  end
  def exclude_card_holders_with_email do
    Context.exclude_card_holders_with_email
      |> exclude_card_holders_with_email
  end

  def duplicate_card_numbers([]) do
    "EOF\n"
  end
  def duplicate_card_numbers([conflict|tail]) do
    #"#{elem(conflict, 1)} and #{elem(conflict, 2)} share card number: #{elem(conflict, 0)}\n" <> duplicate_card_numbers(tail)
    "#{elem(conflict, 1)},#{elem(conflict, 2)},#{elem(conflict, 0)}\n" <> duplicate_card_numbers(tail)
  end
  def duplicate_card_numbers do
    Context.duplicate_card_number()
    #|> Enum.each(fn m -> IO.write("#{elem(m, 1)} and #{elem(m, 2)} share card number: #{elem(m, 0)}") end)
      |> duplicate_card_numbers()
  end

  def card_holders_without_email do
    Context.card_holders_without_email
      |> card_holders_without_email
  end
  def card_holders_without_email([card_holder|list]) do
    "#{card_holder.first_name},#{card_holder.middle_name},#{card_holder.last_name},#{card_holder.card_number}\n" <> card_holders_without_email(list)
  end
  def card_holders_without_email([]) do
    "EOF\n"
  end

  def associate_names_to_emails_text([]) do
    "EOF\n"
  end
  def associate_names_to_emails_text([member|list]) do
    "#{elem(member, 0)},#{elem(member,1)}\n#{associate_names_to_emails_text(list)}"
  end
  def associate_names_to_emails_text do
    associate_names_to_emails()
      |> associate_names_to_emails_text
  end
  def associate_names_to_emails do
    relationship = Context.join_members_and_card_holders_on_names
      |> associate_names_to_emails
    Context.update_card_holder_emails(relationship)
    relationship
  end
  def associate_names_to_emails([]) do
    #IO.write("done\n")
    []
  end
  def associate_names_to_emails([member|list]) do
    [member|associate_names_to_emails(list)]
  end
  def members_without_email do
    #find members with out emails in database
    Context.members_without_email
      |> members_without_email
  end
  def members_without_email([]) do
    "EOF"
  end
  def members_without_email([member|list]) do
    str = "#{member.first_name},#{member.last_name},#{member.slack_handle}\n"
    str <> members_without_email(list)
  end

  def csv_read_header(filename) do
    #get the csv
    [str] = File.stream!(filename)
      #|> Stream.drop(1)
      #|> CSV.decode(headers: [])
      |> Enum.take(1)
    str |> scrub
      |> String.split(",")
  end
  def process_csv(filename) do
    header = csv_read_header(filename)
    File.stream!(filename)
      |> Stream.drop(1)
      |> CSV.decode(headers: header)
  end
  defp add_all_card_holders do
    process_csv("../Data/card_holders.csv")
      |> Enum.each(
        fn {:ok, aCard_holder} -> Context.add_card_holder(
          data_fetcher(aCard_holder, "First Name"),
          data_fetcher(aCard_holder, "Middle Name"),
          data_fetcher(aCard_holder, "Last Name"),
          data_fetcher(aCard_holder, "Home Email"),
          data_fetcher(aCard_holder, "Access Group"),
          data_fetcher(aCard_holder, "Cardnumber"),
          data_fetcher(aCard_holder, "Imprint"),
          data_fetcher(aCard_holder, "Card Status"),
          ""
        )
      end)
  end
  defp add_all_members do
    process_csv("../Data/members.csv")
      |> Enum.each(
        fn {:ok, aMember} -> Context.add_member(
          data_fetcher(aMember, "First Name"),
          "",
          data_fetcher(aMember, "Last Name"),
          data_fetcher(aMember, "Email Membership"),
          data_fetcher(aMember, "Active"),
          data_fetcher(aMember, "Resident"),
          data_fetcher(aMember, "Staff"),
          data_fetcher(aMember, "Resident Name"),
          data_fetcher(aMember, "Slack Handle")
        )
      end)
  end
  def first_and_last(member_map) do
    first = data_fetcher(member_map, "First Name")
    last = data_fetcher(member_map, "Last Name")

    "#{first} #{last}"
  end
  def data_fetcher(aMap, aKey) do
    {:ok, data} = Map.fetch(aMap, aKey)
    data
  end
  def scrub(data) do
    String.trim_trailing(data, "\n")
      |> String.trim_trailing( " " )
      |> String.trim_leading(  "\n")
      |> String.trim_leading(  " " )
      |> String.trim(      "\uFEFF")
  end
  def setup do
    add_all_members()
    add_all_card_holders()
  end
  def write_output do
    File.write("../Data/output/new_card_numbers_and_emails.csv",
               "Email,Card Number\n" <> exclude_card_holders_with_email())
    File.write("../Data/output/card_holders_without_email.csv",
               "First Name,Middle Name,Last Name,Card Number\n"<>card_holders_without_email())
    File.write("../Data/output/members_without_email.csv",
               "First Name,Last Name,Slack Handle\n"<>members_without_email())
    File.write("../Data/output/conflicting_card_numbers.csv",
               "Member 1,Member 2,Card Number\n" <> duplicate_card_numbers())
    File.write("../Data/output/card_numbers_and_emails.csv",
               "Email,Card Number\n" <> associate_names_to_emails_text())
  end
end
