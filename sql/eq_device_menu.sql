-- 设备管理菜单 SQL
-- 主菜单：设备管理
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('设备管理', 2019, 1, 'device', 'equipment/device/index', 1, 0, 'C', '0', '0', 'equipment:device:list', 'component', 'admin', sysdate(), '', null, '设备信息管理菜单');

-- 获取刚插入的菜单ID（需要手动替换下面的 @parent_id）
SET @parent_id = LAST_INSERT_ID();

-- 子菜单：查询
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('设备查询', @parent_id, 1, '#', '', 1, 0, 'F', '0', '0', 'equipment:device:query', '#', 'admin', sysdate(), '', null, '');

-- 子菜单：新增
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('设备新增', @parent_id, 2, '#', '', 1, 0, 'F', '0', '0', 'equipment:device:add', '#', 'admin', sysdate(), '', null, '');

-- 子菜单：修改
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('设备修改', @parent_id, 3, '#', '', 1, 0, 'F', '0', '0', 'equipment:device:edit', '#', 'admin', sysdate(), '', null, '');

-- 子菜单：删除
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('设备删除', @parent_id, 4, '#', '', 1, 0, 'F', '0', '0', 'equipment:device:remove', '#', 'admin', sysdate(), '', null, '');

-- 子菜单：导出
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('设备导出', @parent_id, 5, '#', '', 1, 0, 'F', '0', '0', 'equipment:device:export', '#', 'admin', sysdate(), '', null, '');
