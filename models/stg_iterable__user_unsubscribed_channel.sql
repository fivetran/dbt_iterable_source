with base as (
    select *
    from {{ ref('stg_iterable__user_unsubscribed_channel_tmp') }}

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
                source_columns=adapter.get_columns_in_relation(ref('stg_iterable__user_unsubscribed_channel_tmp')),
                staging_columns=get_user_unsubscribed_channel_columns()
            )
        }}
        
    from base
),

final as (

    select

        {% if does_table_exist('user_unsubscribed_channel') %}

        _fivetran_id as _fivetran_user_id,
        cast(channel_id as {{ dbt.type_string() }} ) as channel_id,
        {{ dbt_utils.generate_surrogate_key(['_fivetran_id', 'channel_id']) }} as unsub_channel_unique_key,

        {% else %}

        channel_id,
        email,
        updated_at,
        rank() over(partition by email order by updated_at desc) as latest_batch_index,
        {{ dbt_utils.generate_surrogate_key(['email', 'channel_id','updated_at']) }} as unsub_channel_unique_key,

        {% endif %}

        _fivetran_synced

    from fields
)


select *
from final

{% if does_table_exist('user_unsubscribed_channel') == false %}

where latest_batch_index = 1

{% endif %}