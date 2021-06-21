{{ config(enabled=var('iterable__using_user_device_history', false)) }}

select * 
from {{ var('user_device_history') }}
