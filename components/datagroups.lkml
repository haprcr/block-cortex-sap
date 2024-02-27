datagroup: monthly_on_day_1 {
  sql_trigger: select extract(month from current_date) ;;
  description: "Triggers on first day of the month"
}
