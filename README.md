# Field Usage Monitoring and Optimization

## Overview
This Looker Block is designed to help Looker Admins gain deep insights into field usage within the **System Activity** data, enabling them to monitor and optimize instance performance.

## Key Features
1. **Unused LookML Fields**: Identify LookML fields that are never queried by users, allowing for model simplification.
2. **Granular Field Usage**: View LookML field usage across Dashboards, Looks, and Sources.
3. **Custom fields**: Detect custom dimensions, measures, and table calculations that are repeatedly used.
4. **Best Practices Compliance**: Highlight fields that do not adhere to LookML best practices for easier maintenance.
5. **Fields Used in Filters**: Identify fields most commonly used in filters to fine-tune models.
6. **Performance Insights**: Analyze fields involved in the longest-running queries for optimization.

## Setup Instructions
1. **Data Extraction**: This Block requires Looker System Activity data specific to your instance. Users must use the provided data extraction pipeline to populate the necessary dataset. No additional subscriptions are required.
2. **Database Configuration**: Configure a database connection to the project where your extracted System Activity dataset is stored.
3. **Install the Block**: Deploy this Block into your Looker instance.
4. **Verify Integration**: Field names in the Block are designed to match those in your dataset directly, ensuring seamless integration and minimal setup effort.

---

For additional assistance or troubleshooting, refer to the Looker documentation or contact your Looker admin.
