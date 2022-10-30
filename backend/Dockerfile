FROM golang:1.19-alpine

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY *.go ./
COPY mongodb/*.go ./mongodb/

RUN go build -o main .

EXPOSE 8080

CMD ["/app/main"]