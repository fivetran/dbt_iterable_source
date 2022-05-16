
with base as (

    select * 
    from {{ ref('stg_iterable__list_tmp') }}
    where not coalesce(_fivetran_deleted, true)

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_iterable__list_tmp')),
                staging_columns=get_list_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        id as list_id,
        name as list_name,
        list_type,
        cast (created_at as {{ dbt_utils.type_timestamp() }}) as created_at,
        _fivetran_synced
    from fields
)

select * 
from final
