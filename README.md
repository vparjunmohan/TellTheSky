# Tell The Sky -  Weather App

![image](https://user-images.githubusercontent.com/62532677/204082789-e6ce70d2-b4b1-40fb-aa75-6646933b1b31.png)

## Features

- Minimal UI
- Hourly weather forecast
- Weekly weather forecast
- Display wind speed, pressure, humidity
- Additional features like sunrise and sunset
- iPhone and iPad supported

## Requirement

- Xcode 14.0+
- Swift 5.0+

## Installation

- Go to https://openweathermap.org and create an account 
- Subscribe to OpenWeatherMap's  One Call API 3.0 using the following link https://openweathermap.org/api
- One Call API 3.0 allows 2000 API requests per day and have the following features:
> Minute forecast for 1 hour, 
> Hourly forecast for 48 hours, 
> Daily forecast for 8 days, 
> Historical data for 40+ years back by timestamp, 
> National weather alerts
- Copy the API key from your account. If a new API key is generated, it will take an hour to get activated. You can use the default API key provided by OpenWeatherMap.
- Clone the repository.
- Open terminal and navigate to the project directory and create a pod file.

```sh
cd TellTheSky
```
- Click TellTheSky.xcworkspace and Open the project.
<br>
- Go to Utils folder. Open AppUtils.swift file and paste the API key that you have copied.
- For example:
```sh
public static let key: String = "xxxxxxxxxxxxxxx"
```
- Run the project. 
 

## License

MIT License


[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [dill]: <https://github.com/joemccann/dillinger>
   [git-repo-url]: <https://github.com/joemccann/dillinger.git>
   [john gruber]: <http://daringfireball.net>
   [df1]: <http://daringfireball.net/projects/markdown/>
   [markdown-it]: <https://github.com/markdown-it/markdown-it>
   [Ace Editor]: <http://ace.ajax.org>
   [node.js]: <http://nodejs.org>
   [Twitter Bootstrap]: <http://twitter.github.com/bootstrap/>
   [jQuery]: <http://jquery.com>
   [@tjholowaychuk]: <http://twitter.com/tjholowaychuk>
   [express]: <http://expressjs.com>
   [AngularJS]: <http://angularjs.org>
   [Gulp]: <http://gulpjs.com>

   [PlDb]: <https://github.com/joemccann/dillinger/tree/master/plugins/dropbox/README.md>
   [PlGh]: <https://github.com/joemccann/dillinger/tree/master/plugins/github/README.md>
   [PlGd]: <https://github.com/joemccann/dillinger/tree/master/plugins/googledrive/README.md>
   [PlOd]: <https://github.com/joemccann/dillinger/tree/master/plugins/onedrive/README.md>
   [PlMe]: <https://github.com/joemccann/dillinger/tree/master/plugins/medium/README.md>
   [PlGa]: <https://github.com/RahulHP/dillinger/blob/master/plugins/googleanalytics/README.md>
