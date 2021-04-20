
with base as (

    select * 
    from {{ ref('stg_iterable__template_history_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_iterable__template_history_tmp')),
                staging_columns=get_template_history_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        id as template_id,
        name as template_name,
        template_type,
        created_at,
        client_template_id,
        creator_user_id,
        message_type_id,
        updated_at
    from fields
)

select * 
from final
