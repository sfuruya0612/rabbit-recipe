import React from 'react'
import { Switch, Route } from 'react-router-dom'

import { Home } from './Home'
import { Dashboard } from './Dashboard'

const AppRouter: React.FC<{}> = (): React.ReactElement => {
  return (
    <Switch>
      <Route path="/" exact component={Home} />
      <Route path="/dashboard" exact component={Dashboard} />
    </Switch>
  )
}

export { AppRouter }
