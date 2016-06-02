APRS to Twitter gateway

A few years ago http://www.hamradiotweets.com/ was born.
The website and gateway went strong until the twitter api changed.
The software was originally writen in python and the original developer did not have the time to fix the API issues.

The source was never released and that urged me to create my own version based around ruby and open source it.
The original developer graciously allowed me to take over the original website and twitter handle to run the project.

Check out the website and watch his defcon talk sometime on the project.

Do what you will with it just be curtious and use your legal callsign.

You will find the following code in the script. Please update it with your own information.

  $client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "your_key_here"
  config.consumer_secret     = "your_key_here"
  config.access_token        = "your_key_here"
  config.access_token_secret = "your_key_here"
end

  
  aprs = Aprs.new("second.aprs.net", 20157, "your_callsign_here")
  aprs.connect
  aprs.packet("=4158.19N/08556.81W-", "Twitter Gateway YOUR MSG HERE")

