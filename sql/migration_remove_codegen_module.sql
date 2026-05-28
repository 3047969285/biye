-- ============================================
-- Migration: remove code-generation module data
-- Description: drop codegen metadata tables and menu entries
-- ============================================

-- 1) Remove code-generation menu and permission points
DELETE FROM sys_menu WHERE menu_id = 100 OR parent_id = 100;
DELETE FROM sys_role_menu WHERE menu_id = 100;

-- 2) Remove code-generation metadata tables
DROP TABLE IF EXISTS gen_table_column;
DROP TABLE IF EXISTS gen_table;
