-- 添加智能运维表单生成菜单（独立顶级菜单，与智能问答同级）

-- 删除可能存在的旧菜单
DELETE FROM sys_role_menu WHERE menu_id IN (201, 2011, 2012, 2013);
DELETE FROM sys_menu WHERE menu_id IN (201, 2011, 2012, 2013);

-- 添加智能运维表单生成主菜单（顶级菜单）
insert into sys_menu values('201', '智能运维表单生成', '0', '4', 'maintenance-form', 'ai/maintenance-form/index', '', '', 1, 0, 'C', '0', '0', 'ai:maintenance:form', 'form', 'admin', sysdate(), '', null, '智能运维表单生成菜单');

-- 添加按钮权限
insert into sys_menu values('2011', '查询', '201', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'ai:maintenance:form:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2012', '生成', '201', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'ai:maintenance:form:generate', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2013', '保存', '201', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'ai:maintenance:form:save', '#', 'admin', sysdate(), '', null, '');

-- 为角色分配权限
insert into sys_role_menu values ('1', '201');
insert into sys_role_menu values ('1', '2011');
insert into sys_role_menu values ('1', '2012');
insert into sys_role_menu values ('1', '2013');
insert into sys_role_menu values ('2', '201');
insert into sys_role_menu values ('2', '2011');
insert into sys_role_menu values ('2', '2012');
insert into sys_role_menu values ('2', '2013');
