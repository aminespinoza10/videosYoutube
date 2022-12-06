from flask import Flask
app = Flask(__name__)

@app.route('/gethello')
def hello_world():
    return 'Hello, from Python!'

@app.route('/WeatherForecast')
def getWeatherOnline():
    return 'Today is gonna be a great snowy day for a Python service!'