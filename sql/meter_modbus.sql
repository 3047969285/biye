-- 电表 Modbus 点表与采样（执行前请备份数据库）
-- MySQL 8+

DROP TABLE IF EXISTS meter_sample;
DROP TABLE IF EXISTS meter_point;

CREATE TABLE meter_point (
  point_id       BIGINT       NOT NULL AUTO_INCREMENT COMMENT '点ID',
  point_code     VARCHAR(64)  NOT NULL COMMENT '点编码（唯一）',
  point_name     VARCHAR(128) DEFAULT NULL COMMENT '点名称',
  slave_id       INT          NOT NULL DEFAULT 1 COMMENT '从站地址',
  addr_offset    INT          NOT NULL COMMENT '寄存器偏移（相对基址，0 起）',
  register_type  TINYINT      NOT NULL DEFAULT 0 COMMENT '0 保持寄存器 FC03 1 输入寄存器 FC04',
  data_type      VARCHAR(16)  NOT NULL DEFAULT 'UINT16' COMMENT 'UINT16 INT16 UINT32 INT32 FLOAT32',
  word_swap      CHAR(1)      DEFAULT '0' COMMENT 'FLOAT32 是否字交换 0否 1是',
  scale          DECIMAL(18,8) DEFAULT 1 COMMENT '工程系数',
  value_offset   DECIMAL(18,8) DEFAULT 0 COMMENT '工程加偏',
  unit           VARCHAR(32)  DEFAULT NULL COMMENT '单位',
  sort_order     INT          DEFAULT 0 COMMENT '排序',
  status         CHAR(1)      DEFAULT '0' COMMENT '0正常 1停用',
  del_flag       CHAR(1)      DEFAULT '0' COMMENT '0存在 2删除',
  create_by      VARCHAR(64)  DEFAULT NULL,
  create_time    DATETIME     DEFAULT NULL,
  update_by      VARCHAR(64)  DEFAULT NULL,
  update_time    DATETIME     DEFAULT NULL,
  remark         VARCHAR(500) DEFAULT NULL,
  PRIMARY KEY (point_id),
  UNIQUE KEY uk_meter_point_code (point_code),
  KEY idx_meter_point_slave (slave_id, register_type, addr_offset)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='电表 Modbus 点表';

CREATE TABLE meter_sample (
  sample_id    BIGINT   NOT NULL AUTO_INCREMENT COMMENT '采样ID',
  point_id     BIGINT   NOT NULL COMMENT '点ID',
  read_time    DATETIME NOT NULL COMMENT '读数时间',
  value_raw    BIGINT   DEFAULT NULL COMMENT '原始整型（多寄存器拼成）',
  value_scaled DOUBLE   DEFAULT NULL COMMENT '工程值',
  source       VARCHAR(32) DEFAULT NULL COMMENT '来源 TCP_JSON HTTP 等',
  PRIMARY KEY (sample_id),
  KEY idx_meter_sample_point_time (point_id, read_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='电表采样明细';

-- 若依菜单权限标识（在「系统管理-菜单管理」中配置按钮权限后分配给角色）：
-- meter:point:list / meter:point:query / meter:point:add / meter:point:edit / meter:point:remove / meter:point:import
-- meter:data:ingest
