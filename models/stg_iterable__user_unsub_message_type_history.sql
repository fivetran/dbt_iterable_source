{{ config(enabled=var('iterable__using_user_unsubscribed_message_type', True)) }}

with base as (

    select * 
    from {{ ref('stg_iterable__user_unsub_message_type_history_tmp') }}

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
                source_columns=adapter.get_columns_in_relation(ref('stg_iterable__user_unsub_message_type_history_tmp')),
                staging_columns=get_user_unsubscribed_message_type_history_columns()
            )
        }}
        
    from base
),

final as (

    select 

        {% if var('iterable__using_user_unsubscribed_message_type', does_table_exist('user_unsubscribed_message_type_history')) %}

        email,
        message_type_id,
        updated_at,

        {% else %}

        _fivetran_id as _fivetran_user_id,
        cast(message_type_id as {{ dbt.type_string() }} ) as message_type_id,

        {% endif %}

        _fivetran_synced

    from fields
)

select * from final