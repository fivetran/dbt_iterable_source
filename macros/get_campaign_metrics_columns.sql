{% macro get_campaign_metrics_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "average_order_value", "datatype": dbt_utils.type_float()},
    {"name": "date", "datatype": "date"},
    {"name": "id", "datatype": dbt_utils.type_numeric()},
    {"name": "purchases", "datatype": dbt_utils.type_float()},
    {"name": "purchases_m_email_", "datatype": dbt_utils.type_float()},
    {"name": "revenue", "datatype": dbt_utils.type_float()},
    {"name": "revenue_m", "datatype": dbt_utils.type_float()},
    {"name": "revenue_m_email_", "datatype": dbt_utils.type_float()},
    {"name": "total_app_uninstalls", "datatype": dbt_utils.type_float()},
    {"name": "total_complaints", "datatype": dbt_utils.type_float()},
    {"name": "total_email_bounced", "datatype": dbt_utils.type_float()},
    {"name": "total_email_clicked", "datatype": dbt_utils.type_float()},
    {"name": "total_email_delivered", "datatype": dbt_utils.type_float()},
    {"name": "total_email_holdout", "datatype": dbt_utils.type_numeric()},
    {"name": "total_email_opens", "datatype": dbt_utils.type_float()},
    {"name": "total_email_send_skips", "datatype": dbt_utils.type_numeric()},
    {"name": "total_email_sends", "datatype": dbt_utils.type_float()},
    {"name": "total_hosted_unsubscribe_clicks", "datatype": dbt_utils.type_float()},
    {"name": "total_purchases", "datatype": dbt_utils.type_float()},
    {"name": "total_pushes_bounced", "datatype": dbt_utils.type_float()},
    {"name": "total_pushes_delivered", "datatype": dbt_utils.type_float()},
    {"name": "total_pushes_opened", "datatype": dbt_utils.type_float()},
    {"name": "total_pushes_sent", "datatype": dbt_utils.type_float()},
    {"name": "total_unsubscribes", "datatype": dbt_utils.type_float()},
    {"name": "unique_email_bounced", "datatype": dbt_utils.type_float()},
    {"name": "unique_email_clicks", "datatype": dbt_utils.type_float()},
    {"name": "unique_email_opens_or_clicks", "datatype": dbt_utils.type_float()},
    {"name": "unique_email_sends", "datatype": dbt_utils.type_numeric()},
    {"name": "unique_emails_delivered", "datatype": dbt_utils.type_float()},
    {"name": "unique_emails_opens", "datatype": dbt_utils.type_numeric()},
    {"name": "unique_hosted_unsubscribe_clicks", "datatype": dbt_utils.type_float()},
    {"name": "unique_purchases", "datatype": dbt_utils.type_float()},
    {"name": "unique_pushes_bounced", "datatype": dbt_utils.type_float()},
    {"name": "unique_pushes_opened", "datatype": dbt_utils.type_float()},
    {"name": "unique_pushes_sent", "datatype": dbt_utils.type_float()},
    {"name": "unique_unsubscribes", "datatype": dbt_utils.type_float()}
] %}

{{ return(columns) }}

{% endmacro %}
