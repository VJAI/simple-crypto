# SimpleCrypto

A PhoneGap plugin to encrypt strings using RNCryptor/JNCryptor (iOS/Android)

## Usage

The plugin exposes two methods:

```javascript
var rncryptor = cordova.require("com.disusered.simplecrypto.SimpleCrypto");

rncryptor.encrypt(key, data, successCallback, failureCallback)
rncryptor.decrypt(key, data, successCallback, failureCallback)
```

The parameters:

* key: A string to use as your key.
* data: A string representing data to encrypt or decrypt.
* successHandler: Should be a function. Is called when the crypto operation is completed and is shown to the user.
* failureHandler: Should be a function. Is called when there was a problem with the crypto operation.

## Example usage
Useless cyclical example.

```javascript
var rncryptor = cordova.require("com.disusered.simplecrypto.SimpleCrypto");

var key = 'myKey';

function failureCallback(error) {
    console.log('Error: ' + error);
}

function successCallback(encryptedData) {
    console.log('Encrypted data: ' + encryptedData);
    rncryptor.decrypt(key, encryptedData,
        function successCallback(decryptedData) {
            console.log('Decrypted data: ' + decryptedData);
        }, failureCallback);
}

rncryptor.encrypt(key, 'My data to encode', successCallback, failureCallback);
```

## RNCryptor

### iOS

This plugin uses the Objective-C implementation of [RNCryptor](https://github.com/RNCryptor/RNCryptor). RNCryptor is a CCCryptor (AES encryption) wrapper for iOS and Mac. The data format includes all the metadata required to securely implement AES encryption. It is returned as a base64 string ~~using [NSData+Base64](https://github.com/l4u/NSData-Base64)~~. The encrypted blob includes:

* AES-256 encryption
* CBC mode
* Password stretching with PBKDF2
* Password salting
* Random IV
* Encrypt-then-hash HMAC

### Android

This plugin uses the Java implementation of RNCryptor, [JNCryptor](https://github.com/RNCryptor/JNCryptor). JNCryptor is an easy-to-use library for encrypting data with AES. It was ported to Java from the RNCryptor library for iOS.

## Todo
- ~~User defined key~~
- ES6 Promises
