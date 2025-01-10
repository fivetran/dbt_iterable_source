# dbt_iterable_source version.version

## Documentation
- Corrected references to connectors and connections in the README. ([#41](https://github.com/fivetran/dbt_iterable_source/pull/41))

# dbt_iterable_source v0.10.0
[PR #39](https://github.com/fivetran/dbt_iterable_source/pull/39) contains the following updates:

## Breaking Change (`--full-refresh` required after upgrading)  
- Updates the materialization in `stg_iterable__user_history` from table to view in order to improve performance. A `--full-refresh` is required after upgrading to ensure there are no issues.

## Bug Fixes 
- Removes the source freshness tests in the `src_iterable.yml`. This was originally causing run errors for users where tables weren't present in their schema but listed in the `src_iterable.yml`.
- Removes `created_at` from the uniqueness test for `stg_iterable__event` in `stg_iterable.yml`. Uniqueness is now tested solely on `unique_event_id`, a surrogate key made up of `event_id` (`_fivetran_id` in the raw table, which is a Fivetran-created unique identifier derived from hashing `campaign_id`, `created_at`, and `event_name`) and `_fivetran_user_id` (a Fivetran-created column derived from a hash of `user_id` and/or `email`).

## Documentation Update
- Updates the descriptions of timestamp-based fields. Previously they were described as milliseconds since epoch time, but they should be standard timestamps.

# dbt_iterable_source v0.9.0
[PR #31](https://github.com/fivetran/dbt_iterable_source/pull/31) contains the following updates:

## 🚨 Breaking Changes 🚨
- Introduces variable `iterable__using_event_extension` to disable the `stg_iterable__event_extension` model. This allows the downstream models to run even if the source `event_extension` table does not exist. For more information on how to configure refer to the [README](https://github.com/fivetran/dbt_iterable_source/blob/main/README.md#step-4-enablingdisabling-models).

# dbt_iterable_source v0.8.1
[PR #30](https://github.com/fivetran/dbt_iterable_source/pull/30) introduces the following updates: 

## Bug Fixes
- IMPORTANT: This only impacts customers who are using Fivetran connectors that were setup before August 2023, when `user_unsubscribed_message_type_history` and `user_unsubscribed_channel_history` were the tables being used for tracking unsubscribe events.
- Updated the `stg_iterable__user_unsub_message_type` model to partition the `latest_batch_index` value on `message_type_id` along with `email`. This brings in all unsubscribes for the `unique_user_key` across all message types for an email.
- Updated `stg_iterable__user_unsubscribed_channel` and `stg_iterable__user_unsubscribed_channel` to partition the `latest_batch_index` value on `channel_id` along with `email`. This brings in all unsubscribes for the `unique_user_key` across all channels for an email.
- These updates ensure that `iterable__user_unsubscriptions` in the `dbt_iterable` package brings in all the latest unsubscribing behavior for a user by channel and by message type, and not just the last unsubscription for a user based on the `updated_at` value.

## Under the Hood
- Updated seed files to effectively run and test that the new partitions worked as expected.
- Updated [pull request and issue templates](https://github.com/fivetran/dbt_iterable_source/tree/v0.8.1/.github).
- Included auto-releaser GitHub Actions workflow to automate future releases.

# dbt_iterable_source v0.8.0

## API Updates
[PR #28](https://github.com/fivetran/dbt_iterable_source/pull/28) includes updates in response to the [Aug 2023 updates](https://fivetran.com/docs/applications/iterable/changelog#august2023) for the Iterable connector.

## 🚨 Breaking Changes 🚨
-  We have removed the `stg_iterable__user_device_history` model as the value is marginal.
- The following models have been renamed to reflect the new (non history) table names synced by the connector.

| **Previous Model Name** | **Updated Model Name** |
|---------------------------|---------------------------|
| `stg_iterable__user_unsub_message_type_history` | `stg_iterable__user_unsub_message_type` |
| `stg_iterable__user_unsub_message_type_history_tmp` | `stg_iterable__user_unsub_message_type_tmp` |
| `stg_iterable__user_unsubscribed_channel_history` | `stg_iterable__user_unsubscribed_channel` |
| `stg_iterable__user_unsubscribed_channel_history_tmp` | `stg_iterable__user_unsubscribed_channel_tmp` |

## Feature Updates
- Added the fields `updated_by_user_id` and `message_medium` to `stg_iterable__campaign_history`
- Added the fields `_fivetran_id` and `_fivetran_user_id` to `stg_iterable__event`
- Added the fields `catalog_collection_count, catalog_lookup_count, city, clicked_url, country, error_code, expires_at, from_phone_number, in_app_body, is_sms_estimation, labels, message_status, mms_send_count, reason, sms_send_count, and _fivetran_user_id` to  `stg_iterable__event_extension`
- Added the fields `list_description` to `stg_iterable__list`
- Added the fields `message_type_created_at, frequency_cap, rate_limit_per_minute, subscription_policy, and message_type_updated_at` to `stg_iterable__message_type`
- Added the field `_fivetran_user_id` to `stg_iterable__user_history`
- Introduced passthrough column functionality for `user_history` and `event_extension` objects. For more information refer to the [README](./README.md#passing-through-additional-fields).

## Field Removals
- Removed the following fields from `stg_iterable__event_extension`: `deeplink_android, deeplink_ios, image_url, is_ghost_push, link_id, sms_provider_response_code, sms_provider_response_message, sms_provider_response_more_info, sms_provider_response_status, sound`

## Test Updates
- The unique tests in `stg_iterable__event` and `stg_iterable__event_extension` now uses `unique_event_id`. This is a generated surrogate key from `event_id` and `_fivetran_user_id`. Previously it was just `event_id`, but now the unique keys in the respective source tables involve a combination of `event_id` and `_fivetran_user_id`, if it exists. `_fivetran_user_id` is a key available in the Aug 2023 Iterable API that's generated by taking hash of user_id and/or email fields depending on the project type.
- The unique test in `stg_iterable__user_history` now tests for a unique combination of `fivetran_id` and `updated_at`. Previously it was just email, however with the Iterable schema updates, that may not exist for each user. This is because based on the channel, not all users have an associated email, particularly if it's marketing done via a project type based on user ID where an email identifier may not be unique.  `fivetran_id` is generated by taking hash of user_id and/or email fields depending on the project type. For more information refer to the Iterable [docs](https://support.iterable.com/hc/en-us/articles/9216719179796-Project-Types-and-Unique-Identifiers-).

## Under the Hood:
- Past August 2023, the `user_unsubscribed_channel_history` and `user_unsubscribed_message_type_history` Iterable objects will no longer be history tables. In addition, the columns have changed. We have checks in place that will automatically persist the respective columns depending on what exists in your schema.
  - In addition, we have generated keys for these 2 respective staging models that we will use for uniqueness tests. 
  - For `stg_iterable__user_unsubscribed_channel`, which pulls from the `user_unsubscribed_channel` table, the unique key generated is depends on what exists in your tables (determined by whether you are using the history version). For the history version, it's a key generated from `email`, `channel_id`, and `updated_at`. If not using the history table, it uses `_fivetran_user_id` and `channel_id`. 
  - For `stg_iterable__user_unsub_message_type`, which pulls from `user_unsubscribed_message_type_history`, the unique key is generated from `email`, `message_type_id`, and `updated_at` if using the history version. If not using the history table, it uses `_fivetran_user_id` and `message_type_id`.
  - For more information, refer to our [documentation](https://github.com/fivetran/dbt_iterable_source/blob/main/models/stg_iterable.yml).
- Explicitly casts the `*_id` fields in the staging models as strings. This ensures that downstream, joins will work and the JSON as string operations are not impacted by errors if the connector syncs this field as a JSON datatype.


# dbt_iterable_source v0.7.0
## 🎉 Feature Update 🎉
- Databricks compatibility! ([#25](https://github.com/fivetran/dbt_iterable_source/pull/25))

## 🚘 Under the Hood 🚘
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job. ([#24](https://github.com/fivetran/dbt_iterable_source/pull/24))
- Updated the pull request [templates](/.github). ([#24](https://github.com/fivetran/dbt_iterable_source/pull/24))

# dbt_iterable_source v0.6.0
## 🚨 Breaking Changes 🚨
- Added `iterable_[source_table_name]_identifier` variables to allow easier flexibility of the package to refer to source tables with different names. 
- **Note!** For the table `campaign_suppression_list_history`, the identifier variable has been updated from `iterable__campaign_suppression_list_history_table` to `iterable_campaign_suppression_list_history_identifier` to align with the current naming convention. If you are using the former variable in your `dbt_project.yml`, you will need to update it for the package to run.
([#23](https://github.com/fivetran/dbt_iterable_source/pull/23))


## 🎉 Features
- Updated README with identifier instructions and format update. ([#23](https://github.com/fivetran/dbt_iterable_source/pull/23))

# dbt_iterable_source v0.5.0

## 🚨 Breaking Changes 🚨:
[PR #18](https://github.com/fivetran/dbt_iterable_source/pull/18) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- Dependencies on `fivetran/fivetran_utils` have been upgraded, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.

# dbt_iterable_source v0.4.1
## 🎉 Documentation and Feature Updates
- Added variable `iterable__using_campaign_suppression_list_history` to disable `stg_iterable__campaign_suppression_list_history` if the respective source table is not being used. For how to configure refer to the [README](https://github.com/fivetran/dbt_iterable_source/blob/main/README.md#enabling-and-disabling-models). ([#21](https://github.com/fivetran/dbt_iterable_source/pull/21)) 
## Contributors
Thank you @awpharr for raising these to our attention! ([#19](https://github.com/fivetran/dbt_iterable/issues/19))


# dbt_iterable_source v0.4.0
🎉 dbt v1.0.0 Compatibility 🎉
## 🚨 Breaking Changes 🚨
- Adjusts the `require-dbt-version` to now be within the range [">=1.0.0", "<2.0.0"]. Additionally, the package has been updated for dbt v1.0.0 compatibility. If you are using a dbt version <1.0.0, you will need to upgrade in order to leverage the latest version of the package.
  - For help upgrading your package, I recommend reviewing this GitHub repo's Release Notes on what changes have been implemented since your last upgrade.
  - For help upgrading your dbt project to dbt v1.0.0, I recommend reviewing dbt-labs [upgrading to 1.0.0 docs](https://docs.getdbt.com/docs/guides/migration-guide/upgrading-to-1-0-0) for more details on what changes must be made.
- Upgrades the package dependency to refer to the latest `dbt_fivetran_utils`. The latest `dbt_fivetran_utils` package also has a dependency on `dbt_utils` [">=0.8.0", "<0.9.0"].
  - Please note, if you are installing a version of `dbt_utils` in your `packages.yml` that is not in the range above then you will encounter a package dependency error.

# dbt_iterable_source v0.1.0 -> v0.3.0
Refer to the relevant release notes on the Github repository for specific details for the previous releases. Thank you!
