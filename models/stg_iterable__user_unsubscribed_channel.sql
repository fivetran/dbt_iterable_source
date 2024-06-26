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

        cast(_fivetran_id as {{ dbt.type_string() }} ) as _fivetran_user_id,
        coalesce(cast(_fivetran_id as {{ dbt.type_string() }} ), email) as unique_user_key,
        cast(channel_id as {{ dbt.type_string() }} ) as channel_id,
        {{ dbt_utils.generate_surrogate_key(['_fivetran_id', 'channel_id', 'email', 'updated_at']) }} as unsub_channel_unique_key,
        
        {% if does_table_exist('user_unsubscribed_channel') == false %}
        rank() over(partition by email, channel_id order by updated_at desc) as latest_batch_index,
        {% else %}
        1 as latest_batch_index,
        {% endif %}

        updated_at,
        _fivetran_synced

    from fields
)


select *
from final

