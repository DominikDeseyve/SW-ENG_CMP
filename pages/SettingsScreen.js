//This is an example code for NavigationDrawer//
import React, { Component } from 'react';
//import react in our code.
import { StyleSheet, View, Text } from 'react-native';
// import all basic components

import {Header} from 'react-native-elements';
 
export default class SettingsScreen extends Component {
  //Screen1 Component
  render() {
    return (
      <View>
       <Header   
          leftComponent={{ icon: 'home', color: '#fff' }}     
          centerComponent={{ text: 'Settings', style: { color: '#fff', fontSize: 16} }}    
        />
        <View style={styles.MainContainer}>
          <Text style={{ fontSize: 23 }}> Settings</Text>
        </View>        
      </View>
    );
  }
}
 
const styles = StyleSheet.create({
  MainContainer: {
    flex: 1,
    paddingTop: 20,
    alignItems: 'center',
    marginTop: 50,
    justifyContent: 'center',
  },
});