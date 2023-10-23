{{ config(enabled=var('iterable__using_user_device', false)) }}

select * 
from {{ var('user_device') }}
