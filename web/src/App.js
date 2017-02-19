import './App.css'

import React from 'react'
import { Container, Menu, Segment } from 'semantic-ui-react'

function App() {
  return (
    <div>
      <Container fluid as={Menu} color="blue" inverted fixed="top" stackable>
        <Menu.Item>BlueSky</Menu.Item>
      </Container>
      <Container fluid as={Segment} basic className="main">
        Put chart here.
      </Container>
    </div>
  )
}

export default App
