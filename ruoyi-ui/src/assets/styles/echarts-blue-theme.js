import * as echarts from 'echarts'

const deepBluePalette = [
  '#1A3F8A',
  '#2453A9',
  '#2F67C3',
  '#3B7BDA',
  '#4A8EE8',
  '#5FA2F2',
  '#78B7F8',
  '#97CCFC'
]

echarts.registerTheme('ruoyi-deep-blue', {
  color: deepBluePalette,
  backgroundColor: 'transparent',
  textStyle: {
    color: '#D4DDF4'
  },
  title: {
    textStyle: { color: '#DCE6FF' },
    subtextStyle: { color: '#8FA4D5' }
  },
  legend: {
    textStyle: { color: '#C6D5F5' }
  },
  tooltip: {
    backgroundColor: 'rgba(14, 25, 48, 0.95)',
    borderColor: '#2C4A83',
    textStyle: { color: '#E3ECFF' },
    axisPointer: {
      type: 'line',
      lineStyle: { color: '#5A86D7' },
      crossStyle: { color: '#5A86D7' },
      shadowStyle: { color: 'rgba(71, 113, 186, 0.25)' }
    }
  },
  categoryAxis: {
    axisLine: { lineStyle: { color: '#3A5F9D' } },
    axisTick: { lineStyle: { color: '#3A5F9D' } },
    axisLabel: { color: '#9FB4DE' },
    splitLine: { lineStyle: { color: 'rgba(67, 103, 165, 0.3)' } },
    splitArea: { areaStyle: { color: ['rgba(30, 56, 104, 0.06)', 'rgba(16, 33, 66, 0.03)'] } }
  },
  valueAxis: {
    axisLine: { lineStyle: { color: '#3A5F9D' } },
    axisTick: { lineStyle: { color: '#3A5F9D' } },
    axisLabel: { color: '#9FB4DE' },
    splitLine: { lineStyle: { color: 'rgba(67, 103, 165, 0.26)' } },
    splitArea: { areaStyle: { color: ['rgba(30, 56, 104, 0.06)', 'rgba(16, 33, 66, 0.03)'] } }
  },
  line: {
    symbolSize: 6,
    smooth: true,
    lineStyle: { width: 2 }
  },
  radar: {
    axisLine: { lineStyle: { color: 'rgba(92, 132, 201, 0.55)' } },
    splitLine: { lineStyle: { color: 'rgba(70, 109, 177, 0.45)' } },
    splitArea: {
      areaStyle: {
        color: [
          'rgba(23, 48, 96, 0.14)',
          'rgba(21, 44, 87, 0.1)',
          'rgba(16, 35, 72, 0.08)'
        ]
      }
    },
    name: { textStyle: { color: '#B8CAF0' } }
  },
  gauge: {
    axisLine: {
      lineStyle: {
        color: [
          [0.25, '#2F67C3'],
          [0.6, '#4A8EE8'],
          [1, '#78B7F8']
        ]
      }
    },
    axisLabel: { color: '#9FB4DE' },
    title: { color: '#C9D8F9' },
    detail: { color: '#E3ECFF' }
  }
})
