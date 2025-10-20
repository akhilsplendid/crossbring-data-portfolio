use role <ACCOUNTADMIN_OR_ROLE_WITH_PRIVS>;

create or replace storage integration s3_int
  type = external_stage
  storage_provider = s3
  enabled = true
  storage_aws_role_arn = '<AWS_IAM_ROLE_ARN>'
  storage_allowed_locations = ('s3://<your-bucket>/iceberg/');

create or replace external volume ev_iceberg
  storage_integration = s3_int
  location = 's3://<your-bucket>/iceberg/';

create database if not exists DATA_PRODUCTS;
create schema if not exists DATA_PRODUCTS.ICEBERG_DEMO;

