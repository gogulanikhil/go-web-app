FROM golang:1.22.5 AS base
#Creates a working directory inside the container at /app.
WORKDIR /app
#Copies the go.mod file into the working directory.
COPY go.mod .
#Downloads Go module dependencies using go mod download.
RUN go mod download
#Copies the entire project source code into the working directory.
COPY . .
#Builds the Go binary with go build -o main.
RUN go build -o main .
#final stage(to reduce the space ref:abhi-video)
#the image give above for running in image
FROM gcr.io/distroless/base:latest-amd64
#Copies the compiled main binary from the base stage into the final image.
COPY --from=base /app/main/ .
#Copies the static content (if any) from the base stage into a static folder in the image.
COPY --from=base /app/static ./static
EXPOSE 8080
#to run the application
CMD [ "./main" ]