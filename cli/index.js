require('dotenv').config()

const blessed = require('blessed')
const contrib = require('blessed-contrib')
const fetch = require('node-fetch')
const moment = require('moment')

const screen = blessed.screen()
const lineChart = contrib.line({
  style: {
    width: '100%',
    height: '100%'
  },
  showLegend: true,
  wholeNumbersOnly: false,
  label: 'BlueSky Monitor'
})

screen.append(lineChart)
screen.key(['escape', 'q', 'C-c'], function(ch, key) {
  return process.exit(0)
})

function loop() {
  const currentTime = (+new Date()) / 1000 | 0
  const lastHour = currentTime - 3600

  fetch(process.env.API_HOST + '/get/home/interval/' + lastHour + '/' + currentTime)
    .then(function (response) {
      return response.json()
    })
    .then(function (data) {
      return data.sort(function (e1, e2) {
        return e1.timestamp - e2.timestamp
      })
    })
    .then(function (data) {
      let timestamps = data.map(function (epoch) {
        return moment(epoch.timestamp * 1000).format('HH:mm')
      })
      let renderData = [
        { title: 'PM 1.0', x: timestamps, y: [], style: { line: 'red' } },
        { title: 'PM 2.5', x: timestamps, y: [], style: { line: 'yellow' } },
        { title: 'PM 10', x: timestamps, y: [], style: { line: 'green' } }
      ]
      data.forEach(function (epoch) {
        const readings = epoch.readings
        renderData[0].y.push(readings['pm1.0'])
        renderData[1].y.push(readings['pm2.5'])
        renderData[2].y.push(readings['pm10'])
      })
      return renderData
    })
    .then(function (data) {
      lineChart.setData(data)
      screen.render()
      setTimeout(loop, 30 * 1000)
    })
}

loop()
