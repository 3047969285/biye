package com.ruoyi.system.service.impl;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.MeterPoint;
import com.ruoyi.system.mapper.MeterPointMapper;
import com.ruoyi.system.service.IMeterPointService;

/**
 * 电表点表
 */
@Service
public class MeterPointServiceImpl implements IMeterPointService {

    private final MeterPointMapper meterPointMapper;

    public MeterPointServiceImpl(MeterPointMapper meterPointMapper) {
        this.meterPointMapper = meterPointMapper;
    }

    @Override
    public MeterPoint selectById(Long pointId) {
        return meterPointMapper.selectMeterPointById(pointId);
    }

    @Override
    public List<MeterPoint> selectList(MeterPoint query) {
        return meterPointMapper.selectMeterPointList(query);
    }

    @Override
    public int insert(MeterPoint row) {
        if (StringUtils.isEmpty(row.getPointCode())) {
            throw new ServiceException("点编码不能为空");
        }
        if (meterPointMapper.selectByPointCode(row.getPointCode()) != null) {
            throw new ServiceException("点编码已存在：" + row.getPointCode());
        }
        row.setDelFlag("0");
        if (row.getStatus() == null) {
            row.setStatus("0");
        }
        if (row.getRegisterType() == null) {
            row.setRegisterType(0);
        }
        if (row.getDataType() == null) {
            row.setDataType("UINT16");
        }
        if (row.getWordSwap() == null) {
            row.setWordSwap("0");
        }
        if (row.getScale() == null) {
            row.setScale(BigDecimal.ONE);
        }
        if (row.getValueOffset() == null) {
            row.setValueOffset(BigDecimal.ZERO);
        }
        row.setCreateTime(new Date());
        return meterPointMapper.insertMeterPoint(row);
    }

    @Override
    public int update(MeterPoint row) {
        row.setUpdateTime(new Date());
        return meterPointMapper.updateMeterPoint(row);
    }

    @Override
    public int deleteByIds(Long[] pointIds) {
        return meterPointMapper.deleteMeterPointByIds(pointIds);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String importPoints(List<MeterPoint> list, boolean updateSupport, String operName) {
        if (list == null || list.isEmpty()) {
            throw new ServiceException("导入数据不能为空");
        }
        int ok = 0;
        int upd = 0;
        for (MeterPoint row : list) {
            if (StringUtils.isEmpty(row.getPointCode())) {
                continue;
            }
            MeterPoint exist = meterPointMapper.selectByPointCode(row.getPointCode());
            row.setDelFlag("0");
            if (row.getStatus() == null) {
                row.setStatus("0");
            }
            if (row.getRegisterType() == null) {
                row.setRegisterType(0);
            }
            if (row.getDataType() == null) {
                row.setDataType("UINT16");
            }
            if (row.getWordSwap() == null) {
                row.setWordSwap("0");
            }
            if (row.getScale() == null) {
                row.setScale(BigDecimal.ONE);
            }
            if (row.getValueOffset() == null) {
                row.setValueOffset(BigDecimal.ZERO);
            }
            row.setCreateBy(operName);
            row.setUpdateBy(operName);
            if (exist == null) {
                row.setCreateTime(new Date());
                meterPointMapper.insertMeterPoint(row);
                ok++;
            } else if (updateSupport) {
                row.setPointId(exist.getPointId());
                row.setUpdateTime(new Date());
                meterPointMapper.updateMeterPoint(row);
                upd++;
            }
        }
        return "新增 " + ok + " 条，更新 " + upd + " 条";
    }
}
