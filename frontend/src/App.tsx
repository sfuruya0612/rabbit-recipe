import React from 'react'
import { ThemeProvider } from '@material-ui/core/styles'
import { BrowserRouter } from 'react-router-dom'

import configureTheme from './components/ConfigureTheme'
import { AppLayout } from './components/AppLayout'

const theme = configureTheme(process.env.NODE_ENV || 'development')

const App: React.FC<{}> = (): React.ReactElement => (
  <ThemeProvider theme={theme}>
    <BrowserRouter>
      <AppLayout />
    </BrowserRouter>
  </ThemeProvider>
)

export default App
