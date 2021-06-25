{% macro get_user_unsubscribed_message_type_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "email", "datatype": dbt_utils.type_string()},
    {"name": "message_type_id", "datatype": dbt_utils.type_numeric()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
