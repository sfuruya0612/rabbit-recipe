import React from 'react'
import Typography from '@material-ui/core/Typography'
import Paper from '@material-ui/core/Paper'
import { Theme } from '@material-ui/core/styles/createMuiTheme'
import { makeStyles } from '@material-ui/styles'
import Button from '@material-ui/core/Button'
import { Link } from 'react-router-dom'

// eslint-disable-next-line @typescript-eslint/explicit-function-return-type
const useStyles = makeStyles((theme: Theme) => ({
  root: theme.mixins.gutters({
    paddingTop: 16,
    paddingBottom: 16,
    marginTop: theme.spacing(3),
  }),
}))

const Home: React.FC<{}> = (): React.ReactElement | null => {
  const classes = useStyles()

  return (
    <React.Fragment>
      <Paper className={classes.root}>
        <Typography variant="h2" gutterBottom>
          Rabbit Recipe
        </Typography>
        <Typography> {`ログインしています`} </Typography>

        <Button component={Link} to={`/dashboard/`}>
          DashBoard
        </Button>
      </Paper>
    </React.Fragment>
  )
}

export { Home }
