# Define the database connection to be used for this model.
connection: "@{CONNECTION_NAME}"

# include all the views
include: "/views/**/*.view"
include: "/components/*.lkml"
include: "/explores_finance/*.explore"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: cortex_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: cortex_default_datagroup

# Explores allow you to join together different views (database tables) based on the
# relationships between fields. By joining a view into an Explore, you make those
# fields available to users for data analysis.
# Explores should be purpose-built for specific use cases.

# To see the Explore you’re building, navigate to the Explore menu and select an Explore under "Cortex"

# To create more sophisticated Explores that involve multiple views, you can use the join parameter.
# Typically, join parameters require that you define the join type, join relationship, and a sql_on clause.
# Each joined view also needs to define a primary key.

include: "/LookML_Dashboard/*.dashboard.lookml"

named_value_format: Greek_Number_Format {
  value_format: "[>=1000000000]0.0,,,\"B\";[>=1000000]0.0,,\"M\";[>=1000]0.0,\"K\";0.0"
}



  ########################################### Finanace Dashboards ########################################################################


explore: days_payable_outstanding_v2 {
  sql_always_where: ${client_mandt} = '{{ _user_attributes['client_id_rep'] }}' ;;
}


explore: accounts_payable_v2 {

  sql_always_where: ${accounts_payable_v2.client_mandt} =  '{{ _user_attributes['client_id_rep'] }}';;
}

explore: cash_discount_utilization {
  sql_always_where: ${client_mandt} = '{{ _user_attributes['client_id_rep'] }}';;
}


explore: accounts_payable_overview_v2 {

  sql_always_where: ${accounts_payable_overview_v2.client_mandt} =  '{{ _user_attributes['client_id_rep'] }}' ;;
}

explore: accounts_payable_turnover_v2 {

  sql_always_where: ${accounts_payable_turnover_v2.client_mandt} = '{{ _user_attributes['client_id_rep'] }}' ;;
}

########################################### Finanace Dashboards End ########################################################################



explore: global_currency_list_pdt {
  hidden: yes
  description: "Used to provide filter suggestions for Global Currency"
}
