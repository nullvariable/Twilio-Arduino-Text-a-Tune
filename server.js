/**
 * @author Doug Cone
 * Simple NodeJS server, reads Twilio API for text messages and sends them to local serial port
 */

var sys = require("sys");
var express = require('express');
var util = require("util");

/*
  config file similar to this:
  exports.twilio = function (t) {
	switch(t)
	{
		case 'twilio_sid':
			return 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
			break;
		case 'twilio_auth':
			return 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
			break;
		case 'twilio_app_id':
			return 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
			break;
	}
};
 */
var config = require('./config.js');


/*
 * Now we're going to build out our serial connection
 */
  var serialport = require("serialport");
  var SerialPort = serialport.SerialPort; // localize object constructor
  
  var sp = new SerialPort("/dev/ttyACM0", { 
    parser: serialport.parsers.readline("\n") 
  });
  
  sp.on("data", function (data) {
    sys.puts("serial says: "+data);
  });


//now we need a server to listen for Twilio's sms requests

var app = require('express').createServer();
app.use(express.bodyParser());

app.post('/sms', function(req, res){
  console.log(sys.inspect(req.body.Body));
  //make sure we're getting a real Twilio request
  if (config.twilio('twilio_sid') === req.body.AccountSid) {
  	res.send('<Response><Sms>Song Received</Sms></Response>');
  	sp.write(req.body.Body + "END");
  }
});

app.listen(7000);



