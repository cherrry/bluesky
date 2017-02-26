import React from 'react'
import { render } from 'react-dom'
import { Provider } from 'react-redux'

import App from './App'
import Store from './Store'

render(
  <Provider store={Store}>
    <App />
  </Provider>,
  document.getElementById('root')
)
