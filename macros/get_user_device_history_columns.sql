{% macro get_user_device_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "application_name", "datatype": dbt_utils.type_string()},
    {"name": "email", "datatype": dbt_utils.type_string()},
    {"name": "endpoint_enabled", "datatype": "boolean"},
    {"name": "index", "datatype": dbt_utils.type_numeric()},
    {"name": "platform", "datatype": dbt_utils.type_string()},
    {"name": "platform_endpoint", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
