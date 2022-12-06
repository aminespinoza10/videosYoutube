package main

import (
    "fmt"
    "html"
    "log"
    "net/http"
)

func main() {

    http.HandleFunc("/hello", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, "Hello, %q", html.EscapeString(r.URL.Path))
    })

    http.HandleFunc("/WeatherForecast", func(w http.ResponseWriter, r *http.Request){
        fmt.Fprintf(w, "Today is gonna be a great cloudy day for a go service!")
    })

    log.Fatal(http.ListenAndServe(":8081", nil))
}
