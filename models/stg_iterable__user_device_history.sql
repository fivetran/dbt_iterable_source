{{ config(enabled=var('iterable__using_user_device_history', false)) }}

-- todo: may want to make this ephemeral or do the window functions to select the final batch of devices here
with base as (

    select * 
    from {{ ref('stg_iterable__user_device_history_tmp') }}

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
                source_columns=adapter.get_columns_in_relation(ref('stg_iterable__user_device_history_tmp')),
                staging_columns=get_user_device_history_columns()
            )
        }}
        
    from base
),

final as (
    
    select
        application_name,
        email,
        index,
        platform,
        platform_endpoint,
        endpoint_enabled as is_endpoint_enabled,
        cast (updated_at as {{ dbt_utils.type_timestamp() }}) as updated_at,
        _fivetran_synced

    from fields
)

select * from final
