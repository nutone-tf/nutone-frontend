# nutone-frontend

## Getting started with flutter

### Get flutter
Start by installing flutter for your OS. You can use [this page](https://docs.flutter.dev/get-started/install) and choose web as your first type of app to get directed to the appropriate installation guide and follow that.

### Download dependencies
This project depends on some third party packages that are not included on the git repo. Install them with:
```shell
flutter pub get
```

### Launch development preview
The development preview lets you see the effects of the changes you make to the app's code as you work, quickly updating whenever you press r while in the terminal you started it in. It can be started with:
```shell
flutter run --web-browser-flag "--disable-web-security"
```
If you don't include `--web-browser-flag "--disable-web-security"` it won't fetch any data. Nerds can add the `--verbose` flag