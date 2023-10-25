{{
    config( materialized='view' )
}}

with base as (

    select * 
    from {{ ref('stg_iterable__event_extension_tmp') }}

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
                source_columns=adapter.get_columns_in_relation(ref('stg_iterable__event_extension_tmp')),
                staging_columns=get_event_extension_columns()
            )
        }}
        
    from base
),

final as (
    select
        cast(_fivetran_id as {{ dbt.type_string() }} ) as event_id,
        app_already_running as is_app_already_running,
        badge,
        catalog_collection_count,
        catalog_lookup_count,
        canonical_url_id,
        content_available as is_content_available,
        content_id,
        deeplink_android,
        deeplink_ios,
        device,
        cast(email_id as {{ dbt.type_string() }}) as email_id,
        email_subject,
        experiment_id,
        from_phone_number_id,
        from_smssender_id,
        image_url,
        is_ghost_push,
        link_id,
        link_url,
        locale,
        payload,
        platform_endpoint,
        push_message,
        region,
        sms_message,
        sms_provider_response_code,
        sms_provider_response_message,
        sms_provider_response_more_info,
        sms_provider_response_status,
        sound,
        to_phone_number,
        url,
        workflow_id,
        workflow_name,
        city,
        clicked_url,
        country,
        error_code,
        expires_at,
        from_phone_number,
        in_app_body,
        is_sms_estimation,
        labels,
        message_context,
        message_status,
        mms_send_count,
        product_recommendation_count,
        proxy_source,
        reason,
        sms_send_count,
        web_push_body,
        web_push_click_action,
        web_push_icon,
        web_push_message,
        _fivetran_synced,
        cast(_fivetran_user_id as {{ dbt.type_string() }} ) as _fivetran_user_id
    from fields
)

select *
from final