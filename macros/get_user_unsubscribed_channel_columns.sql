{% macro get_user_unsubscribed_channel_columns() %}

{% if does_table_exist('user_unsubscribed_channel') %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "_fivetran_id", "datatype": dbt.type_string()},
    {"name": "channel_id", "datatype": dbt.type_int()}
] %}

{% else %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "channel_id", "datatype": dbt.type_int()},
    {"name": "email", "datatype": dbt.type_string()},
    {"name": "updated_at", "datatype": dbt.type_timestamp()}
] %}

{% endif %}

{{ return(columns) }}

{% endmacro %}
