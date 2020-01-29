FROM pistacks/alpine AS builder

RUN apk add --no-cache ca-certificates
ADD loki-local-config.yml /etc/loki/local-config.yml
RUN wget --output-document /loki.zip https://github.com/grafana/loki/releases/download/v1.3.0/loki-linux-arm.zip
RUN unzip /loki.zip && mv loki-linux-arm /bin/loki && rm -rf /loki.zip

FROM pistacks/busybox
COPY --from=builder /bin/loki /bin/loki
COPY --from=builder /etc/loki/local-config.yml /etc/loki/local-config.yml

ENTRYPOINT ["/bin/loki"]
CMD        ["-config.file=/etc/loki/local-config.yml"]
