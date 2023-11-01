{{ config(enabled=var('iterable__using_user_unsubscribed_message_type', True)) }}

with base as (

    select * 
    from {{ ref('stg_iterable__user_unsub_message_type_tmp') }}

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
                source_columns=adapter.get_columns_in_relation(ref('stg_iterable__user_unsub_message_type_tmp')),
                staging_columns=get_user_unsubscribed_message_type_columns()
            )
        }}
        
    from base
),

final as (

    select 

        cast(_fivetran_id as {{ dbt.type_string() }} ) as _fivetran_user_id,
        coalesce(_fivetran_id, email) as unique_user_key,
        cast(message_type_id as {{ dbt.type_string() }} ) as message_type_id,
        {{ dbt_utils.generate_surrogate_key(['_fivetran_id', 'email', 'message_type_id','updated_at']) }} as unsub_message_type_unique_key,
        rank() over(partition by coalesce(email, _fivetran_id) order by coalesce(updated_at, _fivetran_id) desc) as latest_batch_index,
        _fivetran_synced

    from fields
)

select *
from final 
