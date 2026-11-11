-- Optional menu entry for 运维指挥大屏 (constant route /ops/screen also works without this).
-- Run against ry-vue after biye.sql if you want a sidebar item.

INSERT INTO sys_menu (
  menu_id, menu_name, parent_id, order_num, path, component, query, route_name,
  is_frame, is_cache, menu_type, visible, status, perms, icon,
  create_by, create_time, update_by, update_time, remark
)
SELECT
  230, '运维指挥大屏', 0, 1, 'ops-screen-entry', 'ops/screen/menuEntry', '', 'OpsScreenEntry',
  1, 1, 'C', '0', '0', '', 'monitor',
  'admin', NOW(), '', NULL, '侧栏入口，跳转全屏常量路由 /ops/screen'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 230);

-- Grant to role 1 (admin) when present
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 1, 230 FROM DUAL
WHERE EXISTS (SELECT 1 FROM sys_role WHERE role_id = 1)
  AND NOT EXISTS (SELECT 1 FROM sys_role_menu WHERE role_id = 1 AND menu_id = 230);
