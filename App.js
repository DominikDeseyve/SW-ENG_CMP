//This is an example code for NavigationDrawer//
import React, { Component } from 'react';
//import react in our code.
import { View, Image, TouchableOpacity, StyleSheet, SafeAreaView, Text } from 'react-native';
// import all basic components
 
 
//For React Navigation 4+
import {createDrawerNavigator} from 'react-navigation-drawer';
//import { createBottomTabNavigator } from 'react-navigation-tabs';
//import { createBottomTabNavigator, createAppContainer} from 'react-navigation-material-bottom-tabs';  
import { createMaterialTopTabNavigator} from 'react-navigation-tabs'; 
import { createAppContainer} from 'react-navigation'; 
import {createStackNavigator} from 'react-navigation-stack';
import Ionicons from 'react-native-vector-icons/Ionicons'

import HomeScreen from './pages/HomeScreen';
import PlaylistScreen from './pages/PlaylistScreen';
import SearchScreen from './pages/SearchScreen';
import SettingsScreen from './pages/SettingsScreen';

const styles = StyleSheet.create({
  bottomLabel: {
    fontSize: 10,
    //fontFamily: 'Lato',
    marginTop: 10,
    color: '#000'
  }
});

const AppTabNavigator = createMaterialTopTabNavigator({
  Home: {
    screen: HomeScreen,
    navigationOptions: {
      tabBarLabel: ({ tintColor }) => (
        <Text style={[styles.bottomLabel, {color: tintColor}]}>Home</Text>
      ),
      tabBarIcon: ({ tintColor }) => (
        <Ionicons name="md-home" color={tintColor} size={30} />
      ),
      activeColor: '#615af6',  
      inactiveColor: '#46f6d7',  
      barStyle: { backgroundColor: '#67baf6' },  
    }
  },
  Playlist: {
    screen: PlaylistScreen,
    navigationOptions: {
      tabBarLabel: ({ tintColor }) => (
        <Text style={[styles.bottomLabel, {color: tintColor}]}>Playlist</Text>
      ),
      tabBarIcon: ({ tintColor }) => (
        <Ionicons name="md-play" color={tintColor} size={30} />
      ),
      activeColor: '#615af6',  
      inactiveColor: '#46f6d7',  
      barStyle: { backgroundColor: '#67baf6' },  
    }
  },
  Search: {
    screen: SearchScreen,
    navigationOptions: {
      tabBarLabel: ({ tintColor }) => (
        <Text style={[styles.bottomLabel, {color: tintColor}]}>Search</Text>
      ),
      tabBarIcon: ({ tintColor }) => (
        <Ionicons name="md-search" color={tintColor} size={30} />
      ),
      activeColor: '#615af6',  
      inactiveColor: '#46f6d7',  
      barStyle: { backgroundColor: '#67baf6' },  
    }
  },
  Search: {
    screen: SearchScreen,
    navigationOptions: {
      tabBarLabel: ({ tintColor }) => (
        <Text style={[styles.bottomLabel, {color: tintColor}]}>Search</Text>
      ),
      tabBarIcon: ({ tintColor }) => (
        <Ionicons name="md-search" color={tintColor} size={30} />
      ),
      activeColor: '#615af6',  
      inactiveColor: '#46f6d7',  
      barStyle: { backgroundColor: '#67baf6' },  
    }
  },
  Settings: {
    screen: SettingsScreen,
    navigationOptions: {
      tabBarLabel: ({ tintColor }) => (
        <Text style={[styles.bottomLabel, {color: tintColor}]}>Settings</Text>
      ),
      tabBarIcon: ({ tintColor }) => (
        <Ionicons name="md-settings" color={tintColor} size={30} />
      ),
      activeColor: '#615af6',  
      inactiveColor: '#46f6d7',  
      barStyle: { backgroundColor: '#67baf6' },  
    }
  }
}, {
    initialRouteName: 'Home',  
    // order: ['Settings', 'Home'],    
    //headerMode: 'none',
    tabBarPosition: 'bottom',
    swipeEnabled: true,
    animationEnabled: true,   
    shifting: true,  
    labeled: true, 
    tabBarOptions: {            
      activeTintColor: '#ff6600',
      inactiveTintColor: 'grey',
      pressColor: '#DEDEDE',    //ripple effect
      style: {        
        backgroundColor: '#FFF',
        borderTopWidth: 0.5,
        borderTopColor: 'grey'
      },      
      indicatorStyle: {
        height: 3,
        top: -1,
        backgroundColor: '#ff6600',
      },          
      showIcon: true,
      //showLabel: false,
    }    
});

export default createAppContainer(AppTabNavigator);

