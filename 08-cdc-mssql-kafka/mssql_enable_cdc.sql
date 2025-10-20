-- Enable CDC at database level
USE [YourDb];
EXEC sys.sp_cdc_enable_db;

-- Enable CDC for a table
EXEC sys.sp_cdc_enable_table
  @source_schema = N'dbo',
  @source_name   = N'orders',
  @role_name     = NULL,
  @supports_net_changes = 0;

-- Verify
SELECT * FROM sys.tables WHERE is_tracked_by_cdc = 1;
SELECT * FROM cdc.change_tables;

