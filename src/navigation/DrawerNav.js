import React, { Component } from 'react';
import { View, Text } from 'react-native';
import {DrawerNavigator} from 'react-navigation';
import ScreenA from '../../pages/Screen1';
import ScreenB from '../../pages/Screen1';
import ScreenC from '../../pages/Screen1';
import drawerContentComponents from './drawerContentComponents';


export const DrawerNav = DrawerNavigator (
    {
        ScreenA:{ screen: ScreenA },
        ScreenB:{ screen: ScreenB },
        ScreenC:{ screen: ScreenC }
    },
    {
       contentComponent: drawerContentComponents
    }
);