# qml-anitalising-example
Example of anti-aliasing on shape, js-canvas and image

# Layer
Layer disable any antialiasing features of items in QML because it has its own rendering mechanism (TODO investigate what exactly happens)

# JS-Canvas
You need to set renderTarget and renderStrategy.
```
Canvas {
...
  renderTarget: Canvas.FramebufferObject
  renderStrategy: Canvas.Cooperative
...
}
```

# Image
You need to set both antialiasing and mipmap.
```
Image {
...
  antialiasing: true
  mipmap: true
...
}
```

# Shape
Antialiasing allows you to drew shape smoothly however it doesn't work for ColorOverlay (which is layer actually).
