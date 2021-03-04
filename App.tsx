/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * Generated with the TypeScript template
 * https://github.com/react-native-community/react-native-template-typescript
 *
 * @format
 */

import React, { Component } from 'react';
import {
  SafeAreaView,
  StyleSheet,
  View,
  Text,
  Alert,
  NativeEventEmitter,
  NativeModules
} from 'react-native';

const eventEmitter = new NativeEventEmitter(NativeModules.EventEmitter);
const styles = StyleSheet.create({
  status: {
    alignItems: 'center',
    justifyContent: 'center'
  }
})

class App extends Component<{}, { status: string }> {
  constructor(props: any) {
    super(props);
    this.state = { status: "Unknown" };
  }

  createAlert = (caller: string) =>
  Alert.alert(
    "Incoming call from",
    caller,
    [
      {
        text: "Cancel",
        onPress: () => NativeModules.CallManager.callRejected(),
        style: "cancel"
      },
      { text: "OK",
       onPress: () => NativeModules.CallManager.callAccepted()
      }
    ],
    { cancelable: false }
  );

  componentDidMount() {
    eventEmitter.addListener('onStatusChange', (data) => {
      this.setState({status: data.status});
    });

    eventEmitter.addListener('onIncomingCall', (data) => {
      this.createAlert(data.caller);
    });
  }

  componentWillUnmount() {
    eventEmitter.removeAllListeners('onStatusChange');
    eventEmitter.removeAllListeners('onStatusChange');
  }

  render() {
    return (
      <SafeAreaView>
        <View style={styles.status}>
          <Text>
            {this.state.status}
          </Text>
        </View>
      </SafeAreaView>
    );
  }
}

export default App;