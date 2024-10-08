{{ config(
        materialized='incremental',
        unique_key=['_fivetran_user_id','updated_at'],
        incremental_strategy='insert_overwrite' if target.type in ('bigquery', 'spark', 'databricks') else 'delete+insert',
        partition_by={"field": "updated_at", "data_type": "date"} if target.type not in ('spark','databricks') else ['updated_at'],
        file_format='parquet',
        on_schema_change='fail'
    ) 
}}

with base as (

    select * 
    from {{ ref('stg_iterable__user_history_tmp') }}

    {% if is_incremental() %}
    where updated_at >= coalesce((select max(updated_at) from {{ this }} ), '2010-01-01')
    {% endif %}
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
                source_columns=adapter.get_columns_in_relation(ref('stg_iterable__user_history_tmp')),
                staging_columns=get_user_history_columns()
            )
        }}

    from base
),

final as (
    
    select 
        cast(_fivetran_id as {{ dbt.type_string() }} ) as _fivetran_user_id,
        lower(email) as email,
        updated_at,
        cast(user_id as {{ dbt.type_string() }} ) as user_id,
        first_name,
        last_name,
        cast(email_list_ids as {{ dbt.type_string() }}) as email_list_ids,
        phone_number,
        signup_date,
        signup_source,
        cast(iterable_user_id as {{ dbt.type_string() }} ) as iterable_user_id,
        _fivetran_synced,
        coalesce(cast(_fivetran_id as {{ dbt.type_string() }} ) , email) as unique_user_key

        {{ fivetran_utils.fill_pass_through_columns('iterable_user_history_pass_through_columns') }}

    from fields
)

select *
from final