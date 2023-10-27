{% macro get_user_unsubscribed_message_type_history_columns() %}

{% if does_table_exist('user_unsubscribed_message_type') %}

{% set columns = [
    {"name": "_fivetran_id", "datatype": dbt.type_string()},
    {"name": "message_type_id", "datatype": dbt.type_string()}
] %}

{% else %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "email", "datatype": dbt.type_string()},
    {"name": "message_type_id", "datatype": dbt.type_string()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()}
] %}

{% endif %}

{{ return(columns) }}

{% endmacro %}
