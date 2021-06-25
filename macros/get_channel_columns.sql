{% macro get_channel_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "channel_type", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_int()},
    {"name": "message_medium", "datatype": dbt_utils.type_string()},
    {"name": "name", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
