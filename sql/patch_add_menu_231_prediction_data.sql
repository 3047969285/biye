-- 增量：在「数据获取」(parent_id=210) 下增加「预测数据」菜单。
-- 若 sys_menu 中已存在 menu_id=231，请改为未占用的 id 后再执行。
INSERT INTO sys_menu (
  menu_id, menu_name, parent_id, order_num, path, component, query, route_name,
  is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark
) VALUES (
  231, '预测数据', 210, 17, 'prediction-data', 'equipment/predictionData/index', NULL, '',
  1, 0, 'C', '0', '0', 'equipment:prediction:list', 'chart', 'admin', NOW(), '', NULL, '数据获取-预测数据（eq_prediction）'
) ON DUPLICATE KEY UPDATE
  menu_name = VALUES(menu_name),
  parent_id = VALUES(parent_id),
  order_num = VALUES(order_num),
  path = VALUES(path),
  component = VALUES(component),
  perms = VALUES(perms),
  icon = VALUES(icon),
  remark = VALUES(remark);
