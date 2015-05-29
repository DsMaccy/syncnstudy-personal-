app.factory 'Test', (ParseSDK) ->
  ParseSDK.initialize('H3mf7FlzKF0fZdNIvGntzqI1TWn0y3gWXjB2FIth','muAXvNfPtfay3imFx07NG0YT2ac2Z33qdrsy9fLV')
  ParseSDK.Object.extend(
    className: "Test"
    attrs: ["yolo", "swag"]
  )
