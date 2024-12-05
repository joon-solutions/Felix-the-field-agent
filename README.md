<p align="center">
  <img src="assets/README/image.png" width="200" alt="Logo">
</p>

---

# Felix the field agent

## I. Overview
Have you ever wondered which LookML fields are completely unused and could benefit from cleanup? 
Or perhaps you’ve noticed certain dynamic fields that are frequently used and would be better off hard-coded in LookML? 

The solution we provided is a comprehensive suite of tailored dashboards designed to enhance the monitoring of Looker activity. By leveraging the Looker API, we extract Looker System Activity data and enrich it with more granular details, which are then permanently stored in BigQuery. This robust framework enables thorough analysis of field usage and identification of optimization opportunities. 

## II. Key Features
### Actionable Dashboards:
1. **Monitoring Unused Fields**: Identify LookML fields that are never queried by users, allowing for cleanup.
<img width="947" alt="image" src="https://github.com/user-attachments/assets/8cc4ac6e-906f-42dc-97f8-3836a5c07686">

2. **Impact Analysis of Field Usage**: View LookML field usage across Dashboards, Looks.
<img width="906" alt="image" src="https://github.com/user-attachments/assets/1ae3d94e-2c93-4c38-9e8b-bfa38e689b92">

3. **Dynamic Field Analysis**: Detect custom dimensions, measures, and table calculations that are repeatedly used.
<img width="950" alt="Dynamic fields" src="https://github.com/user-attachments/assets/2b124690-be2a-4bea-8f0a-46ec88e8e6f3">

4. **Fields that do not follow LookML best practices**: Highlight fields that do not adhere to LookML best practices for easier maintenance.
<img width="894" alt="image" src="https://github.com/user-attachments/assets/4f723b36-cd5c-4238-b61b-066cc447d48b">

5. **Fields Used in Filters**: 
- Leverage partitioning and clustering on fields that are mostly used in report filters to optimize Looker performance and query costs.
- Analyze fields involved in the longest-running queries for optimization.
<img width="941" alt="image" src="https://github.com/user-attachments/assets/85d72ef4-4773-4096-8eb3-0b372273baa1">

### Robust Extraction Pipeline:
The extraction script provided will allow you extract:
- LookML fields, views and explores directly from LookML projects
- Looker System Activity views using Looker API

## III. Setup Instructions
1. **Data Extraction**:
- This Block requires Looker System Activity data specific to your instance. You must use the provided data extraction pipeline [HERE](https://github.com/joon-solutions/Felix-the-field-agent/blob/main/extraction/README.md) to populate the necessary dataset.
- No additional subscriptions are required.
2. **Database Configuration**: Configure a database connection to the project where your extracted System Activity dataset is stored.
3. **Install the Block**: Deploy this Block into your Looker instance.
4. **Verify Integration**: Field names in the Block are designed to match those in your dataset directly, ensuring seamless integration and minimal setup effort.
