/********* SimpleCrypto.m Cordova Plugin Implementation *******/

#import <Foundation/Foundation.h>
#import <Security/SecRandom.h>
#import <Cordova/CDV.h>
#import "RNEncryptor.h"
#import "RNDecryptor.h"


@interface SimpleCrypto : CDVPlugin {
}

- (void)encrypt:(CDVInvokedUrlCommand*)command;
- (void)decrypt:(CDVInvokedUrlCommand*)command;

@end

@implementation SimpleCrypto

// Key as string

- (void)encrypt:(CDVInvokedUrlCommand *)command
{
    // Plugin result variable
    CDVPluginResult* pluginResult = nil;

    // Save argument at position 0 of array [key]
    NSString *key = [command.arguments objectAtIndex:0];

    // Save argument at position 1 of array [data] as dataToEncrypt
    NSString *dataToEncrypt = [command.arguments objectAtIndex:1];

    // If the first argument exists and the string is not null length
    if (dataToEncrypt != nil && [dataToEncrypt length] > 0 && key != nil && [key length] > 0) {

        // Save as UTF8 data object
        NSData *parsedDataToEncrypt = [dataToEncrypt dataUsingEncoding:NSUTF8StringEncoding];

        // Encrypt data
        NSError *error;
        NSData *encryptedData = [RNEncryptor encryptData:parsedDataToEncrypt
                                            withSettings:kRNCryptorAES256Settings
                                                password:key
                                                   error:&error];

        // Log encrypted value
        NSLog(@"Encryption Key: %@", key);
        
        NSLog(@"Encrypted base64: %@", [encryptedData base64EncodedStringWithOptions:0]);

        // Send success status and encrypted data as base64 string
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[encryptedData base64EncodedStringWithOptions:0]];
    } else {
        // Send error status
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Nothing to encrypt"];
    }

    // Return result to callback
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)decrypt:(CDVInvokedUrlCommand *)command
{
    // Plugin result variable
    CDVPluginResult* pluginResult = nil;

    // Save argument at position 0 of array [key]
    NSString *key = [command.arguments objectAtIndex:0];

    // Save argument at position 1 of array [data] as dataToDecrypt
    NSString *dataToDecrypt = [command.arguments objectAtIndex:1];

    // If the first argument exists and the string is not null length
    if (dataToDecrypt != nil && [dataToDecrypt length] > 0 && key != nil && [key length] > 0) {

        // Convert from base64 to NSData
        NSData *parsedDataToDecrypt = [[NSData alloc] initWithBase64EncodedString:dataToDecrypt options:0];

        // Decrypt data
        NSError *error;
        NSData *decryptedData = [RNDecryptor decryptData:parsedDataToDecrypt
                                            withPassword:key
                                                   error:&error];
        NSString *decryptedDataString = [[NSString alloc]initWithData:decryptedData encoding:NSUTF8StringEncoding];

        // Log encrypted value
        NSLog(@"Decryption Key: %@", key);
        NSLog(@"Decrypted: %@", decryptedDataString);

        // Send success status and decrypted data as string
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:decryptedDataString];
    } else {
        // Send error status
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Nothing to decrypt"];
    }

    // Return result to callback
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
