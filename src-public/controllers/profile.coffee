# Author: Dylan McNamara

changeSize = undefined
changeTitle = undefined
resetInfo = undefined
updateAccInfo = undefined
validateImageFile = undefined
isImageFile = undefined
uploadImage = undefined
current = undefined
updatePlaceHolders = undefined
updateParse = undefined
resetAttr = undefined
#defaultImgURL = 'http://jeanbaptiste.bayle.free.fr/AVATAR/grey_default_avatar1234375017_opensalon.jpg'


updatePlaceHolders = (ParseAttr, PageAttr) ->
  if current.get(ParseAttr)
    document.getElementById(PageAttr).setAttribute('placeholder', current.get(ParseAttr))
  return

resetAttr = (PageAttr) ->
  document.getElementById(PageAttr).value = ""
  return
###
init = () ->
  Parse.initialize('H3mf7FlzKF0fZdNIvGntzqI1TWn0y3gWXjB2FIth','muAXvNfPtfay3imFx07NG0YT2ac2Z33qdrsy9fLV')
  Parse.User.enableRevocableSession()
  return
###

app.controller "ProfileCtrl", ($scope,$auth) ->
  #init()
  Parse.User.become($auth.getToken())
  Parse.User.current().fetch().then (current) ->
    changeTitle(current.get('name'))

    document.getElementById('email').innerHTML = current.get('username')
    if !current.get('University')
      current.set('University', 'University of California, San Diego')
    document.getElementById('uni').innerHTML = current.get('University')

    updatePlaceHolders()



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
  if current.get('Avatar')
    document.getElementById("avatarimg").setAttribute('src', current.get('Avatar').url())
  else
    document.getElementById('avatarimg').setAttribute('src','http://thesocietypages.org/socimages/files/2009/05/vimeo.jpg')
  document.getElementById('name').value = ""
  document.getElementById('maj').value = ""
  document.getElementById('imgFile').value = ""
  document.getElementById('about').value = ""


# Pushes changes to parse
updateAccInfo = () ->
  imgValidationCheck = validateImageFile()
  if imgValidationCheck != ""
    window.alert(imgValidationCheck) # Create Popup
    return
  updateParse()


# Returns empty_string if the image file is valid
validateImageFile = () ->
# Check if web browser has file reading capabilities
  if !window.FileReader
    return "Web Browser cannot Read Files"

  inFile = document.getElementById('imgFile')

  if !inFile.files
    return ""
  file = inFile.files[0]
  if !file
    return ""
  if file.size > 3000000
    return "File too Large"
  if !isImageFile(file.name)
    return "Not an Image File"
  return ""

# Check if the file name is for an image file
isImageFile = (name) ->
  if !name
    return
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

changeTitle = (name) ->
  if name
    string1 = "Hello "
    document.getElementById('title').innerHTML = string1.concat(name)
  else
    document.getElementById('title').innerHTML = "Hello"


updatePlaceHolders = () ->
  Parse.User.current().fetch().then (current) ->
    if current.get('name')
      document.getElementById('name').setAttribute('placeholder', current.get('name'))
    if current.get('major')
      document.getElementById('maj').setAttribute('placeholder', current.get('major'))
    if current.get('avatar')
      document.getElementById('imgFile').setAttribute('placeholder', current.get('avatar'))
    if current.get('AboutMe')
      document.getElementById('about').setAttribute('placeholder', current.get('AboutMe'))
    if current.get('Avatar')
      document.getElementById("avatarimg").setAttribute('src', current.get('Avatar').url())


updateParse = () ->
  Parse.User.current().fetch().then (user) ->
    current = user
    if document.getElementById('name').value
      user.set('name', document.getElementById('name').value,
        {
          success: (currentUsr) ->
            updatePlaceHolders('name', 'name')
            console.log(current.get('name'))
          error: (currentUsr, error) ->
            console.error("There was an issue updating the information")
        })
    if document.getElementById('uni').value
      user.set('University', 'University of California, San Diego',
        {
          success: (currentUsr) ->
            updatePlaceHolders('University', 'uni')
            console.log(current.get('University'))
          error: (currentUsr, error) ->
            console.error("There was an issue updating the information")
        })
    if document.getElementById('maj').value
      user.set('major', document.getElementById('maj').value,
        {
          success: (currentUsr) ->
            updatePlaceHolders('major', 'maj')
            console.log(current.get('major'))
          error: (currentUsr, error) ->
            console.error("There was an issue updating the information")
        })
    if document.getElementById('about').value
      user.set('AboutMe', document.getElementById('about').value,
        {
          error: (currentUsr, error) ->
            console.error("There was an issue updating the information")
        })
    if document.getElementById('imgFile').files[0]
      PFile = new Parse.File(document.getElementById('imgFile').files[0].name,
        document.getElementById('imgFile').files[0])
      user.set('Avatar', PFile,
        {
          error: (currentUsr, error) ->
            console.error("There was an issue updating the information")
        })
    # TODO: Add the save for "AboutME" and
    user.save(null,
      {
        success: (currentUsr) ->
          resetInfo()
          changeTitle(user.get('name'))
          updatePlaceHolders()
        error: (currentUsr, error) ->
          console.error("There was an issue saving the data to the server.  We apologize for the inconvenience :(")
          console.error(error)
      })
