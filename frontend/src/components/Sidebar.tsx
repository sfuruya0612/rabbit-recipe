import React from 'react'
import { Link } from 'react-router-dom'
import { createStyles, Theme, makeStyles } from '@material-ui/core/styles'
import Drawer from '@material-ui/core/Drawer'
import List from '@material-ui/core/List'
import Divider from '@material-ui/core/Divider'
import ListItem from '@material-ui/core/ListItem'
import ListItemIcon from '@material-ui/core/ListItemIcon'
import ListItemText from '@material-ui/core/ListItemText'

import DashboardIcon from '@material-ui/icons/Dashboard'
import LibraryBooksIcon from '@material-ui/icons/LibraryBooks'
import SettingsIcon from '@material-ui/icons/Settings'

const drawerWidth = 240

// eslint-disable-next-line @typescript-eslint/explicit-function-return-type
const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    drawer: {
      flexShrink: 0,
    },
    drawerPaper: {
      width: drawerWidth,
    },
    toolbar: theme.mixins.toolbar,
  }),
)

interface MenuItemType {
  title: string
  icon: React.ReactElement | null
  href: string
}

const USER_MENU: MenuItemType[] = [
  {
    title: 'Account',
    icon: null,
    href: '/user',
  },
]

const APP_MENU: MenuItemType[] = [
  {
    title: 'Dashboard',
    icon: <DashboardIcon />,
    href: '/dashboard',
  },
  {
    title: 'Recipes',
    icon: <LibraryBooksIcon />,
    href: '/recipes',
  },
]

const ADMIN_MENU: MenuItemType[] = [
  {
    title: 'Settings',
    icon: <SettingsIcon />,
    href: '/settings',
  },
]

function mapMenuItems(menuItems: MenuItemType[]): React.ReactElement[] {
  return menuItems.map(
    (menu): React.ReactElement => (
      <ListItem
        button
        // eslint-disable-next-line @typescript-eslint/explicit-function-return-type
        component={Link}
        to={menu.href}
        key={menu.href}
      >
        {menu.icon === null ? null : <ListItemIcon>{menu.icon}</ListItemIcon>}

        <ListItemText primary={menu.title} />
      </ListItem>
    ),
  )
}

const Sidebar = (): React.ReactElement => {
  const classes = useStyles()
  return (
    <Drawer
      className={classes.drawer}
      variant="permanent"
      classes={{
        paper: classes.drawerPaper,
      }}
      anchor="left"
    >
      <div className={classes.toolbar} />
      <List>
        {mapMenuItems(USER_MENU)}
        <Divider />
        {mapMenuItems(APP_MENU)}
        <Divider />
        {mapMenuItems(ADMIN_MENU)}
        <Divider />
      </List>
    </Drawer>
  )
}

export { Sidebar }
