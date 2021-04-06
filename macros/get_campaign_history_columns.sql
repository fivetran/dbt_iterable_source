{% macro get_campaign_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "campaign_state", "datatype": dbt_utils.type_string()},
    {"name": "created_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "created_by_user_id", "datatype": dbt_utils.type_string()},
    {"name": "ended_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "id", "datatype": dbt_utils.type_int()},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "recurring_campaign_id", "datatype": dbt_utils.type_int()},
    {"name": "send_size", "datatype": dbt_utils.type_int()},
    {"name": "start_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "template_id", "datatype": dbt_utils.type_int()},
    {"name": "type", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "workflow_id", "datatype": dbt_utils.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}
