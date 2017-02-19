import './App.css'

import React from 'react'
import { Line as LineChart } from 'react-chartjs-2'
import { Container, Menu, Segment } from 'semantic-ui-react'

const chartProps = {
  data: {
    datasets: [
      {
        label: "Particle A",
        data: [
          { x: 1000, y: 20 },
          { x: 1100, y: 50 },
          { x: 1300, y: 40 },
          { x: 1500, y: 40 },
          { x: 1800, y: 45 },
          { x: 2000, y: 10 }
        ]
      },
      {
        label: "Particle B",
        data: [
          { x: 1000, y: 200 },
          { x: 1100, y: 500 },
          { x: 1300, y: 400 },
          { x: 1500, y: 400 },
          { x: 1800, y: 450 },
          { x: 2000, y: 100 }
        ]
      }
    ]
  },
  options: {
    scales: {
      yAxes: [{
        ticks: { min: 0, max: 500 },
        gridLines: {}
      }],
      xAxes: [{
        type: 'time',
        time: {
          unit: 'second',
          min: 0,
          max: 2000
        }
      }]
    }
  }
}

function App() {
  return (
    <div>
      <Container fluid as={Menu} color="blue" inverted fixed="top" stackable>
        <Menu.Item>BlueSky</Menu.Item>
      </Container>
      <Container fluid as={Segment} basic className="main">
        <LineChart {...chartProps} />
      </Container>
    </div>
  )
}

export default App
