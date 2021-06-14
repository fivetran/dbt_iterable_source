{% macro get_user_device_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "application_name", "datatype": dbt_utils.type_string()},
    {"name": "email", "datatype": dbt_utils.type_string()},
    {"name": "endpoint_enabled", "datatype": "boolean"},
    {"name": "identifier_for_vendor", "datatype": dbt_utils.type_string()},
    {"name": "index", "datatype": dbt_utils.type_numeric()},
    {"name": "localized_model", "datatype": dbt_utils.type_string()},
    {"name": "model", "datatype": dbt_utils.type_string()},
    {"name": "platform", "datatype": dbt_utils.type_string()},
    {"name": "platform_endpoint", "datatype": dbt_utils.type_string()},
    {"name": "system_name", "datatype": dbt_utils.type_string()},
    {"name": "system_version", "datatype": dbt_utils.type_string()},
    {"name": "token", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "user_interface_idiom", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
