--8<-- "snippets/send-bizevent/2-getting-started.js"
--8<-- "snippets/requirements.md"

## Prerequisites

You will need full administrator access to a Dynatrace SaaS tenant with a DPS license.

* Enable OpenTelemetry OneAgent Features
* Enable Log Enrichment OneAgent Features
* Generate Dynatrace API Tokens for Kubernetes Observability

### Enable OpenTelemetry OneAgent Features

The demo application in this lab, AstroShop, contains OpenTelemetry instrumentation that can be picked up by OneAgent.

Navigate to the `Settings Classic` app in the Dynatrace tenant.  Open `OneAgent Features` from the **Preferences** sub-menu.  Search for features that contain the word `OpenTelemetry`.  Enable all OneAgent features for OpenTelemetry.

![OpenTelemetry OneAgent Features](./img/getting-started_dynatrace_oneagent_features_opentelemetry.png)

### Enable Log Enrichment OneAgent Features

Dynatrace can enrich your ingested log data with additional information that helps Dynatrace to recognize, correlate, and evaluate the data. Log enrichment results in a more refined analysis of your logs.  Log enrichment enables you to seamlessly switch context and analyze individual spans, transactions, or entire workloads.

Navigate to the `Settings Classic` app in the Dynatrace tenant.  Open `OneAgent Features` from the **Preferences** sub-menu.  Search for features that contain the words `enrichment for`.  Enable all OneAgent features for Log Enrichment.

![Log Enrichment OneAgent Features](./img/getting-started_dynatrace_oneagent_features_enrichment.png)

### Generate Dynatrace API Tokens

Access tokens are used to authenticate and authorize API calls, ensuring that only authorized services can interact with your Dynatrace environment. In the context of Dynatrace Operator for Kubernetes, two types of tokens are required:

**Operator token**

The Operator token (former API token) is used by the Dynatrace Operator to manage settings and the lifecycle of all Dynatrace components in the Kubernetes cluster.

**Data Ingest token**

The data ingest token is used to enrich and send additional observability signals (for example, custom metrics) from your Kubernetes cluster to Dynatrace.

Repeat the following steps for both the `Operator` and `Data Ingest` tokens:

* Go to Access Tokens.
* Select Generate new token.
* Provide a meaningful name for the token.
* Enable the required permissions for the token.
    - For the Operator token, select the template in Template > Kubernetes: Dynatrace Operator. This will automatically add the required scopes ([see Operator token](https://docs.dynatrace.com/docs/ingest-from/setup-on-k8s/deployment/tokens-permissions#operatorToken){target=_blank})
    - For the Data Ingest token, select the template in Template > Kubernetes: Data Ingest. This will automatically add the required scopes ([see Data Ingest token](https://docs.dynatrace.com/docs/shortlink/installation-k8s-tokens-permissions#dataIngestToken){target=_blank})
* Select Generate token to create the token.
* Ensure to copy the token and store it in a secure place.  We recommend storing it in a Dynatrace Notebook.

## Continue

In the next section, we'll launch our Codespaces instance.

<div class="grid cards" markdown>
- [Continue to Codespaces:octicons-arrow-right-24:](3-codespaces.md)
</div>
