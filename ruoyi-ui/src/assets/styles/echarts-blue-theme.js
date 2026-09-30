import * as echarts from 'echarts'

const energyPalette = [
  '#E98235',
  '#527382',
  '#7E9B72',
  '#D49A3F',
  '#C96D5D',
  '#70899A',
  '#A98261',
  '#6C9081'
]

echarts.registerTheme('ruoyi-deep-blue', {
  color: energyPalette,
  backgroundColor: 'transparent',
  textStyle: {
    color: '#555e63'
  },
  title: {
    textStyle: { color: '#252b2f' },
    subtextStyle: { color: '#7a8286' }
  },
  legend: {
    textStyle: { color: '#666d73' }
  },
  tooltip: {
    backgroundColor: 'rgba(255, 255, 255, 0.98)',
    borderColor: '#e8e3db',
    textStyle: { color: '#30363a' },
    axisPointer: {
      type: 'line',
      lineStyle: { color: '#e98235' },
      crossStyle: { color: '#e98235' },
      shadowStyle: { color: 'rgba(109, 118, 119, 0.12)' }
    }
  },
  categoryAxis: {
    axisLine: { lineStyle: { color: '#d8d2c9' } },
    axisTick: { lineStyle: { color: '#d8d2c9' } },
    axisLabel: { color: '#7b8386' },
    splitLine: { lineStyle: { color: 'rgba(92, 99, 97, 0.12)' } },
    splitArea: { areaStyle: { color: ['rgba(233, 130, 53, 0.025)', 'rgba(82, 115, 130, 0.018)'] } }
  },
  valueAxis: {
    axisLine: { lineStyle: { color: '#d8d2c9' } },
    axisTick: { lineStyle: { color: '#d8d2c9' } },
    axisLabel: { color: '#7b8386' },
    splitLine: { lineStyle: { color: 'rgba(92, 99, 97, 0.12)' } },
    splitArea: { areaStyle: { color: ['rgba(233, 130, 53, 0.025)', 'rgba(82, 115, 130, 0.018)'] } }
  },
  line: {
    symbolSize: 6,
    smooth: true,
    lineStyle: { width: 2 }
  },
  radar: {
    axisLine: { lineStyle: { color: 'rgba(132, 139, 134, 0.45)' } },
    splitLine: { lineStyle: { color: 'rgba(132, 139, 134, 0.25)' } },
    splitArea: {
      areaStyle: {
        color: [
          'rgba(233, 130, 53, 0.09)',
          'rgba(82, 115, 130, 0.06)',
          'rgba(126, 155, 114, 0.045)'
        ]
      }
    },
    name: { textStyle: { color: '#6a7276' } }
  },
  gauge: {
    axisLine: {
      lineStyle: {
        color: [
          [0.25, '#e98235'],
          [0.6, '#d49a3f'],
          [1, '#7e9b72']
        ]
      }
    },
    axisLabel: { color: '#7b8386' },
    title: { color: '#666d73' },
    detail: { color: '#252b2f' }
  }
})
