import React from 'react'
import makeStyles from '@material-ui/styles/makeStyles'
import { Theme } from '@material-ui/core/styles/createMuiTheme'
import AppBar from '@material-ui/core/AppBar'
import Toolbar from '@material-ui/core/Toolbar'
import Typography from '@material-ui/core/Typography'
import deepOrange from '@material-ui/core/colors/deepOrange'
import { Link } from 'react-router-dom'

const env = process.env.NODE_ENV

// eslint-disable-next-line @typescript-eslint/explicit-function-return-type, @typescript-eslint/no-unused-vars
const useStyles = makeStyles((theme: Theme) => ({
  root: {
    flexGrow: 1,
  },
  appBar: {
    zIndex: theme.zIndex.drawer + 1,
  },
  brand: {
    textDecoration: 'none',
    flexGrow: 1,
  },
  avatar: {
    color: '#fff',
    backgroundColor: deepOrange[500],
  },
}))

const Header = (): React.ReactElement => {
  const classes = useStyles()

  let name = 'Rabbit Recipe'
  if (env === 'development') {
    name += '[' + env + ']'
  }

  return (
    <div className={classes.root}>
      <AppBar position="fixed" className={classes.appBar}>
        <Toolbar>
          <Typography
            className={classes.brand}
            variant="h6"
            color="inherit"
            // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
            component={(props) => <Link to="/" {...props} />}
          >
            {name}
          </Typography>
        </Toolbar>
      </AppBar>
    </div>
  )
}

export { Header }
