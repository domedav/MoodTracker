import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppNavigator{
  static final List<NavigationHelper> _state = <NavigationHelper>[const NavigationHelper(0,null)].toList();

  static void pop(){
    final idx = _state.length - 1;
    if(idx < 0){
      return;
    }
    final value = _state[_state.length - 1].val;
    switch (value){
      case 0:
        //log('EXIT');
        exit(0);
        break;
      case 1:
        if(_state[idx].callback != null){
          _state[idx].callback!();
        }
        break;
      default:
        break;
    }
    _state.removeAt(idx);
    //log('pop');
    //log(_state.toString());
  }

  static void popWithoutAction(){
    final idx = _state.length - 1;
    if(idx < 0){
      return;
    }
    _state.removeAt(idx);
    //log('pop_silent');
    //log(_state.toString());
  }

  static void push(int s, VoidCallback? c){
    _state.add(NavigationHelper(s,c));
    //log('push');
    //log(_state.toString());
  }

  static void clear(){
    _state.clear();
    _state.add(const NavigationHelper(0,null));
  }
}

class NavigationHelper{
  final int val;
  final VoidCallback? callback;
  const NavigationHelper(this.val, this.callback);

  @override
  String toString() {
    return '$val $callback';
  }
}