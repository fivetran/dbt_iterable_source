{{ config( materialized = 'view' ) }}

with base as (

    select * 
    from {{ ref('stg_iterable__event_tmp') }}

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
                source_columns=adapter.get_columns_in_relation(ref('stg_iterable__event_tmp')),
                staging_columns=get_event_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        _fivetran_id as event_id,
        campaign_id,
        content_id,
        created_at,
        cast( {{ dbt_utils.date_trunc('day', 'created_at') }} as date) as created_on,
        lower(email) as email,
        additional_properties,
        event_name,
        message_bus_id,
        message_id,
        message_type_id,
        recipient_state,
        status,
        transactional_data,
        unsub_source,
        user_agent,
        user_agent_device,
        _fivetran_synced
    from fields
)

select * 
from final