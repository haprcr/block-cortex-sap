# Define the database connection to be used for this model.
connection: "inventory_ecc_sd_v_5_3"

# include all the views
include: "/views/**/*.view"
include: "/components/*.lkml"
# include: "/explores_balance_sheet/*.explore"

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

################################################ Supply Chain #######################################################


explore: inventory_metrics_overview {
  sql_always_where: ${inventory_metrics_overview.client_mandt} = '{{ _user_attributes['client_id_rep'] }}'
  and ${language_map.looker_locale}='{{ _user_attributes['locale'] }}';;

  join: inventory_by_plant {
    type: left_outer
    relationship: many_to_one
    fields: [inventory_by_plant.stock_characteristic]
    sql_on: ${inventory_by_plant.client_mandt} = ${inventory_metrics_overview.client_mandt}
      and ${inventory_by_plant.company_code_bukrs} = ${inventory_metrics_overview.company_code_bukrs}
    ;;
  }

  join: language_map {
    fields: []
    type: left_outer
    sql_on: ${inventory_metrics_overview.language_spras} = ${language_map.language_key} ;;
    relationship: many_to_one
  }
}

explore: inventory_by_plant {
    sql_always_where: ${inventory_by_plant.client_mandt} = '{{ _user_attributes['client_id_rep'] }}'
        and ${language_map.looker_locale}='{{ _user_attributes['locale'] }}'
    ;;

  join: language_map {
    fields: []
    type: left_outer
    sql_on: ${inventory_by_plant.language_spras} = ${language_map.language_key} ;;
    relationship: many_to_one
  }
}


################################################ End of Supply Chain #################################################
