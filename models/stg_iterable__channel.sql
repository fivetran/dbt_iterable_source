
with base as (

    select * 
    from {{ ref('stg_iterable__channel_tmp') }}
    where not coalesce(_fivetran_deleted, false)

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
                source_columns=adapter.get_columns_in_relation(ref('stg_iterable__channel_tmp')),
                staging_columns=get_channel_columns()
            )
        }}
        
    from base
),

final as (

    select
        cast(id as {{ dbt.type_string() }} ) as channel_id,
        name as channel_name,
        channel_type,
        message_medium,
        _fivetran_synced

    from fields
)

select * 
from final
