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
  NativeAppEventEmitter,
  SliderIOS
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
                <View style={styles.mainContainer}>
                    <View style={styles.container}>
                        <Text style={styles.welcome}>
                          Welcome to Modus DJ
                        </Text>
                        <TouchableHighlight onPress={() => this.onPressButton()}>
                          <Text>Pick Song</Text>
                        </TouchableHighlight>
                        <Text>Song Playing: {this.state.songPlaying}</Text>
                    </View>
                    <View style={styles.eqContainer}>
                        <Text>High</Text>
                        <SliderIOS
                            style={styles.eq}
                            minimumValue = {-20}
                            maximumValue = {20}
                            value = {0}                            
                            onValueChange = {(eq) => this.onEQChange(eq, 'high')}
                        />
                        <Text>Mid</Text>
                        <SliderIOS
                            style={styles.eq}
                            minimumValue = {-20}
                            maximumValue = {20}
                            value = {0}
                            onValueChange = {(eq) => this.onEQChange(eq, 'mid')}
                        />
                        <Text>Low</Text>
                        <SliderIOS
                            style={styles.eq}
                            minimumValue = {-20}
                            maximumValue = {20}
                            value = {0}
                            onValueChange = {(eq) => this.onEQChange(eq, 'low')}
                        />
                    </View>

     
              </View>
            );
        },
        onPressButton : function () {
            MediaController.showSongs();
        },
        onEQChange : function (value, type) {
            MediaController.applyEQ(value, type);
        }
    }
});

var styles = StyleSheet.create({
    mainContainer : {
        flex : 1
    },
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  eqContainer : {
    flex : 1,
    // alignItems: 'stretch',
    // flexDirection : 'row'
  },
  eq : {
    margin : 20
    // height: 20
  }
});

AppRegistry.registerComponent('MCDJ', () => MCDJ);
