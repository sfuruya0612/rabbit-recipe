import { createMuiTheme, Theme } from '@material-ui/core/styles'
import orange from '@material-ui/core/colors/orange'
import green from '@material-ui/core/colors/green'

const configureTheme = (env: string): Theme => {
  const t = {
    production: {
      palette: {
        primary: {
          main: orange[500],
        },
        secondary: {
          main: orange[400],
        },
      },
    },
    development: {
      palette: {
        primary: {
          main: green[600],
        },
        secondary: {
          main: green[500],
        },
      },
    },
  }
  if (!(env in t)) {
    return createMuiTheme(t['development'])
  }

  return createMuiTheme(t[env as keyof typeof t])
}

export default configureTheme
