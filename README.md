# TwitterSwiftLite

This is a light weight pure swift twitter wrapper library that I started because [Swifter](https://github.com/mattdonnelly/Swifter), the go-to swift twitter framework, is not combatible with Linux. This uses Twitter's OAuth 1.0 specifications to authenticate the api requests. Right now this can only send tweets which is enough for my tweet bot but I do plan on adding more functionality. 

## How to
> let keys = TwitterSwiftLiteKeys(
>   consumerKey: "xvz1evFS4wEEPTGEFPHBog",
>   consumerSecret: "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw",
>   oauthToken: "370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb",
>   oauthTokenSecret: "LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE"
> )  
> 
> let tweeter = TwitterSwiftLite(keys: keys)
> tweeter.postTweet("Hey, there twitter world!")
  
