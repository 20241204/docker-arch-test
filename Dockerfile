FROM alpine:latest
ADD arch-test.sh /app/
WORKDIR /app
CMD ["/bin/ash", "arch-test.sh"]
