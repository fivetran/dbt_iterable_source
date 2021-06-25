{% macro get_user_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "email", "datatype": dbt_utils.type_string()},
    {"name": "email_list_ids", "datatype": dbt_utils.type_string()},
    {"name": "first_name", "datatype": dbt_utils.type_string()},
    {"name": "last_name", "datatype": dbt_utils.type_string()},
    {"name": "phone_number", "datatype": dbt_utils.type_string()},
    {"name": "signup_date", "datatype": dbt_utils.type_timestamp()},
    {"name": "signup_source", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "user_id", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
