-- ============================================
-- Migration: normalize deparment -> department
-- Description: fix menu path, perms and legacy logs
-- ============================================

-- 1) Backend permission points and route path
UPDATE sys_menu
SET perms = REPLACE(perms, 'deparment:department', 'department:department')
WHERE perms LIKE 'deparment:department%';

UPDATE sys_menu
SET path = 'department'
WHERE path = 'deparment';

-- 2) Historical operation logs (for search consistency)
UPDATE sys_oper_log
SET method = REPLACE(method, 'com.ruoyi.deparment.', 'com.ruoyi.department.')
WHERE method LIKE 'com.ruoyi.deparment.%';

UPDATE sys_oper_log
SET oper_url = REPLACE(oper_url, '/deparment/department', '/department/department')
WHERE oper_url LIKE '%/deparment/department%';
