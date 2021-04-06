{% macro get_event_columns() %}

{% set columns = [
    {"name": "_fivetran_id", "datatype": dbt_utils.type_string()},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "additional_properties", "datatype": dbt_utils.type_string()},
    {"name": "campaign_id", "datatype": dbt_utils.type_int()},
    {"name": "content_id", "datatype": dbt_utils.type_int()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "email", "datatype": dbt_utils.type_string()},
    {"name": "event_name", "datatype": dbt_utils.type_string()},
    {"name": "ip", "datatype": dbt_utils.type_string()},
    {"name": "message_bus_id", "datatype": dbt_utils.type_string()},
    {"name": "message_id", "datatype": dbt_utils.type_string()},
    {"name": "message_type_id", "datatype": dbt_utils.type_int()},
    {"name": "recipient_state", "datatype": dbt_utils.type_string()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "transactional_data", "datatype": dbt_utils.type_string()},
    {"name": "unsub_source", "datatype": dbt_utils.type_string()},
    {"name": "user_agent", "datatype": dbt_utils.type_string()},
    {"name": "user_agent_device", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
