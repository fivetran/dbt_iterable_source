{{ config(enabled=var('iterable__using_user_device_history', True)) }}

select * from {{ var('user_device_history') }}
