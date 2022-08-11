# Overlayment

![Logo](assets/logo.png)

[![likes](https://img.shields.io/pub/likes/overlayment?logo=dart)](https://pub.dev/packages/overlayment) [![popularity](https://img.shields.io/pub/popularity/overlayment?logo=dart)](https://pub.dev/packages/overlayment) [![pub points](https://img.shields.io/pub/points/overlayment?logo=dart)](https://pub.dev/packages/overlayment) [Online Example](https://overlayment.netlify.app)


This package will help you to manage the overlays in your projects.
Show a dialog, notification, window, or a panel easily. or use one of the helping widgets like AutoComplete, Expander(Dropdown).

To start working with overlayment you need to give to it the `NavigationKey` at the application start or you need to give it the context every time you want to create a new overlayment.

```dart
 @override
  Widget build(BuildContext context) {
    final key = GlobalKey<NavigatorState>();
    Overlayment.navigationKey = key;
    return MaterialApp(
      navigatorKey: key,
      ...
    );
  }
```

**Note**: if you are using [qlevar_router](https://github.com/SchabanBo/qlevar_router) you can use the `key` property of the router to set the `NavigationKey`.

```dart
final router = QRouterDelegate(routes);
Overlayment.navigationKey = router.key;

return MaterialApp.router(
  routeInformationParser: const QRouteInformationParser(),
  routerDelegate: router,
);
```


To show an overlay you can use `Overlayment.show(OverlayType())` or `OverlayType().show()` .
To dismiss an overlay you can use:
- Overlayment.dismiss(OverlayType): Give the overlay object to dismiss,
- Overlayment.dismissName(name): give the overlay name to dismiss.
- Overlayment.dismissLast(). dismiss the last open overlay.
- Overlayment.dismissAll(): dismiss all open overlay, if you set *atSameTime* to true all overlays will dismissed together, otherwise they will be dismissed in the same order they open.

All these methods can take a *result* parameter if you want the overlay to return some value.

| Overlay                               | Example               | Properties                  |
| ------------------------------------- | --------------------- | --------------------------- |
| [OverDialog](#overdialog)             | [example](#example)   | [properties](#properties)   |
| [OverPanel](#overpanel)               | [example](#example-1) | [properties](#properties-1) |
| [OverNotification](#overnotification) | [example](#example-2) | [properties](#properties-2) |
| [OverWindow](#overwindow)             | [example](#example-3) | [properties](#properties-3) |
| [OverAutoComplete](#overautocomplete) | [example](#example-4) | [properties](#properties-4) |
| [OverExpander](#overexpander)         | [example](#example-5) | [properties](#properties-5) |

and there is [Common properties](#common-properties) between all overlays.

## OverDialog

### example

```dart
Overlayment.show(
    OverDialog(
        child: Text('Hello world'),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        ),
    ),
);
```

### Properties

- [backgroundSettings](#background-settings)
- height: The dialog height, if null, the dialog will be fit to the content.
- offset: The offset from the dialog position With this offset, you can move the dialog position for example for up or down left or right.
- width:The dialog width, if null, the dialog will be fit to the content.

## OverPanel
 ### example
 ```dart
Overlayment.show(
   OverPanel(
     child: Text('This is a panel'),
     alignment: Alignment.bottomCenter,
   )
 )
 ```

 ### Properties
- alignment: The Position where the panel should displayed in the screen.
- height: The panel height.
- width: The panel width.
- offset:  The panel offset.
- [backgroundSettings](#background-settings)

## OverNotification

 ### example
 ```dart

Overlayment.show(OverNotification(
    child: Text('This is a notification'),
    alignment: Alignment.topCenter,
    color: Colors.blue.shade200,
));

OverNotification.simple(
    title: 'User logged in',
).show();

OverNotification.simple(
    title: 'Simple notification',
    message: 'This is a simple notification',
    icon: const Icon(Icons.info, color: Colors.green)
).show();

 ```

 ### Properties
- alignment: The Position where the notification should displayed in the screen.
- height: The notification height.
- width: The notification width.
- offset:  The notification offset.
 
## OverWindow

 ### Example
```dart
Overlayment.show(OverWindow(
   position: Offset(50, 50),
   canMove: true,
   child: Text('This is a window'),
));

final result = await OverWindow.simple(message: 'Are you sure?').show<bool?>()
 ```

### Properties

- alignment: The Position where the window should displayed. If the [position] is provided, the [alignment] is ignored.
- [backgroundSettings](#background-settings)
- canMove: Can user drag the window to move it.
- position: The position of the window

OverWindow.simple:

- message: the message to show
- messageStyle: the message text style.
- canCancel: add third button that cancel the window (returns null)
- yesMessage: the text of the first button, default *yes*
- noMessage: the text of the second button, default *no*
- cancelMessage: the text of the third button, default *Cancel*
- body: extra widgets to show between the message and the buttons
canMove: can the user drag the window to move it. default *false*
- alignment: the window location on the screen, default *Alignment.center*

## OverAutoComplete

 The widget is used to suggest options to the user based on the input.

 ### Example
 ```dart
OverAutoComplete<String>(
    loadSuggestions: (q) async => store.where((element) => element.contains(q)).take(5).toList(),
    suggestionsBuilder: (value) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(value),
    ),
    initialValue: "5",
    onSelect: (value) => print(value),
    inputDecoration: const InputDecoration(labelText: 'Enter a number up to 100'),
),
 ```

 ### Properties
 - validator: Validate if the user can select the given value.
 - initialValue: The initial value of the text field.
 - inputDecoration: The TextField input decoration.
 - loadSuggestions: Load the suggestions for the given query.
 - loadingWidget: The widget to display when the suggestions are loading.
 - onSelect: A callback called when the user selects a suggestion.
 - querySelector: A callback to get the value to display in the text field.
 - suggestionsBuilder: A callback to build the suggestion widget.

## OverExpander
Create a widget that can be expanded and collapsed as an overlay.
This widget can be used for example to create a dropdown list.

### Example
```dart
OverExpander<int>(
    child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
            'Selected Index: $_index',
            style: const TextStyle(fontSize: 18, decoration: TextDecoration.underline),
            ),
        ),
    onSelect: (i) {
        if (i != null) {
            setState(() {
                _index = i;
            });
        }
    },
    expandChild: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            children: List.generate(
                10,
                (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                            Overlayment.dismissName<int>(_name, result: index);
                        },
                        child: Text(index.toString()),
                    ),
                ),
            ),
        ),
    ),
)
```

### Properties

- onSelect: an event handler that is called when the user selects an item.
- alignment: The alignment of the overlay relative to the parent. default is the center.
- globalAlignment:The overlay position relative to the screen. if this property is set the *alignment* property will be ignored.
- child: The widget, which the overlay will be expanded from.
- expandChild: The content of the overlay.
- expand: set if the overlay should be displayed or not.
- fitParentWidth:set this to true if you want the overlay to take the same width as the parent, otherwise it will take the width of the content.
- isClickable:  can user click on the child to show the overlay. if false then the expander should be expanded with *expand* set to true.
- offset:  The overlay offset relative to the *child*.

## Common Properties.

### Name
A unique name for the overlay. If you don't set a name, the overlay will be named with the class name. You can use this name to close the overlay later
### OverlayActions
 set custom actions to the overlay events.
 
 - onOpen: run an action right before an overlay is about to open-
 - onReady: run an action after the overlay is opened.
 - canClose:run an action when the overlay is about to close. return [False] to cancel the close action
 - onClose: run an action when the overlay is closed.you can here change the overlay result and return a new one.

### Animation
The animation that will be used to show the overlay.
You can use
TODO
- OverFadeAnimation
- OverSlideAnimation
- OverScaleAnimation
and you can mix them 

### Decoration
The overlay container decoration
### Color
 The overlay background color. If the [decoration] is set, this property will be ignored.
### Margin
the overlay margin 

### Duration
the time to keep the overlay open. When the time is over, the overlay will be closed automatically.If the value is null, the overlay will not be closed automatically.

### Background Settings

You can use this class to set the background *color* and the background *blur* of the layer behind the overlay.
if you set the *dismissOnClick* to true, the overlay will be dismissed when you on the background layer.