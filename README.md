[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![dbt logo and version](https://img.shields.io/static/v1?logo=dbt&label=dbt-version&message=0.20.x&color=orange)
# Iterable Source

This package models Iterable data from [Fivetran's connector](https://fivetran.com/docs/applications/iterable). It uses data in the format described by [this ERD](https://fivetran.com/docs/applications/iterable#schemainformation).

This package enriches your Fivetran data by doing the following:

- Adds descriptions to tables and columns that are synced using Fivetran.
- Adds column-level testing where applicable. For example, all primary keys are tested for uniqueness and non-null values.
- Models staging tables, to be used in our transform package.

## Models

This package contains staging models, designed to work simultaneously with our [Iterable transformation package](https://github.com/fivetran/dbt_iterable). The staging models name columns consistently across all packages:

- Boolean fields are prefixed with `is_` or `has_`.
- Timestamps are appended with `_at`.
- ID primary keys are prefixed with the name of the table. For example, the campaign history table's ID column is renamed `campaign_history_id`.

## Installation Instructions
`dbt_iterable_source` currently supports `dbt 0.20.x`.

Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your `packages.yml`

```yaml
packages:
  - package: fivetran/iterable_source
    version: [">=0.2.0", "<0.3.0"]
```

Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Configuration

By default, this package looks for your Iterable data in the `iterable` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your Iterable data is, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    iterable_schema: your_schema_name
    iterable_database: your_database_name
```

### Enabling and Disabling Models

Your Iterable connector might not sync every table that this package expects. If your syncs exclude certain tables, it is because you either don't use that functionality in Iterable or have actively excluded some tables from your syncs. In order to enable or disable the relevant functionality in the package, you will need to add the relevant variables.

By default, all variables are assumed to be `true` (with exception of `iterable__using_user_device_history`, which is set to `false`). You only need to add variables for the tables you would like to enable or disable respectively:

```yml
# dbt_project.yml

config-version: 2

vars:
    iterable__using_campaign_label_history: false                    # default is true
    iterable__using_user_unsubscribed_message_type_history: false    # default is true

    iterable__using_user_device_history: true                        # default is FALSE
```

### Deprecating `CAMPAIGN_SUPRESSION_LIST_HISTORY` table

The Iterable connector schema misspelled the `CAMPAIGN_SUPPRESSION_LIST_HISTORY` table as `CAMPAIGN_SUPRESSION_LIST_HISTORY` (note the singular `P`). Fivetran will deprecate the misspelled table by June 2021 and replace it with a new table with the correct name.

New connectors set up after June 2021 will have only the new table (`CAMPAIGN_SUPPRESSION_LIST_HISTORY`), and pre-existing connectors will contain both tables for a limited time. Fivetran will stop syncing the old `CAMPAIGN_SUPRESSION_LIST_HISTORY` table.

By default, this package refers to the new table (`CAMPAIGN_SUPPRESSION_LIST_HISTORY`). To change this so that the package works with the old misspelled source table, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

config-version: 2

vars:
    iterable_source:
        campaign_suppression_list_history: "{{ source('iterable', 'campaign_supression_list_history') }}" 
        using_old_spelling: true # default false
```

### Changing the Build Schema

By default, this package will build the Iterable staging models within a schema titled (<target_schema> + `_stg_iterable`) in your target database. If this is not where your would like you Iterable staging data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
models:
    iterable_source:
        +schema: my_new_schema_name # leave blank for just the target_schema
```

## Contributions

Additional contributions to this package are very welcome! Please create issues
or open PRs against `main`. See the 
[Discourse post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.

## Database Support
This package has been tested on BigQuery, Snowflake, Redshift, and Postgres.

## Resources:
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Have questions or feedback, or need help? Book a time during our office hours [here](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or shoot us an email at solutions@fivetran.com.
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn how to orchestrate dbt transformations with Fivetran [here](https://fivetran.com/docs/transformations/dbt).
- Learn more about Fivetran overall [in our docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
