### Core Modules ###
path = require('path');
qs = require('querystring');

### Public modules from npm ###
express = require("express")

### Custom Modules ###
#config = require('cloud/config.js');
parseAdaptor = require("cloud/prerender-parse.js")
#app.use require("cloud/prerenderio.js").setAdaptor(parseAdaptor(Parse)).set("prerenderToken", "OnBuGOnWjpPCOA2oC91v")

# These two lines are required to initialize Express in Cloud Code.
app = express()


# Global app configuration section
app.set "views", "cloud/views" # Specify the folder to find templates
app.set "view engine", "ejs" # Set the template engine
app.use express.bodyParser() # Middleware for reading request body

# // Example reading from the request query string of an HTTP get request.
# app.get('/test', function(req, res) {
#   // GET http://example.parseapp.com/test?message=hello
#   res.send(req.query.message);
# });

# // Example reading from the request body of an HTTP post request.
# app.post('/test', function(req, res) {
#   // POST http://example.parseapp.com/test (with request body "message=hello")
#   res.send(req.body.message);
# });

app.post('/auth/signup', (req, res) ->
    username = req.body.email
    password = req.body.password
    name = req.body.displayName

    user = new Parse.User()
    user.set('username', username)
    user.set('password', password)
    user.set('name', name)

    user.signUp().then((user) ->
      res.send(token: user.getSessionToken())
    , (error) ->
      res.status(401).send(message: 'Signup unsuccessful')
    )
)

app.post('/auth/login', (req, res) ->
  Parse.User.logIn(req.body.email, req.body.password).then((user) ->
    res.send(token: user.getSessionToken())
  , (user,error) ->
    res.status(401).send(message: 'Invalid Username or Password')
  )
)

###
app.post('/auth/google', (request, response) ->
    accessTokenUrl = 'https://accounts.google.com/o/oauth2/token'
    peopleApiUrl = 'https://www.googleapis.com/plus/v1/people/me/openIdConnect'
    params =
      code: req.body.code,
      client_id: req.body.clientId,
      client_secret: config.GOOGLE_SECRET,
      redirect_uri: req.body.redirectUri,
      grant_type: 'authorization_code'

)
###

# Attach the Express app to Cloud Code.
app.listen()
