<p align="center">
    <a alt="License"
        href="https://github.com/fivetran/dbt_iterable_source/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

# Iterable Source dbt Package ([docs](https://fivetran.github.io/dbt_iterable_source/))
# 📣 What does this dbt package do?

- Materializes [Iterable staging tables](https://fivetran.github.io/dbt_iterable_source/#!/overview/iterable_source/models/?g_v=1&g_e=seeds) which leverage data in the format described by [this ERD](https://fivetran.com/docs/applications/iterable#schemainformation). These staging tables clean, test, and prepare your Iterable data from [Fivetran's connector](https://fivetran.com/docs/applications/iterable) for analysis by doing the following:
  - Adds descriptions to tables and columns that are synced using Fivetran
  - Models staging tables, which will be used in our transform package
  - Adds column-level testing where applicable. For example, all primary keys are tested for uniqueness and non-null values.
- Generates a comprehensive data dictionary of your source and modeled Iterable data through the [dbt docs site](https://fivetran.github.io/dbt_iterable_source/).
- These tables are designed to work simultaneously with our [Iterable transformation package](https://github.com/fivetran/dbt_iterable/).

# 🎯 How do I use the dbt package?

## Step 1: Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Iterable connector syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.
## Step 2: Install the package
Include the following Iterable package version in your `packages.yml` file.

> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

```yaml
packages:
  - package: fivetran/iterable_source
    version: [">=0.8.0", "<0.9.0"]
```

## Step 3: Define database and schema variables
By default, this package runs using your destination and the `iterable` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your Iterable data is (for example, if your Iterable schema is named `iterable_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
  iterable_database: your_database_name
  iterable_schema: your_schema_name 
```

## Step 4: Enabling/Disabling Models

Your Iterable connector might not sync every table that this package expects. If your syncs exclude certain tables, it is either because you do not use that functionality in Iterable or have actively excluded some tables from your syncs. In order to enable or disable the relevant tables in the package, you will need to add the following variable(s) to your `dbt_project.yml` file.

By default, all variables are assumed to be `true` (with exception of `iterable__using_user_device`, which is set to `false`). 

```yml
vars:
    iterable__using_campaign_label_history: false                    # default is true
    iterable__using_user_unsubscribed_message_type: false           # default is true
    iterable__using_campaign_suppression_list_history: false         # default is true   

```

## (Optional) Step 5: Additional configurations
<details><summary>Expand for details</summary>
<br>

### Passing Through Additional Fields

This package includes fields we judged were standard across Iterable users. However, the Fivetran connector allows for custom columns to be brought through in the `event` and `user_history` objects. Therefore, if you wish to bring them through in these data models, leverage our pass-through column variables. These variables allow for the pass-through fields to be aliased (alias) and casted (transform_sql) if desired, but not required. Datatype casting is configured via a sql snippet within the transform_sql key. You may add the desired sql while omitting the `as field_name` at the end and your custom pass-though fields will be casted accordingly. Use the below format for declaring the respective pass-through variables:

```yml
# dbt_project.yml

vars:
  iterable_source:
    iterable_event_pass_through_columns:
      - name: "event_custom_field"
        alias: "event_field"
    iterable_user_pass_through_columns:
      - name: "unique_string_field"
        alias: "field_id"
        transform_sql: "cast(field_id as string)"
      - name: "another_user_field"
```

### Changing the Build Schema

By default, this package will build the Iterable staging models within a schema titled (<target_schema> + `_stg_iterable`) in your target database. If this is not where your would like you Iterable staging data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
models:
    iterable_source:
        +schema: my_new_schema_name # leave blank for just the target_schema
```
### Change the source table references
If an individual source table has a different name than what the package expects, add the table name as it appears in your destination to the respective variable:
> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_iterable_source/blob/main/dbt_project.yml) variable declarations to see the expected names.
    
```yml
vars:
    iterable_<default_source_table_name>_identifier: "your_table_name"
```
### Deprecated `CAMPAIGN_SUPRESSION_LIST_HISTORY` table

The Iterable connector schema originally misspelled the `CAMPAIGN_SUPPRESSION_LIST_HISTORY` table as `CAMPAIGN_SUPRESSION_LIST_HISTORY` (note the singular `P`). As of August 2021, Fivetran has deprecated the misspelled table and will only continue syncing the correctly named `CAMPAIGN_SUPPRESSION_LIST_HISTORY` table.

By default, this package refers to the new table (`CAMPAIGN_SUPPRESSION_LIST_HISTORY`). To change this so that the package works with the old misspelled source table (we do not recommend this, however), add the following configuration to your `dbt_project.yml` file:

```yml
vars:
    iterable_campaign_suppression_list_history_identifier: "campaign_supression_list_history"
```
</details>

## (Optional) Step 6: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for details</summary>
<br>
    
Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).
</details>

# 🔍 Does this package have dependencies?
This dbt package is dependent on the following dbt packages. Please be aware that these dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
    
```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]
```

# 🙌 How is this package maintained and can I contribute?
## Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/iterable_source/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_iterable_source/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

## Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions! 

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package!

# 🏪 Are there any resources available?
- If you have questions or want to reach out for help, please refer to the [GitHub Issue](https://github.com/fivetran/dbt_iterable_source/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
- Have questions or want to just say hi? Book a time during our office hours [on Calendly](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com.