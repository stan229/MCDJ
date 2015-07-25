/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

var React = require('react-native');
var MediaController = require('NativeModules').MediaController;

var {
  AppRegistry,
  StyleSheet,
  Text,
  TouchableHighlight,
  View,
  NativeAppEventEmitter
} = React;

class MCDJ extends React.Component {
    constructor(props) {
        super(props);
        this.state = this.getInitialState();
        this.bindMethods();
    }
    bindMethods() {
        if (! this.bindableMethods) {
            return;
        }   

        for (var methodName in this.bindableMethods) {
            this[methodName] = this.bindableMethods[methodName].bind(this);
        }
    }

    getInitialState() {
        return {
            songPlaying : 'None'
        }
    }

    componentDidMount() {
        NativeAppEventEmitter.addListener('SongPlaying', (songName) => this.setState({songPlaying : songName}))
    }


};

Object.assign(MCDJ.prototype, {
    bindableMethods : {
        render : function() {
            return (
              <View style={styles.container}>
                <Text style={styles.welcome}>
                  Welcome to Modus DJ
                </Text>
                <TouchableHighlight onPress={() => this.onPressButton()}>
                  <Text>Pick Song</Text>
                </TouchableHighlight>
                <Text>Song Playing: {this.state.songPlaying}</Text>
              </View>
            );
        },
        onPressButton : function () {
            MediaController.showSongs();
        }
    }
});

var styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('MCDJ', () => MCDJ);
