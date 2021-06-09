
with base as (

    select * 
    from {{ ref('stg_iterable__campaign_metrics_tmp') }}
    where not coalesce(_fivetran_deleted, true)

),

fields as (

    select
        /*
        The below macro is used to generate the correct SQL for package staging models. It takes a list of columns 
        that are expected/needed (staging_columns from dbt_iterable_source/models/tmp/) and compares it with columns 
        in the source (source_columns from dbt_iterable_source/macros/).
        For more information refer to our dbt_fivetran_utils documentation (https://github.com/fivetran/dbt_fivetran_utils.git).
        */
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_iterable__campaign_metrics_tmp')),
                staging_columns=get_campaign_metrics_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        id as campaign_id,
        date as measure_date,
        purchases,
        revenue,
        revenue_m,
        average_order_value,
        total_app_uninstalls,
        total_complaints,
        total_email_bounced,
        total_email_clicked,
        total_email_delivered,
        total_email_holdout,
        total_email_opens,
        total_email_send_skips,
        total_email_sends,
        total_hosted_unsubscribe_clicks,
        total_in_app_clicks,
        total_in_app_closes,
        total_in_app_deletes,
        total_in_app_holdout,
        total_in_app_opens,
        total_in_app_send_skips,
        total_in_app_sent,
        total_in_apps_delivered,
        total_inbox_impressions,
        total_purchases,
        total_push_holdout,
        total_push_send_skips,
        total_pushes_bounced,
        total_pushes_delivered,
        total_pushes_opened,
        total_pushes_sent,
        total_unsubscribes,
        unique_email_bounced,
        unique_email_clicks,
        unique_email_opens_or_clicks,
        unique_email_sends,
        unique_emails_delivered,
        unique_emails_opens,
        unique_hosted_unsubscribe_clicks,
        unique_in_app_clicks,
        unique_in_app_opens,
        unique_in_app_sends,
        unique_in_apps_delivered,
        unique_purchases,
        unique_pushes_bounced,
        unique_pushes_delivered,
        unique_pushes_opened,
        unique_pushes_sent,
        unique_unsubscribes
    from fields
)

select * 
from final