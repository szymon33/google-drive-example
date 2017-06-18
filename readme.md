## Quickstart of Google Drive with API Ruby by Szymon

### Introduction

* Just Google Drive API V2 sample integration with your Rails application. 
* Only Google gem as dependency. As simple as possible.

### Features:

1. Dispaly list of files
2. Create folder
3. Finds folder by name
4. Upload file to a specific folder

### Implementation notes

1. Applicatoin deals with only one Google gmail account which has to exist.

2. You have to have credentials file in your ```lib``` folder:

```client_secret.json```

generated by the following wizard:

https://console.developers.google.com/start/api?id=drive

Allow access to application name "Drive API Ruby Quickstart by Szymon"

3. ```MyGoogleDrive``` is the name of implemented Google Drive container when ```client.rb``` is a usage example of that class.
