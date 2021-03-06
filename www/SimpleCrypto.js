// var crypto = cordova.require("com.disusered.simplecrypto.SimpleCrypto");

var exec = require('cordova/exec');

var SimpleCrypto = function() {};

SimpleCrypto.prototype.encrypt = function(key, data, success, error) {

  if(!success && !error) {
    return new Promise((resolve, reject) => {
      exec(resolve, reject, "SimpleCrypto", "encrypt", [key, data]);
    })
  }
  exec(success, error, "SimpleCrypto", "encrypt", [key, data]);
}

SimpleCrypto.prototype.decrypt = function(key, data, success, error) {
  if(!success && !error) {
    return new Promise((resolve, reject) => {
      exec(resolve, reject, "SimpleCrypto", "decrypt", [key, data]);
    })
  }
  exec(success, error, "SimpleCrypto", "decrypt", [key, data]);
}

var simpleCrypto = new SimpleCrypto();

module.exports = simpleCrypto;
