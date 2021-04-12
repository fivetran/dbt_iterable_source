{% macro get_list_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "id", "datatype": dbt_utils.type_int()},
    {"name": "list_type", "datatype": dbt_utils.type_string()},
    {"name": "name", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}