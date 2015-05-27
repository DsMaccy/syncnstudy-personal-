app.controller "ProfileCtrl", ($scope,$auth) ->

changeSize = undefined
resetInfo = undefined
updateAccInfo = undefined
validateImageFile = undefined
isImageFile = undefined
uploadImage = undefined

# Changes the image of the avatar to the uploaded file WITHOUT pushing the file to parse
uploadImage = () ->
  imgValidationCheck = validateImageFile()
  if imgValidationCheck == undefined
    return
  if imgValidationCheck != "" # File either too large or not an image
    window.alert(imgValidationCheck) # Create Popup
    document.getElementById("imgFile").value = "" # Clear the Input File Field
    return

  uploadedFile = new FileReader()

  console.log(uploadedFile)
  uploadedFile.onload = (e)->
    document.getElementById("avatarimg").setAttribute('src', e.target.result)

  uploadedFile.readAsDataURL(document.getElementById('imgFile').files[0])
  document.getElementById('avatarimg').setAttribute("src", uploadedFile.target.result)



# Changes the display size of the avatar image
changeSize = (pxSize) ->
  document.getElementById('avatarimg').setAttribute("height", pxSize)
  document.getElementById('avatarimg').setAttribute("width", pxSize)

# Handles the cancel button case
resetInfo = () ->
  document.getElementById('avatarimg').setAttribute('src',"http://static.dezeen.com/uploads/2013/09/dezeen_Kanye-West_1.jpg")
  document.getElementById('name').value = ""
  document.getElementById('uni').value = ""
  document.getElementById('maj').value = ""
  document.getElementById('email').value = ""

# Pushes changes to parse
updateAccInfo = () ->
  imgValidationCheck = validateImageFile()
  if imgValidationCheck != ""
    window.alert(imgValidationCheck) # Create Popup
    return
  ###
    document.getElementById('img').value
    document.getElementById('name').value
    document.getElementById('uni').value
    document.getElementById('maj').value
    document.getElementById('email').value
  ###

# Returns empty_string if the image file is valid
validateImageFile = () ->
  # Check if web browser has file reading capabilities
  if !window.FileReader
    return "Web Browser cannot Read Files"

  inFile = document.getElementById('imgFile')

  if !inFile.files
    return ""
  file = inFile.files[0]
  console.log(file.name)
  console.log(file.size)
  if file.size > 3000000
    return "File too Large"
  if !isImageFile(file.name)
    return "Not an Image File"
  return ""

# Check if the file name is for an image file
isImageFile = (name) ->
  name = name.toLowerCase()
  if name.contains('.jpe')
    return true
  if name.contains('.jpg')
    return true
  if name.contains('.jpeg')
    return true
  if name.contains('.gif')
    return true
  if name.contains('.png')
    return true
  if name.contains('.bmp')
    return true
  if name.contains('.ico')
    return true
  if name.contains('.svg')
    return true
  if name.contains('.svgz')
    return true
  if name.contains('.tif')
    return true
  if name.contains('.tiff')
    return true
  if name.contains('.ai')
    return true
  if name.contains('.drw')
    return true
  if name.contains('.pct')
    return true
  if name.contains('.psp')
    return true
  if name.contains('.xcf')
    return true
  if name.contains('.psd')
    return true
  if name.contains('.raw')
    return true
  return false

