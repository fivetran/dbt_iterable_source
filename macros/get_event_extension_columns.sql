{% macro get_event_extension_columns() %}

{% set columns = [
    {"name": "_fivetran_id", "datatype": dbt_utils.type_string()},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "app_already_running", "datatype": "boolean"},
    {"name": "badge", "datatype": dbt_utils.type_string()},
    {"name": "canonical_url_id", "datatype": dbt_utils.type_string()},
    {"name": "content_available", "datatype": "boolean"},
    {"name": "content_id", "datatype": dbt_utils.type_numeric()},
    {"name": "deeplink_android", "datatype": dbt_utils.type_string()},
    {"name": "deeplink_ios", "datatype": dbt_utils.type_string()},
    {"name": "device", "datatype": dbt_utils.type_string()},
    {"name": "email_id", "datatype": dbt_utils.type_string()},
    {"name": "email_subject", "datatype": dbt_utils.type_string()},
    {"name": "experiment_id", "datatype": dbt_utils.type_string()},
    {"name": "from_phone_number_id", "datatype": dbt_utils.type_numeric()},
    {"name": "from_smssender_id", "datatype": dbt_utils.type_numeric()},
    {"name": "image_url", "datatype": dbt_utils.type_string()},
    {"name": "is_ghost_push", "datatype": "boolean"},
    {"name": "link_id", "datatype": dbt_utils.type_string()},
    {"name": "link_url", "datatype": dbt_utils.type_string()},
    {"name": "locale", "datatype": dbt_utils.type_string()},
    {"name": "payload", "datatype": dbt_utils.type_string()},
    {"name": "platform_endpoint", "datatype": dbt_utils.type_string()},
    {"name": "push_message", "datatype": dbt_utils.type_string()},
    {"name": "region", "datatype": dbt_utils.type_string()},
    {"name": "sms_message", "datatype": dbt_utils.type_string()},
    {"name": "sms_provider_response_code", "datatype": dbt_utils.type_numeric()},
    {"name": "sms_provider_response_message", "datatype": dbt_utils.type_string()},
    {"name": "sms_provider_response_more_info", "datatype": dbt_utils.type_string()},
    {"name": "sms_provider_response_status", "datatype": dbt_utils.type_numeric()},
    {"name": "sound", "datatype": dbt_utils.type_string()},
    {"name": "to_phone_number", "datatype": dbt_utils.type_string()},
    {"name": "url", "datatype": dbt_utils.type_string()},
    {"name": "workflow_id", "datatype": dbt_utils.type_string()},
    {"name": "workflow_name", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}