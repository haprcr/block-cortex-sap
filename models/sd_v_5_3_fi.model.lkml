# Define the database connection to be used for this model.
connection: "@{CONNECTION_NAME}"

# include all the views
include: "/views/**/*.view"
include: "/components/*.lkml"
include: "/explores_balance_sheet/*.explore"

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


explore: data_intelligence_ar {
  sql_always_where: ${Client_ID} = "@{CLIENT}" ;;
  join: currency_conversion_new {
    type: left_outer
    relationship: one_to_many
    sql_on: ${data_intelligence_ar.Client_ID}=${currency_conversion_new.mandt}
          and ${data_intelligence_ar.Local_Currency_Key}=${currency_conversion_new.fcurr}
          and ${data_intelligence_ar.Posting_date} = ${currency_conversion_new.conv_date}
          and ${currency_conversion_new.kurst} = "M"
          and ${currency_conversion_new.tcurr} = {% parameter data_intelligence_ar.Currency_Required %};;
    fields: [] #this view used for currency convesion only so no fields need to be included in the explore
  }
}

  ########################################### Finanace Dashboards ########################################################################

explore: vendor_performance {
  sql_always_where: ${vendor_performance.client_mandt} = '{{ _user_attributes['client_id_rep'] }}'
    and ${language_map.looker_locale}='{{ _user_attributes['locale'] }}'
    ;;

  join: language_map {
    fields: []
    type: left_outer
    sql_on: ${vendor_performance.language_key} = ${language_map.language_key} ;;
    relationship: many_to_one
  }

  join: materials_valuation_v2 {
    type: left_outer
    relationship: many_to_one
    sql_on: ${vendor_performance.client_mandt} = ${materials_valuation_v2.client_mandt}
    and ${vendor_performance.material_number} = ${materials_valuation_v2.material_number_matnr}
    and ${vendor_performance.plant} = ${materials_valuation_v2.valuation_area_bwkey}
    and ${vendor_performance.month_year} = ${materials_valuation_v2.month_year}
    and ${materials_valuation_v2.valuation_type_bwtar} = ''
    ;;
    }
}

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

explore: materials_valuation_v2 {
  sql_always_where: ${client_mandt} = '{{ _user_attributes['client_id_rep'] }}' ;;
}

########################################### Finanace Dashboards End ########################################################################

################################################ Supply Chain #######################################################



################################################ End of Supply Chain #################################################

explore: global_currency_list_pdt {
  hidden: yes
  description: "Used to provide filter suggestions for Global Currency"
}
