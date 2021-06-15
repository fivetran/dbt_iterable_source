{{ config(enabled=var('iterable__using_user_unsubscribed_message_type_history', True)) }}

select * from {{ var('user_unsubscribed_message_type_history') }}
-- had to rename this to be compatible with postgres....