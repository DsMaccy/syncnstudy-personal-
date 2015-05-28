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

  uploadedFile.onload = (e)->
    document.getElementById("avatarimg").setAttribute('src', e.target.result)

  uploadedFile.readAsDataURL(document.getElementById('imgFile').files[0])



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
  name = name.substr(name.lastIndexOf('.'))

  if name == '.jpe'
    return true
  if name == '.jpg'
    return true
  if name == '.jpeg'
    return true
  if name == '.gif'
    return true
  if name == '.png'
    return true
  if name == '.bmp'
    return true
  if name == '.ico'
    return true
  if name == '.svg'
    return true
  if name == '.svgz'
    return true
  if name == '.tif'
    return true
  if name == '.tiff'
    return true
  if name == '.ai'
    return true
  if name == '.drw'
    return true
  if name == '.pct'
    return true
  if name == '.psp'
    return true
  if name == '.xcf'
    return true
  if name == '.psd'
    return true
  if name == '.raw'
    return true
  return false

